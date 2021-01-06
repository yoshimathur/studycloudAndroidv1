import 'package:flutter/material.dart';

import 'package:study_cloud_android/main.dart';
import 'package:study_cloud_android/homePage.dart';
import 'schoolCodesReference.dart';
import 'enterNamePage.dart';
import 'signUpConstants.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';

class signUp extends StatefulWidget{
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPassTextController = TextEditingController();
  final schoolCodeTextController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(background),
            fit: BoxFit.fill
          ),
        ),
        child: Container(
          color: studycloudyellow.withOpacity(0.9),
          child: ListView(
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
                child: Text('Sign Up!',
                  style: TextStyle(color: studycloudred, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Text(error,
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
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 15),
                child: TextField(
                  controller: confirmPassTextController,
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: studycloudblue)
                      ),
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      hintText: 'Confirm Password'
                  ),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(50, 0, 5, 0),
                      child: TextField(
                        controller: schoolCodeTextController,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: studycloudblue)
                            ),
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            hintText: 'School Code'
                        ),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                      child: IconButton(
                        icon: Icon(Icons.info_outline),
                        color: studycloudred,
                        onPressed: () {
                          showDialog(context: context, builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  codesRef()
                                ],
                              ),
                            );
                          });
                        },
                      )
                  ),
                ],
              ),
              FlatButton(
                child: Text('View Terms and Conditions',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context) {
                    return Dialog(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(terms,
                                    style: TextStyle(color: Colors.black, fontSize: 15),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 25, 50, 0),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Sign Up',
                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed:() {
                    final email = emailTextController.text.toString().trim();
                    final password = passwordTextController.text.toString().trim();
                    final confirmedPass = confirmPassTextController.text.toString().trim();
                    final code = schoolCodeTextController.text.toString().trim();

                    //saving variables to be passed over
                    globals.email = email;
                    globals.schoolCode = code;

                    if (email == '' || password == '' || confirmedPass == '' || code == '') {
                      setState(() {
                        error = 'Please fill out all the fields!';
                      });
                    } else if(RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email) == false) {
                      setState(() {
                        error = 'Please enter a valid email!';
                      });
                    } else if(RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$").hasMatch(password) == false) {
                      setState(() {
                        error = 'Create a stronger password with at least 8 characters, a capital letter, and a number!';
                      });
                    } else if(password != confirmedPass){
                      setState(() {
                        error = 'Passwords do not match!';
                      });
                    } else if(schoolCodesArray.contains(code) == false){
                      setState(() {
                        error = 'Please enter a valid school code!';
                      });
                    } else {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
                          .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => enterName())))
                          .catchError((onError) {
                            setState(() {
                              error = onError.toString();
                            });
                      });
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
                child: Text('By clicking sign up you automatically agree to the Terms and Conditions',
                  style: TextStyle(color: studycloudred, fontSize: 12, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}