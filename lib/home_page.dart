import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    log("from Home Page, init state method invoked");
    super.initState();
    this.checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        log("From Home Page, user is not sign in, go to signup page");
        // going to signup page
        this.navigateToSignupPage();
      }
    });
  }

  navigateToSignupPage() {
    Navigator.pushReplacementNamed(context, "/signup_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome to Home Page"),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: 50.0,
            ),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, "/login_page");
            },
          )
        ],
      ),
    );
  }
}
