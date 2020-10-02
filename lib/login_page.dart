import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  void initState() {
    super.initState();
    this.checkAuth();
  }

  checkAuth() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        debugPrint("user is currently signout");
      } else {
        debugPrint("User is logged in");
        debugPrint("Navigate to Home Page");
        this.navigateToHomePage();
      }
    });
  }

  Future<void> signin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        debugPrint("Email $_email, password $_password");
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        debugPrint("Success login");
        debugPrint("User credential : $userCredential");

        this.navigateToHomePage();
      } on FirebaseAuthException catch (e) {
        String errorMsg;
        if (e.code == 'user-not-found') {
          errorMsg = 'No user found for that email.';
          debugPrint(errorMsg);
          this.showError(errorMsg);
        } else if (e.code == 'wrong-password') {
          errorMsg = 'Wrong password provided for that user.';
          debugPrint(errorMsg);
          this.showError(errorMsg);
        }
      } catch (e) {
        this.showError(e.message);
      }
    }
  }

  showError(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18.0,
            ),
          ),
          content: Text(
            msg,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 15.0,
              ),
              child: Text(
                "Login Form",
                style: TextStyle(
                  fontSize: 30.0,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) =>
                            _email = value.trim().replaceAll(' ', ''),
                        autofocus: false,
                        validator: (input) {
                          if (input.trim().isEmpty) {
                            return "Please provide a valid email";
                          }
                        },
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) => _password = value,
                        autofocus: false,
                        validator: (input) {
                          if (input.trim().isEmpty) {
                            return "Password can't be empty";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: RaisedButton(
                onPressed: () {
                  this.signin();
                },
                color: Colors.greenAccent,
                padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account ?",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      this.navigateToSignupPage();
                    },
                    child: Text(
                      " create account",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToSignupPage() {
    Navigator.pushReplacementNamed(context, "/signup_page");
  }

  navigateToHomePage() {
    Navigator.pushReplacementNamed(context, "/home_page");
  }
}
