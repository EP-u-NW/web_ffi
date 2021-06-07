import 'dart:convert';
import 'proxy_ffi.dart';

String fromCString(Pointer<Uint8> cString) {
  int len = 0;
  while (cString[len] != 0) {
    len++;
  }
  return len > 0 ? ascii.decode(cString.asTypedList(len)) : '';
}

/// Don't forget to free the c string using the same allocator if your are done with it!
Pointer<Uint8> toCString(String dartString, Allocator allocator) {
  List<int> bytes = ascii.encode(dartString);
  Pointer<Uint8> cString = allocator.allocate<Uint8>(bytes.length);
  cString.asTypedList(bytes.length).setAll(0, bytes);
  return cString;
}
