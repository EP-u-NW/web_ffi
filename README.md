# web_ffi
`web_ffi` is a drop-in solution for using `dart:ffi` on the web. This enables you to work with `WebAssembly` more easily and convenient.

The general idea is to expose an API that is compatible with `dart:ffi` but translates all calls through `dart:js` to a browser running `WebAssembly`.

Currently, only `WebAssembly` compiled with [emscripten](https://emscripten.org/) is usable because emscripten also generates the JavaScript imports `WebAssembly` needs. Open a issue on [GitHub](https://github.com/EPNW/web_ffi/) if you think we should support other platforms/compilers, too.

For a tutorial how to use this package (including the compiler settings for emscripten) see the [example/README](./example/README.md), but make sure to read this README first!

## Differences to dart:ffi
While `web_ffi` tries to mimic the `dart:ffi` API as close as possible, there are some differences. The list below documents the most importent ones, make sure to read it. For more insight, take a look at the API documentation.

* `web_ffi` was designed with the [dart:ffi API 2.12.0](https://api.dart.dev/stable/2.12.0/dart-ffi/dart-ffi-library.html) in mind, so there are currently no array extensions (they came with dart 2.13.0)
* There is currently no support for structs (but opaque stucts are available).
* There are some classes and functions that are present in `web_ffi` but not in `dart:ffi`; such things are annotated with [`@extra`](https://pub.dev/documentation/web_ffi/latest/web_ffi_meta/extra-constant.html).
* There is a new class [`Memory`](https://pub.dev/documentation/web_ffi/latest/web_ffi_modules/Memory-class.html) which is **IMPORTANT** and explained in deepth below.
* The [`DynamicLibrary`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibrary-class.html) class constructor is different and requires an instance of the [`@extra Module` class](https://pub.dev/documentation/web_ffi/latest/web_ffi_modules/Module-class.html) .
* If you extend the [`Opaque`](https://pub.dev/documentation/web_ffi/latest/web_ffi/Opaque-class.html) class, you must register the extended class using [`@extra registerOpaqueType<T>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi_modules/registerOpaqueType.html) before using it! Also, your class MUST NOT have type arguments (what should not be a problem).
* There are some rules concerning interacting with native functions, as listed below.

## Rules for functions
There are some rules and things to notice when working with functions:

* When looking up a function using [`DynamicLibrary.lookup<NativeFunction<NF>>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibrary/lookup.html) (or [`DynamicLibraryExtension.lookupFunction<T extends Function, F extends Function>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibraryExtension/lookupFunction.html)) the actuall type argument `NF` (or `T` respectively) of is not used: There is no type checking, if the function exported from `WebAssembly` has the same signature or amount of parameters, only the name is looked up.
* There are special constraints on the return type (not on parameter types) of functions `DF` (or `F` ) if you call [`NativeFunctionPointer.asFunction<DF>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/NativeFunctionPointer/asFunction.html) (or [`DynamicLibraryExtension.lookupFunction<T extends Function, F extends Function>()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibraryExtension/lookupFunction.html) what uses the former internally):
    * You may nest the pointer type up to two times but not more:
        * e.g. `Pointer<Int32>` and `Pointer<Pointer<Int32>>` are allowed but `Pointer<Pointer<Pointer<Int32>>>` is not.
    * If the return type is `Pointer<NativeFunction>` you MUST use `Pointer<NativeFunction<dynamic>>`, everything else will fail. You can restore the type arguments afterwards yourself using casting. On the other hand, as stated above, type arguments for `NativeFunction`s are just ignored anyway.
    * To concretize the things above, [return_types.md](https://github.com/EPNW/web_ffi/tree/master/return_types.md) lists what may be used as return type, everyhing else will cause a runtime error.
    * WORKAROUND: If you need something else (e.g. `Pointer<Pointer<Pointer<Double>>>`), use `Pointer<IntPtr>` and cast it yourselfe afterwards using [`Pointer.cast()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/Pointer/cast.html).

## Memory
The first call you sould do when you want to use `web_ffi` is [`Memory.init()`](https://pub.dev/documentation/web_ffi/latest/web_ffi_modules/Memory/init.html). It has an optional parameter where you can adjust your pointer size. The argument defaults to 4 to represent 32bit pointers, if you use wasm64, call `Memory.init(8)`.
Contraty to `dart:ffi` where the dart process shares all the memory, on `WebAssembly`, each instance is bound to a `WebAssembly.Memory` object. For now, we assume that every `WebAssembly` module you use has it's own memory. If you think we should change that, open a issue on [GitHub](https://github.com/EPNW/web_ffi/) and report your usecase.
Every pointer you use is bound to a memory object. This memory object is accessible using the [`@extra Pointer.boundMemory`](https://pub.dev/documentation/web_ffi/latest/web_ffi/Pointer/boundMemory.html) field. If you want to create a Pointer using the [`Pointer.fromAddress()`](https://pub.dev/documentation/web_ffi/latest/web_ffi/Pointer/Pointer.fromAddress.html) constructor, you may notice the optional `bindTo` parameter. Since each pointer must be bound to a memory object, you can explicitly speficy a memory object here. To match the `dart:ffi` API, the `bindTo` parameter is optional. Because it is optional, there has to be a fallback mechanism if no `bindTo` is specified: The static [`Memory.global`](https://pub.dev/documentation/web_ffi/latest/web_ffi_modules/Memory/global.html) field. If that field is also not set, an exception is thrown when invoking the `Pointer.fromAddress()` constructor.
Also, each [`DynamicLibrary`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibrary-class.html) is bound to a memory object, which is again accessible with [`@extra DynamicLibrary.boundMemory`](https://pub.dev/documentation/web_ffi/latest/web_ffi/DynamicLibrary/boundMemory.html). This might come in handy, since `Memory` implements the [`Allocator`](https://pub.dev/documentation/web_ffi/latest/web_ffi/Allocator-class.html) class.