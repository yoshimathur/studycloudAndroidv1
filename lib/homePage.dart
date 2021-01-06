import 'package:flutter/material.dart';

import 'main.dart';
import 'package:study_cloud_android/signUpProcess/signUpPage.dart';
import 'logInPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class home extends StatelessWidget {

  void checkPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print(prefs.getStringList("Personals"));
  }

  @override
  Widget build(BuildContext context) {

    checkPrefs();

    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: new ExactAssetImage('assets/images/flutter_studycloudbg.png'),
            fit: BoxFit.fill
          ),
      ),
      child: Container(
        color: studycloudyellow.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child:  Text('Welcome to Study Cloud',
                  style: TextStyle(fontSize: 35, color: studycloudred, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 75,
              ),
              FlatButton(
                child: Text('Sign Up',
                  style: TextStyle(fontSize: 25, color: studycloudblue, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                onPressed: () {
                  print('Signing up!');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
                },
              ),
              FlatButton(
                child: Text('Log In',
                  style: TextStyle(fontSize: 25, color: studycloudblue, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                onPressed: () {
                  print('Logging In');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => logIn()));
                },
              ),
              Container(
                height: 50,
              )
            ],
          ),
      ),
    );
  }
}