import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:inject_js/inject_js.dart' as Js;
// Notice that in this file, we import web_ffi and not proxy_ffi.dart
import 'package:web_ffi/web_ffi.dart';
// and additionally
import 'package:web_ffi/web_ffi_modules.dart';

// Note that if you use assets included in a package rather them the main app,
// the _basePath would be different: 'packages/<package_name>/assets'
const String _basePath = 'assets';

Module? _module;

Future<void> initFfi() async {
  // Only initalize if there is no module yet
  if (_module == null) {
    Memory.init();

    // If your generated code would contain something that
    // extends Opaque, you would register it here
    // registerOpaqueType<MyOpaque>();

    // Inject the JavaScript into our page
    await Js.importLibrary('$_basePath/libopus.js');

    // Load the WebAssembly binaries from assets
    String path = '$_basePath/libopus.wasm';
    Uint8List wasmBinaries = (await rootBundle.load(path)).buffer.asUint8List();

    // After we loaded the wasm binaries and injected the js code
    // into our webpage, we obtain a module
    _module = await EmscriptenModule.compile(wasmBinaries, 'libopus');
  }
}

DynamicLibrary openOpus() {
  Module? m = _module;
  if (m != null) {
    return new DynamicLibrary.fromModule(m);
  } else {
    throw new StateError('You can not open opus before calling initFfi()!');
  }
}
