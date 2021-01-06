import 'package:flutter/material.dart';
import 'package:study_cloud_android/homePage.dart';

import 'main.dart';
import 'profilePage.dart';

import 'package:firebase_auth/firebase_auth.dart';

class logIn extends StatefulWidget {
  @override
  _logInState createState() => _logInState();
}

class _logInState extends State<logIn> {

  //constants
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String errorMessage = '';
  int forgotPasswordOpacity = 0;

  //function to set password reset email
  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  //catching the error
  void catchError() {
    setState(() {
      errorMessage = 'Incorrect username or password!';
      passwordTextController.clear();
      forgotPasswordOpacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/flutter_studycloudbg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          color: studycloudyellow.withOpacity(0.9),
          child: Column(
            children: [
              Container(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: studycloudred,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 15, 50, 10),
                child: Text('Log In!',
                  style: TextStyle(color: studycloudred, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Text(errorMessage,
                  style: TextStyle(color: studycloudred, fontSize: 12, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 5, 50, 15),
                child: TextField(
                  controller: emailTextController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: studycloudblue)
                      ),
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      hintText: 'Email'
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 15),
                child: TextField(
                  controller: passwordTextController,
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: studycloudblue)
                      ),
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      hintText: 'Password'
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 25, 50, 0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  color: studycloudblue,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Log In',
                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    print('Welcome back!');
                    final email = emailTextController.text;
                    final password = passwordTextController.text;
                    if (email.trim() == '' || password.trim() == '') {
                      setState(() {
                        errorMessage = 'Please fill out all the fields!';
                      });
                    } else {
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
                          .then((_) => Navigator.push(context, MaterialPageRoute(builder: (context) => profile())))
                          .catchError((error) => catchError());
                    }
                  },
                ),
              ),
              if (forgotPasswordOpacity == 1) Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: FlatButton(
                  child: Text('Forgot Password?',
                    style: TextStyle(color: studycloudred, fontSize: 15),),
                  onPressed: () {
                    resetPassword(emailTextController.text.toString());
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: studycloudblue,
                        content: Text('An email to reset your password was sent to ${emailTextController.text.toString()}. Check your email and follow the directions from there in order to reset your password.',),
                        actions: [
                          FlatButton(
                            child: Text('Continue',
                              style: TextStyle(color: studycloudred),),
                            onPressed: () {
                              setState(() {
                                forgotPasswordOpacity = 0;
                                Navigator.of(context).pop();
                              });
                            },
                          )
                        ],
                      );
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

