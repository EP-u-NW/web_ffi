Allowed return types for functions used as type parameter in [`NativeFunctionPointer.asFunction<DF>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/NativeFunctionPointer/asFunction.html) and [`DynamicLibraryExtension.lookupFunction<T extends Function, F extends Function>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibraryExtension/lookupFunction.html):

* `int`
* `double`
* `bool`
* `void`
* `Pointer<Float>`, `Pointer<Pointer<Float>>`
* `Pointer<Double>`, `Pointer<Pointer<Double>>`
* `Pointer<Int8>`, `Pointer<Pointer<Int8>>`
* `Pointer<Uint8>`, `Pointer<Pointer<Uint8>>`
* `Pointer<Int16>`, `Pointer<Pointer<Int16>>`
* `Pointer<Uint16>`, `Pointer<Pointer<Uint16>>`
* `Pointer<Int32>`, `Pointer<Pointer<Int32>>`
* `Pointer<Uint32>`, `Pointer<Pointer<Uint32>>`
* `Pointer<Int64>`, `Pointer<Pointer<Int64>>`
* `Pointer<Uint64>`, `Pointer<Pointer<Uint64>>`
* `Pointer<IntPtr>`, `Pointer<Pointer<IntPtr>>`
* `Pointer<Opaque>`, `Pointer<Pointer<Opaque>>`
* `Pointer<Void>`, `Pointer<Pointer<Void>>`
* `Pointer<NativeFunction<dynamic>>`, `Pointer<Pointer<NativeFunction<dynamic>>>`
* `Pointer<MyOpaque>`, `Pointer<Pointer<MyOpaque>>` where `MyOpaque` is a class extending `Opaque` and was registered before using [`registerOpaqueType<MyOpaque>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/registerOpaqueType.html)  