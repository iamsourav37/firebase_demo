import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/home_page': (context) => HomePage(),
        '/signup_page': (context) => SignupPage(),
        '/login_page': (context) => LoginPage(),
      },
    );
  }
}
