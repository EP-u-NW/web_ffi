import 'package:web_ffi_example_no_flutter/example_no_flutter.dart';

Future<void> main() async {
  await initFfi();
  DynamicLibrary opus = openOpus();
  FunctionsAndGlobals opusLibinfo = new FunctionsAndGlobals(opus);
  Pointer<Uint8> cString = opusLibinfo.opus_get_version_string();
  print(fromCString(cString));
}
