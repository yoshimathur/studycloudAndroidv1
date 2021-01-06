import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'homePage.dart';
import 'reqHelpPage.dart';
import 'notifPage.dart';
import 'studySharePage.dart';
import 'explorePage.dart';
import 'changeCoursesPage.dart';
import 'programOfStudiesPage.dart';
import 'globals.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class profile extends StatefulWidget{
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {

  String name = 'Loading...';
  String school = 'Loading...';
  int district = 0;
  String grade = 'Loading...';
  String number = '';

  void saveData(String name, String school, int district, String grade, String number) async {
    globals.grade = grade;
    globals.district = district;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> personals = [name, school, district.toString(), grade];
    prefs.setStringList('Personals', personals);
    prefs.setString(number, 'Number');
    if (grade == 'Underclassman') {
      prefs.setBool('Underclassman', true);
    } else {
      prefs.setBool('Underclassman', false);
    }
  }

  void setData(DocumentSnapshot userSnapshot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList("Personals"));
    if (!prefs.containsKey('Personals')) {
      print('Using firebase');
      setState(() {
        name = userSnapshot.data["Name"];
        school = schoolsArray[schoolCodesArray.indexOf(userSnapshot.data["School"])];
        district = userSnapshot.data["District"];
        grade = userSnapshot.data["Grade"];
        number = userSnapshot.data["#"];
        saveData(name, school, district, grade, number);
      });
    } else {
      print("Using defaults");
      setState(() {
        name = prefs.getStringList('Personals')[0];
        school = prefs.getStringList('Personals')[1];
        district = int.parse(prefs.getStringList('Personals')[2]);
        grade = prefs.getStringList('Personals')[3];
        globals.grade = grade;
        globals.district = district;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold (
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: Future.wait([loadSchools(), loadCodes()]),
              builder: (context, schoolSnapshot) {
                if (schoolSnapshot.hasData) {
                  return StreamBuilder(
                    stream: Firestore.instance.collection("Users").document(snapshot.data.uid).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {

                      if (!userSnapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: ExactAssetImage(background),
                                fit: BoxFit.fill
                            ),
                          ),
                          child: Container(
                            color: studycloudyellow.withOpacity(0.9),
                            child: Center(
                              child: Text('Loading Data...',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                textAlign: TextAlign.center,),
                            ),
                          ),
                        );
                      }

                      if(!userSnapshot.data.exists){
                        return incorrectSignUpMessage();
                      }

                      if (userSnapshot.data.data.length < 8) {
                        return incorrectSignUpMessage();
                      }

                      setData(userSnapshot.data);

                      List<dynamic> courses = userSnapshot.data["Courses"];
                      courses.sort();
                      bool isHelper = userSnapshot.data["Helper"];

                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage(background),
                              fit: BoxFit.fill
                          ),
                        ),
                        child: Container(
                            color: studycloudyellow.withOpacity(0.9),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
//                                          SizedBox(
//                                            height: 25,
//                                            width: 25,
//                                            child: IconButton(
//                                              icon: Icon(Icons.chat_bubble_outline),
//                                              color: Colors.black,
//                                              // ignore: missing_return
//                                              onPressed: () {
//                                                Navigator.push(context, MaterialPageRoute(builder: (context) => messagingHome()));
//                                              },
//                                            ),
//                                          ),
//                                          Container(
////                                            width: 5,
////                                          ),
                                          SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: IconButton(
                                              icon: Icon(Icons.settings),
                                              color: Colors.black,
                                              onPressed: () {
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return Dialog(
                                                    backgroundColor: studycloudblue,
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: IconButton(
                                                            icon: Icon(Icons.cancel),
                                                            color: Colors.black,
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: settings(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 15,
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: studycloudblue, width: 3),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image(
                                                      width: 150,
                                                      height: 164,
                                                      image: ExactAssetImage('assets/images/flutter_sudycloudprofileimage.png'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Be a Helper',
                                                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                                                    Switch(
                                                      activeColor: studycloudblue,
                                                      value: (grade != "Underclassman") ? isHelper : false,
                                                      onChanged: (grade == "Underclassman") ? null : (value) {
                                                        Firestore.instance.collection("Users").document(snapshot.data.uid).updateData({ "Helper" : value });
                                                        print(value);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                                                    child: Text(name,
                                                      style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                                    child: Text(school,
                                                      style: TextStyle(color: Colors.black, fontSize: 15),),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: Text(grade,
                                                      style: TextStyle(color: Colors.black, fontSize: 15),),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      if (grade != "Underclassman") Expanded(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: studycloudred, width: 3),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: ListView(
                                              children: [
                                                Container(
                                                  child: Text('Courses',
                                                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                                ),
                                                for (var course in courses) Container(
                                                  child: FlatButton(
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(coursesArray[course],
                                                        style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(context: context, builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          backgroundColor: studycloudblue,
                                                          title: Text('Remove Course'),
                                                          content: Text('Are you sure you would like to remove ${coursesArray[course]}'),
                                                          actions: [
                                                            FlatButton(
                                                              child: Text("Cancel", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text("Confirm", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
                                                              onPressed: () {
                                                                Firestore.instance.collection("Users").document(snapshot.data.uid).updateData({"Courses": FieldValue.arrayRemove([course])})
                                                                    .then((value) => Navigator.of(context).pop());
                                                              },
                                                            ),
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
                                      )
                                    ],
                                  ),
                                ),
                                profileNavBar()
                              ],
                            )
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(background),
                          fit: BoxFit.fill
                      ),
                    ),
                    child: Container(
                      color: studycloudyellow.withOpacity(0.9),
                      child: Center(
                        child: Text('Loading Data...',
                          style: TextStyle(color: Colors.black,fontSize: 20), textAlign: TextAlign.center,),
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return home();
          }
        },
      ),
    );
  }


  Widget settings() {

    final nameChangeTextController = TextEditingController();
    final numberChangeTextController = TextEditingController();
    final schoolChangeTextController = TextEditingController();
    final credentialChangeTextController = TextEditingController();

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(15),
            child: Text('Settings',
              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),)
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Add Courses',
                style: TextStyle(color: Colors.black, fontSize: 17),),
            ),
            onPressed: () {
              if (globals.grade == "Underclassman") {
                return;
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => changeCourses()));
              }
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Program of Studies', style: TextStyle(color: Colors.black, fontSize: 17),),
            ),
            onPressed: () {
              if (globals.grade == "Underclassman") {
                return;
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => programOfStudies()));
              }
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Change Info', style: TextStyle(color: Colors.black, fontSize: 17),),
            ),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                return Dialog(
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.cancel),
                          color: Colors.black,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        child: Text('Information Change Request',
                          style: TextStyle(fontSize: 15), textAlign: TextAlign.center,)
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text('Name Change',
                          style: TextStyle(fontSize: 15),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Container(
                          color: Colors.grey,
                          child: TextField(
                            controller: nameChangeTextController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: studycloudblue),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                            ),
                            maxLines: 4,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text('Phone Number Change',
                          style: TextStyle(fontSize: 15),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Container(
                          color: Colors.grey,
                          child: TextField(
                            controller: numberChangeTextController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: studycloudblue),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                            ),
                            maxLines: 4,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text('School or Grade Change',
                          style: TextStyle(fontSize: 15),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Container(
                          color: Colors.grey,
                          child: TextField(
                            controller: schoolChangeTextController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: studycloudblue),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                            ),
                            maxLines: 4,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text('Email or Password Change',
                          style: TextStyle(fontSize: 15),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Container(
                          color: Colors.grey,
                          child: TextField(
                            controller: credentialChangeTextController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: studycloudblue),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                            ),
                            maxLines: 4,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: RaisedButton(
                          color: studycloudblue,
                          child: Text('Send Request',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          onPressed: () async{
                            if (nameChangeTextController.text.trim() == '' && numberChangeTextController.text.trim() == '' && schoolChangeTextController.text.trim() == '' && credentialChangeTextController.text.trim() == ''){
                              return;
                            } else {
                              final user = await FirebaseAuth.instance.currentUser();
                              String body = '''
                              Name Change: ${nameChangeTextController.text.trim()};
                              
                              Number Change: ${numberChangeTextController.text.trim()};
                              
                              School / Grade Change: ${schoolChangeTextController.text.trim()};
                              
                              Credential Change: ${credentialChangeTextController.text.trim()};
                              
                              ${user.uid}
                              ''';
                              launch("mailto:hills.studycloud@gmail.com?subject=Information Change&body=${body}")
                                  .then((value) => FocusScope.of(context).unfocus());
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Support', style: TextStyle(color: Colors.black, fontSize: 17),),
            ),
            onPressed: () {
              launch("mailto:hills.studycloud@gmail.com?subject=Support&body=What's up?");
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Terms', style: TextStyle(color: Colors.black, fontSize: 17),),
            ),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context){
                return Dialog(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.cancel),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: ListView(
                            children: [
                              Text(terms, style: TextStyle(color: Colors.black, fontSize: 15),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Log Out', style: TextStyle(color: studycloudred, fontSize: 17),),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear().then((value) {
                FirebaseAuth.instance.signOut()
                    .then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => home() ));
                }).catchError((onError) => print(onError.toString()));
              }).catchError((onError) => print(onError.toString()));
            },
          ),
        ),
      ],
    );
  }
}

class profileNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: studycloudblue, width: 3)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: FlatButton(
                child: Image(
                  height: 25,
                  width: 36,
                  image: AssetImage(navBarReqHelp),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => reqHelp()));
                },
              )
          ),
          Expanded(
              child: FlatButton(
                child: Image(
                  height: 25,
                  width: 30,
                  image: AssetImage(navBarNotif),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => notif()));
                },
              )
          ),
          Expanded(
              child: FlatButton(
                  child: Image(
                    height: 25,
                    width: 30,
                    image: AssetImage(navBarHome),
                  ),
                  onPressed: null
              )
          ),
          Expanded(
            child: FlatButton(
              child: Image(
                height: 25,
                width: 30,
                image: AssetImage(navBarClubs),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => studyShare()));
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Image(
                height: 25,
                width: 30,
                image: AssetImage(navBarExplore),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => explore()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class incorrectSignUpMessage extends StatelessWidget{

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
          child: Container(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Text('Your account was not set up properly because you exited the app during the sign up process! Enter the credentials that you used to half-register yourself and then sign up again correctly. If you do not remember your credentials, please contact support.',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: TextField(
                    controller: emailTextController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        hintText: 'Email'
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: TextField(
                    controller: passwordTextController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        hintText: 'Password'
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                FlatButton(
                  child: Text('Continue',
                    style: TextStyle(color: Colors.black, fontSize: 15), textAlign: TextAlign.center,),
                  onPressed: () async {

                    final user = await FirebaseAuth.instance.currentUser();
                    final email = emailTextController.text.trim();
                    final password = passwordTextController.text.trim();

                    if(email.isEmpty || password.isEmpty) {
                      print('No info');
                    } else {
                      user.reauthenticateWithCredential(EmailAuthProvider.getCredential(email: email, password: password))
                          .catchError((onError) => print(onError.toString()));

                      final document = await Firestore.instance.collection("Users").document(user.uid).get();

                      if (document.exists) {
                        Firestore.instance.collection("Users").document(user.uid).delete()
                            .catchError((onError) => print(onError.toString()));
                        user.delete()
                            .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => home())))
                            .catchError((onError) => print(onError.toString()));
                      } else {
                        user.delete()
                            .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => home())))
                            .catchError((onError) => print(onError.toString()));
                      }
                    }
                  }
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}