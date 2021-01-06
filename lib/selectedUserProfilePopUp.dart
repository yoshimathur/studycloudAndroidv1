import 'package:flutter/material.dart';

import 'main.dart';
import 'globals.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class user2PopUp extends StatelessWidget {

  String userUID = globals.selectedUID;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("Users").document(userUID).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Container(
            child: Center(
              child: Text('Loading...',
                style: TextStyle(fontSize: 15),),
            ),
          );
        } else {

          var courses = snapshot.data['Courses'];

          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 25),
                  child: Text(snapshot.data['Name'],
                    style: TextStyle(color: studycloudred, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text('Student Info',
                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                  child: Text('Grade: ${snapshot.data['Grade']}',
                    style: TextStyle(color: Colors.black, fontSize: 17),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 15),
                  child: Text('School: ${schoolsArray[schoolCodesArray.indexOf(snapshot.data['School'])]}',
                    style: TextStyle(color: Colors.black, fontSize: 17),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text('Courses',
                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: (snapshot.data['Courses'] == null) ? Center(child: Text('No courses...', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),): ListView(
                      children: [
                        for (var course in courses) Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black26)
                            )
                          ),
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(coursesArray[course],
                            style: TextStyle(fontSize: 17),),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}