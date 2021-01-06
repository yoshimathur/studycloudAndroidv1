import 'package:flutter/material.dart';

import 'main.dart';
import 'profilePage.dart';

class programOfStudies extends StatefulWidget {
  @override
  _programOfStudiesState createState() => _programOfStudiesState();
}

class _programOfStudiesState extends State<programOfStudies> {

  List<String> displayedCoursesArray = mathCourses;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(background),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
                  },
                ),
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
                      for (var course in displayedCoursesArray) Container(
                        child: FlatButton(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(course, style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
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