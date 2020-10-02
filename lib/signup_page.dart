import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _email, _password;

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

  showError(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(msg),
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

  Future<void> signup() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      debugPrint("Name : $_name, Email : $_email, Password : $_password");
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password);
        debugPrint("Account created for $userCredential user");
        this.navigateToHomePage();
      } on FirebaseAuthException catch (e) {
        String errorMsg;
        if (e.code == 'weak-password') {
          errorMsg = 'The password provided is too weak.';
          debugPrint(errorMsg);
          this.showError(errorMsg);
        } else if (e.code == 'email-already-in-use') {
          errorMsg = 'The account already exists for that email.';
          debugPrint(errorMsg);
          this.showError(errorMsg);
        }
      } catch (e) {
        debugPrint(e.toString());
        this.showError(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 15.0,
              ),
              child: Text(
                "Signup Form",
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
                        onSaved: (value) => _name = value.trim(),
                        autofocus: false,
                        validator: (input) {
                          if (input.trim().isEmpty) {
                            return "Please provide your name";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
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
                          return null;
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
                          } else if (input.length < 6) {
                            return "Password should be atleast 6 character";
                          }
                          return null;
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
                  this.signup();
                },
                color: Colors.greenAccent,
                padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Text(
                  "Signup",
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
                    "Already have account?",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      this.navigateToLoginPage();
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.green,
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

  navigateToHomePage() {
    Navigator.pushReplacementNamed(context, "/home_page");
  }

  navigateToLoginPage() {
    Navigator.pushReplacementNamed(context, "/login_page");
  }
}
