/// Contains methods and structs from the opus_libinfo group of opus_defines.h.
///
/// AUTOMATICALLY GENERATED FILE. DO NOT MODIFY.

library opus_libinfo;

import 'proxy_ffi.dart' as ffi;

typedef _opus_get_version_string_C = ffi.Pointer<ffi.Uint8> Function();
typedef _opus_get_version_string_Dart = ffi.Pointer<ffi.Uint8> Function();

class FunctionsAndGlobals {
  FunctionsAndGlobals(ffi.DynamicLibrary _dynamicLibrary)
      : _opus_get_version_string = _dynamicLibrary.lookupFunction<
            _opus_get_version_string_C, _opus_get_version_string_Dart>(
          'opus_get_version_string',
        );

  /// Gets the libopus version string.
  ///
  /// Applications may look for the substring "-fixed" in the version string to determine whether they have a fixed-point or floating-point build at runtime.
  ///
  /// @returns Version string
  ffi.Pointer<ffi.Uint8> opus_get_version_string() {
    return _opus_get_version_string();
  }

  final _opus_get_version_string_Dart _opus_get_version_string;
}
