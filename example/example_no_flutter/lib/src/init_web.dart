// Notice that in this file, we import web_ffi and not proxy_ffi.dart
import 'package:web_ffi/web_ffi.dart';
// and additionally
import 'package:web_ffi/web_ffi_modules.dart';

Module? _module;

Future<void> initFfi() async {
  // Only initalize if there is no module yet
  if (_module == null) {
    Memory.init();

    // If your generated code would contain something that
    // extends Opaque, you would register it here
    // registerOpaqueType<MyOpaque>();

    // We use the process function here since we added
    // libopus.js to our html with a <script> tag
    _module = await EmscriptenModule.process('libopus');
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
