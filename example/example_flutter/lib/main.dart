import 'package:flutter/material.dart';
import 'src/proxy_ffi.dart';
import 'src/c_strings.dart';
import 'src/generated.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFfi();
  DynamicLibrary dynLib = openOpus();
  FunctionsAndGlobals opusLibinfo = FunctionsAndGlobals(dynLib);
  String version = fromCString(opusLibinfo.opus_get_version_string());
  runApp(MyApp(version));
}

class MyApp extends StatelessWidget {
  final String _opusVersion;

  const MyApp(this._opusVersion);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'web_ffi Demo',
      home: Scaffold(
          appBar: AppBar(
            title: Text('web_ffi Demo'),
            centerTitle: true,
          ),
          body: Container(
            alignment: Alignment.center,
            child: Text(_opusVersion),
          )),
    );
  }
}
