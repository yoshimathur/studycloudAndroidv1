import 'package:flutter/material.dart';
import 'dart:math';

import 'package:study_cloud_android/main.dart';
import 'package:study_cloud_android/profilePage.dart';
import 'selectCoursesPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class selectGrade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                height: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text('Please select the grade that you are in. If you are not in high school, then select underclassman.',
                  style: TextStyle(color: studycloudred, fontSize: 15), textAlign: TextAlign.center,),
              ),
              Container(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Underclassman',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    final user = await FirebaseAuth.instance.currentUser();
                    Firestore.instance.collection("Users").document(user.uid).updateData({"Grade" : "Underclassman", "Helper" : false})
                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => profile())))
                        .catchError((onError) => print(onError.toString()));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Freshman',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    final user = await FirebaseAuth.instance.currentUser();
                    final tag = Random().nextInt(100);
                    Firestore.instance.collection("Users").document(user.uid).updateData({"Grade" : "Freshman", "Helper" : true, "Tag" : tag})
                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => selectCourses())))
                        .catchError((onError) => print(onError.toString()));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Sophomore',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    final user = await FirebaseAuth.instance.currentUser();
                    final tag = Random().nextInt(100);
                    Firestore.instance.collection("Users").document(user.uid).updateData({"Grade" : "Sophomore", "Helper" : true, "Tag" : tag})
                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => selectCourses())))
                        .catchError((onError) => print(onError.toString()));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Junior',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    final user = await FirebaseAuth.instance.currentUser();
                    final tag = Random().nextInt(100);
                    Firestore.instance.collection("Users").document(user.uid).updateData({"Grade" : "Junior", "Helper" : true, "Tag" : tag})
                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => selectCourses())))
                        .catchError((onError) => print(onError.toString()));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Senior',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    final user = await FirebaseAuth.instance.currentUser();
                    final tag = Random().nextInt(100);
                    Firestore.instance.collection("Users").document(user.uid).updateData({"Grade" : "Senior", "Helper" : true, "Tag" : tag})
                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => selectCourses())))
                        .catchError((onError) => print(onError.toString()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}