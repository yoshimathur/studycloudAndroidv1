import 'package:flutter/material.dart';
import 'dart:math';

import 'package:study_cloud_android/main.dart';
import 'selectGradePage.dart';
import 'signUpConstants.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class enterName extends StatefulWidget {
  @override
  _enterNameState createState() => _enterNameState();
}

class _enterNameState extends State<enterName> {
  
  final nameTextController = TextEditingController();
  final numberTextController = TextEditingController();
  String error = "";

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
                height: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text('Thank you for signing up with us! We need to ask you a few more questions to finish setting up your profile. Please fill out your name and a number you can be reached at.',
                  style: TextStyle(color: studycloudred, fontSize: 15), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 25, 15, 10),
                child: Text(error, 
                  style: TextStyle(color: studycloudred, fontSize: 12, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: TextField(
                  controller: nameTextController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: studycloudblue)
                      ),
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      hintText: 'Full Name'
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
                child: TextField(
                  controller: numberTextController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: studycloudblue)
                    ),
                    contentPadding: EdgeInsets.all(8),
                    isDense: true,
                    hintText: 'Phone Number'
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Save',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    if (nameTextController.text.isEmpty || numberTextController.text.isEmpty) {
                      setState(() {
                        error = "Please fill out all information!";
                      });
                    } else {
                      final user = await FirebaseAuth.instance.currentUser();
                      final email = globals.email;
                      final schoolCode = globals.schoolCode;
                      final name = nameTextController.text.trim();
                      final number = numberTextController.text.trim();
                      final tag = Random().nextInt(1001);
                      String uid = user.uid;

                      //getting district 
                      final school = schoolsArray[schoolCodesArray.indexOf(schoolCode)];
                      int splice = school.indexOf(',');
                      String district = school.substring(splice, school.length);
                      List<String> districtSchools = schoolsArray.where((school) => school.toLowerCase().trim().contains(district.toLowerCase().trim())).toSet().toList();
                      int districtCode = schoolsArray.indexOf(districtSchools.first);

                      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
                      userUpdateInfo.displayName = name;
                      user.updateProfile(userUpdateInfo);
                      Firestore.instance.collection("Users").document(uid).setData({"Name" : name, "School" : schoolCode, "District" : districtCode, "#" : number })
                          .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => selectGrade())))
                          .catchError((onError) => print(onError.toString()));
                    }
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