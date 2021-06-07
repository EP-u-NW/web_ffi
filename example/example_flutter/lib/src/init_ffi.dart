// Notice that in this file, we import dart:ffi and not proxy_ffi.dart
import 'dart:ffi';

// For dart:ffi platforms, this can be a no-op (empty function)
Future<void> initFfi() async {
// If you ONLY want to support web, uncomment this exception
// throw new UnsupportedError('This package is only usable on the web!');
}

DynamicLibrary openOpus() {
// If you ONLY want to support web, uncomment this exception
// throw new UnsupportedError('This package is only usable on the web!');
  return new DynamicLibrary.open('libopus.so');
}
