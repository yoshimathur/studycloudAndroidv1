import 'package:flutter/material.dart';

import 'package:study_cloud_android/main.dart';
import 'package:study_cloud_android/profilePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class selectCourses extends StatefulWidget {
  @override
  _selectCoursesState createState() => _selectCoursesState();
}

class _selectCoursesState extends State<selectCourses> {

  List<String> displayedCoursesArray = mathCourses;
  List<int> selectedCoursesArray = [];
  Map<String, bool> courseStatesMap = Map.fromIterable(coursesArray, key: (course) => course, value: (course) => false);

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Text('Select the courses you are currently in. Deselect any courses you are not comfortable with teaching.',
                    style: TextStyle(color: studycloudred, fontSize: 15), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 1; i <= 21; i++) Container(
                      width: (i%2 == 0) ? 15 : 150,
                      child: subjectButtons(i),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: ListView(
                    children: [
                      for(var course in displayedCoursesArray) Container(
                        color: (!courseStatesMap[course]) ? Colors.transparent : studycloudblue.withOpacity(0.5),
                        child: FlatButton(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(course, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                          ),
                          onPressed: () {
                            if(courseStatesMap[course]) {
                              //deselecting course
                              setState(() {
                                courseStatesMap[course] = false;
                                selectedCoursesArray.remove(coursesArray.indexOf(course));
                                print(selectedCoursesArray);
                              });
                            } else {
                              //selecting courses
                              final courseDisplayIndex = displayedCoursesArray.indexOf(course);
                              if(displayedCoursesArray != electiveCourses) {
                                for (var i = 0; i <= courseDisplayIndex; i+=1) {
                                  final courseIndex = coursesArray.indexOf(displayedCoursesArray[i]);
                                  if (!selectedCoursesArray.contains(courseIndex)) {
                                    setState(() {
                                      selectedCoursesArray.add(courseIndex);
                                      courseStatesMap[coursesArray[courseIndex]] = true;
                                    });
                                  }
                                }
                              } else {
                                setState(() {
                                  courseStatesMap[course] = true;
                                  selectedCoursesArray.add(coursesArray.indexOf(course));
                                });
                              }
                              print(selectedCoursesArray);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: RaisedButton(
                  color: studycloudblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text('Save',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onPressed: () async {
                    final user = await FirebaseAuth.instance.currentUser();
                    Firestore.instance.collection("Users").document(user.uid).updateData({"Courses" : selectedCoursesArray})
                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => profile())))
                        .catchError((onError) => print(onError.toString()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget subjectButtons(int i) {

    switch(i) {
      case 1: {
        return RaisedButton(
          color: (displayedCoursesArray == mathCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Math",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == mathCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = mathCourses;
            });
          },
        );
      }
      break;
      case 3: {
        return RaisedButton(
          color: (displayedCoursesArray == lalCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Language Arts",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == lalCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = lalCourses;
            });
          },
        );
      }
      break;
      case 5: {
        return RaisedButton(
          color: (displayedCoursesArray == scienceCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Science",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == scienceCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = scienceCourses;
            });
          },
        );
      }
      break;
      case 7: {
        return RaisedButton(
          color: (displayedCoursesArray == historyCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("History",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == historyCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = historyCourses;
            });
          },
        );
      }
      break;
      case 9: {
        return RaisedButton(
          color: (displayedCoursesArray == spanishCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Spanish",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == spanishCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = spanishCourses;
            });
          },
        );
      }
      break;
      case 11: {
        return RaisedButton(
          color: (displayedCoursesArray == frenchCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("French",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == frenchCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = frenchCourses;
            });
          },
        );
      }
      break;
      case 13: {
        return RaisedButton(
          color: (displayedCoursesArray == italianCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Italian",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == italianCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = italianCourses;
            });
          },
        );
      }
      break;
      case 15: {
        return RaisedButton(
          color: (displayedCoursesArray == germanCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("German",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == germanCourses) ? Colors.white : Colors.black,)),
          onPressed: () {
            setState(() {
              displayedCoursesArray = germanCourses;
            });
          },
        );
      }
      break;
      case 17: {
        return RaisedButton(
          color: (displayedCoursesArray == japaneseCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Japanese",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == japaneseCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = japaneseCourses;
            });
          },
        );
      }
      break;
      case 19: {
        return RaisedButton(
          color: (displayedCoursesArray == chineseCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Chinese",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == chineseCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = chineseCourses;
            });
          },
        );
      }
      break;
      case 21: {
        return RaisedButton(
          color: (displayedCoursesArray == electiveCourses) ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("AP Electives",
              style: TextStyle(fontSize: 15, color: (displayedCoursesArray == electiveCourses) ? Colors.white : Colors.black,) ),
          onPressed: () {
            setState(() {
              displayedCoursesArray = electiveCourses;
            });
          },
        );
      }
      break;
    }
  }
}

