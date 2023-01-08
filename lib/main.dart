import 'package:appchecktest/firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var _kFF = FirebaseFunctions.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.ios, name: 'app-check-test');
  await FirebaseAppCheck.instance.activate();
  //_kFF.useFunctionsEmulator("192.168.1.179", 5001);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Check Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter App Check Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String funcRet = 'None';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        var res = await _kFF.httpsCallable('helloWorld').call();
        setState(() {
          funcRet = res.data;
        });
      } catch (e) {
        setState(() {
          funcRet = "Failed";
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: funcRet == "None"
            ? const CircularProgressIndicator()
            : Text(
                'App Check Working: $funcRet',
                style: const TextStyle(fontSize: 20),
              ),
      ),
    );
  }
}
