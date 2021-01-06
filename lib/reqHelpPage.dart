import 'package:flutter/material.dart';

import 'main.dart';
import 'profilePage.dart';
import 'notifPage.dart';
import 'explorePage.dart';
import 'studySharePage.dart';
import 'selectedUserProfilePopUp.dart';
import 'globals.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class reqHelp extends StatefulWidget {
  @override
  _reqHelpState createState() => _reqHelpState();
}

class _reqHelpState extends State<reqHelp> {

  String error = '';
  final searchBarController = TextEditingController();
  String search = '';
  String searchType = 'Local';
  List<String> helpersArray = [];

  void courseSearch(String search) async{
    final user = await FirebaseAuth.instance.currentUser();
    helpersArray.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String grade = (prefs.getStringList('Personals')[3] != null) ? prefs.getStringList('Personals')[3] : globals.grade;
    int district = (int.parse(prefs.getStringList('Personals')[2]) != null) ? int.parse(prefs.getStringList('Personals')[2]) : globals.district;
    final cleanedCourses = coursesArray.map((e) => e.toLowerCase().trim(),).toList();

    if(grade != null && district != null) {
      switch(grade) {
        case 'Underclassman': {
          switch(searchType) {
            case 'Local': {
              int count = 0;
              Firestore.instance.collection("Users")
                  .where("District", isEqualTo: district)
                  .where("Helper", isEqualTo: true)
                  .orderBy("Tag")
                  .getDocuments().then((snapshot) {
                    for(var document in snapshot.documents) {
                      if (count == 15){
                        break;
                      }
                      setState(() {
                        error = '';
                        helpersArray.add(document.documentID);
                        count++;
                      });
                    }
                    if (helpersArray.isEmpty) {
                      setState(() {
                        error = 'No helpers could be found! Try searching the cloud!';
                      });
                    }
              }).catchError((onError) {
                print(onError.toString());
                setState(() {
                  error = onError.toString();
                });
              });
            }
            print(helpersArray);
            break;
            case "Cloud": {
              int count = 0;
              Firestore.instance.collection("Users")
                  .where("Helper", isEqualTo: true)
                  .orderBy("Tag")
                  .getDocuments().then((snapshot) {
                for(var document in snapshot.documents) {
                  if (count == 15){
                    break;
                  }
                  setState(() {
                    error = '';
                    helpersArray.add(document.documentID);
                    count++;
                  });
                }
                if (helpersArray.isEmpty) {
                  setState(() {
                    error = 'No helpers could be found! Spread the word about the app to get the help you need!';
                  });
                }
              }).catchError((onError) {
                print(onError.toString());
                setState(() {
                  error = onError.toString();
                });
              });
            }
            print(helpersArray);
            break;
          }
        }
        break;
        default: {
          if (cleanedCourses.contains(search)) {
            saveSearch(search);
            switch(searchType) {
              case "Local": {
                int count = 0;
                Firestore.instance.collection("Users")
                    .where("District", isEqualTo: district)
                    .where("Helper", isEqualTo: true)
                    .orderBy("Tag")
                    .getDocuments().then((snapshot) {
                  for(var document in snapshot.documents) {
                    if (count == 15){
                      break;
                    }
                    if (document.documentID != user.uid) {
                      final courses = document['Courses'];
                      if (courses != null) {
                        if(courses.contains(cleanedCourses.indexOf(search))) {
                          setState(() {
                            error = '';
                            helpersArray.add(document.documentID);
                            count++;
                          });
                        }
                      }
                    }
                  }
                  if (helpersArray.isEmpty) {
                    setState(() {
                      error = 'No local helpers could be found! Try searching the cloud!';
                    });
                  }
                }).catchError((onError) {
                  print(onError.toString());
                  setState(() {
                    error = onError.toString();
                  });
                });
              }
              print(helpersArray);
              break;
              case "Cloud": {
                int count = 0;
                Firestore.instance.collection("Users")
                    .where("Helper", isEqualTo: true)
                    .orderBy("Tag")
                    .getDocuments().then((snapshot) {
                  for(var document in snapshot.documents) {
                    if (count == 15){
                      break;
                    }
                    if (document.documentID != user.uid) {
                      final courses = document['Courses'];
                      if (courses != null) {
                        if(courses.contains(cleanedCourses.indexOf(search))) {
                          setState(() {
                            error = '';
                            helpersArray.add(document.documentID);
                            count++;
                          });
                        }
                      }
                    }
                  }
                  if (helpersArray.isEmpty) {
                    setState(() {
                      error = 'No helpers could be found! Spread the word about the app to get the help you need!';
                    });
                  }
                }).catchError((onError) {
                  print(onError.toString());
                  setState(() {
                    error = onError.toString();
                  });
                });
              }
              print(helpersArray);
              break;
            }
          } else {
            setState(() {
              error = 'No results. Invalid search! Check Program of Studies to make sure you are searching for a valid course name.';
              helpersArray.clear();
            });
          }
        }
      }
    }
  }

  //subject button search
  void courseGroupSearch(List<String> array) async {
    final user = await FirebaseAuth.instance.currentUser();
    helpersArray.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int district = (int.parse(prefs.getStringList('Personals')[2]) != null) ? int.parse(prefs.getStringList('Personals')[2]) : globals.district;
    int count = 0;
    
    if (district != null) {
      switch(searchType) {
        case 'Local': {
          Firestore.instance.collection("Users")
              .where("District", isEqualTo: district)
              .where("Helper", isEqualTo: true)
              .orderBy("Tag")
              .getDocuments().then((snapshot) {
                for (var document in snapshot.documents) {
                  print(document.documentID);
                  if (count == 15) {
                    break;
                  }
                  if (document.documentID != user.uid) {
                    var courses = document['Courses'];
                    if (courses != null) {
                      for (var i in courses) {
                        String course = coursesArray[i];
                        if (array.contains(course)) {
                          setState(() {
                            error = '';
                            helpersArray.add(document.documentID);
                            count++;
                          });
                          break;
                        }
                      }
                    }
                  }
                }
                print(helpersArray);
                if (helpersArray.length == 0) {
                  setState(() {
                    error = 'No local helpers could be found for this subject area! Try searching the cloud!';
                  });
                }
          }).catchError((onError) {
            print(onError.toString());
            setState(() {
              error = onError.toString();
            });
          });
        }
        break;
        case 'Cloud': {
          Firestore.instance.collection("Users")
              .where("Helper", isEqualTo: true)
              .orderBy("Tag")
              .getDocuments().then((snapshot) {
            for (var document in snapshot.documents) {
              print(document.documentID);
              if (count == 15) {
                break;
              }
              if (document.documentID != user.uid) {
                var courses = document['Courses'];
                for (var i in courses) {
                  String course = coursesArray[i];
                  if (array.contains(course)) {
                    setState(() {
                      error = '';
                      helpersArray.add(document.documentID);
                      count++;
                    });
                    break;
                  }
                }
              }
            }
            print(helpersArray);
            if (helpersArray.length == 0) {
              setState(() {
                error = 'No helpers could be found! Spread word of the app to get the help you need!';
              });
            }
          }).catchError((onError) {
            print(onError.toString());
            setState(() {
              error = onError.toString();
            });
          });
        }
      }
    }
  }

  void saveSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> array = prefs.getStringList('RecentSearches');
    if (array != null) {
      array.add(search);
      if (array.length > 15) {
        array.removeAt(0);
        prefs.setStringList('RecentSearches', array);
      } else {
        prefs.setStringList('RecentSearches', array);
      }
    } else {
      List<String> newArray = [search];
      prefs.setStringList('RecentSearches', newArray);
    }
  }

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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 50, 15, 5),
                child: Text('Request Help',
                  style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                child: Text(error,
                  style: TextStyle(color: studycloudred, fontSize: 12, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: studycloudyellow,
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: TextField(
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            controller: searchBarController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: studycloudblue)
                              ),
                              contentPadding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                              isDense: true,
                              hintText: "Course Name",
                            ),
                            onTap: () {
                              //search bar started editing
                              setState(() {
                                search = '';
                                error = '';
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: FlatButton(
                          child: Text("Search",
                            style: TextStyle(fontSize: 15, color: Colors.black), textAlign: TextAlign.center,),
                          onPressed: () {
                            //search for course title
                            FocusScope.of(context).unfocus();
                            setState(() {
                              search = searchBarController.text.toString();
                            });
                            courseSearch(search.toLowerCase().trim());
                          },
                        ),
                      ),
                    ],
                  ),
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
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: (searchType == 'Local') ? studycloudred : studycloudblue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('Search Local',
                          style: TextStyle(fontSize: 15, color: (searchType == 'Local') ? Colors.white : Colors.black),),
                        onPressed: (searchType == 'Local') ? () {return;} : () {
                          setState(() {
                            searchType = 'Local';
                            error = '';
                          });
                          switch(search) {
                            case 'Math': {
                              courseGroupSearch(mathCourses);
                            }
                            break;
                            case 'LAL': {
                              courseGroupSearch(lalCourses);
                            }
                            break;
                            case 'Science': {
                              courseGroupSearch(scienceCourses);
                            }
                            break;
                            case 'History': {
                              courseGroupSearch(historyCourses);
                            }
                            break;
                            case 'Spanish': {
                              courseGroupSearch(spanishCourses);
                            }
                            break;
                            case 'French': {
                              courseGroupSearch(frenchCourses);
                            }
                            break;
                            case 'Italian': {
                              courseGroupSearch(italianCourses);
                            }
                            break;
                            case 'German': {
                              courseGroupSearch(germanCourses);
                            }
                            break;
                            case 'Japanese': {
                              courseGroupSearch(japaneseCourses);
                            }
                            break;
                            case 'Chinese': {
                              courseGroupSearch(chineseCourses);
                            }
                            break;
                            case 'Electives': {
                              courseGroupSearch(electiveCourses);
                            }
                            break;
                            default: {
                              courseSearch(search);
                            }
                            break;
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: (searchType == 'Cloud') ? studycloudred : studycloudblue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('Search Cloud',
                          style: TextStyle(fontSize: 15, color: (searchType == 'Cloud') ? Colors.white : Colors.black),),
                        onPressed: (searchType == 'Cloud') ? () {return;} : () {
                          setState(() {
                            searchType = 'Cloud';
                            error = '';
                          });
                          switch(search) {
                            case 'Math': {
                              courseGroupSearch(mathCourses);
                            }
                            break;
                            case 'LAL': {
                              courseGroupSearch(lalCourses);
                            }
                            break;
                            case 'Science': {
                              courseGroupSearch(scienceCourses);
                            }
                            break;
                            case 'History': {
                              courseGroupSearch(historyCourses);
                            }
                            break;
                            case 'Spanish': {
                              courseGroupSearch(spanishCourses);
                            }
                            break;
                            case 'French': {
                              courseGroupSearch(frenchCourses);
                            }
                            break;
                            case 'Italian': {
                              courseGroupSearch(italianCourses);
                            }
                            break;
                            case 'German': {
                              courseGroupSearch(germanCourses);
                            }
                            break;
                            case 'Japanese': {
                              courseGroupSearch(japaneseCourses);
                            }
                            break;
                            case 'Chinese': {
                              courseGroupSearch(chineseCourses);
                            }
                            break;
                            case 'Electives': {
                              courseGroupSearch(electiveCourses);
                            }
                            break;
                            default: {
                              courseSearch(search);
                            }
                            break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: ListView(
                    children: [
                      for(String helper in helpersArray) StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance.collection("Users").document(helper).snapshots(),
                        builder: (context, snapshot) {
                          print(helpersArray);
                          if(!snapshot.hasData) {
                            return Container(
                              color: Colors.transparent,
                              height: 100,
                              child: Center(
                                child: Text('Loading...', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                              ),
                            );
                          } else {
                            return GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    color: Colors.transparent,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image(
                                            width: 100,
                                            height: 100,
                                            image: ExactAssetImage('assets/images/flutter_sudycloudprofileimage.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(snapshot.data['Name'],
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                child: Text('${snapshot.data['Grade']} at ${schoolsArray[schoolCodesArray.indexOf(snapshot.data['School'])]}',
                                                  style: TextStyle(color: Color.fromRGBO(80, 80, 81, 1.0), fontSize: 12),),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              onTap: () {
                                  globals.selectedUID = snapshot.data.documentID;
                                  showDialog(context: context, builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
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
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: user2PopUp(),
                                              ),
                                              Container(
                                                height: 115,
                                                padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Container(
                                                      height: 45,
                                                      child: RaisedButton(
                                                        color: studycloudred,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        child: Text('Report',
                                                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
                                                        onPressed: () {
                                                          launch("mailto:hills.studycloud@gmail.com?subject=Report ID: $helper&body=Write a detailed description of why you are reporting this user here. DO NOT CHANGE THE SUBJECT OF THE EMAIL!");
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 10
                                                    ),
                                                    Container(
                                                      height: 45,
                                                      child: RaisedButton(
                                                        color: studycloudblue,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        child: Text('Request Help',
                                                          style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
                                                        onPressed: () async {
                                                          final user = await FirebaseAuth.instance.currentUser();
                                                          final data = {"From" : user.uid, "Created" : Timestamp.now(), "Name" : user.displayName, "Req" : true, "Subject" : search};
                                                          Firestore.instance.collection("Users").document(helper).collection("Notifs").document().setData(data)
                                                              .then((value) => Navigator.of(context).pop());

                                                          //send notification
                                                        },
                                                      )
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ),
              reqHelpNavBar()
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
          color: (search == 'Math') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Math",
              style: TextStyle(fontSize: 15, color: (search == 'Math') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Math') ? () {return;} : () {
            setState(() {
              search = 'Math';
            });
            saveSearch(search);
            courseGroupSearch(mathCourses);
          },
        );
      }
      break;
      case 3: {
        return RaisedButton(
          color: (search == 'LAL') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Language Arts",
              style: TextStyle(fontSize: 15, color: (search == 'LAL') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'LAL') ? () {return;} : () {
            setState(() {
              search = 'LAL';
            });
            saveSearch(search);
            courseGroupSearch(lalCourses);
          },
        );
      }
      break;
      case 5: {
        return RaisedButton(
          color: (search == 'Science') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Science",
              style: TextStyle(fontSize: 15, color: (search == 'Science') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Science') ? () {return;} : () {
            setState(() {
              search = 'Science';
            });
            saveSearch(search);
            courseGroupSearch(scienceCourses);
          },
        );
      }
      break;
      case 7: {
        return RaisedButton(
          color: (search == 'History') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("History",
              style: TextStyle(fontSize: 15, color: (search == 'History') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'History') ? () {return;} : () {
            setState(() {
              search = 'History';
            });
            saveSearch(search);
            courseGroupSearch(historyCourses);
          },
        );
      }
      break;
      case 9: {
        return RaisedButton(
          color: (search == 'Spanish') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Spanish",
              style: TextStyle(fontSize: 15, color: (search == 'Spanish') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Spanish') ? () {return;} : () {
            setState(() {
              search = 'Spanish';
            });
            saveSearch(search);
            courseGroupSearch(spanishCourses);
          },
        );
      }
      break;
      case 11: {
        return RaisedButton(
          color: (search == 'French') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("French",
              style: TextStyle(fontSize: 15, color: (search == 'French') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'French') ? () {return;} : () {
            setState(() {
              search = 'French';
            });
            saveSearch(search);
            courseGroupSearch(frenchCourses);
          },
        );
      }
      break;
      case 13: {
        return RaisedButton(
          color: (search == 'Italian') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Italian",
              style: TextStyle(fontSize: 15, color: (search == 'Italian') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Italian') ? () {return;} : () {
            setState(() {
              search = 'Italian';
            });
            saveSearch(search);
            courseGroupSearch(italianCourses);
          },
        );
      }
      break;
      case 15: {
        return RaisedButton(
          color: (search == 'German') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("German",
              style: TextStyle(fontSize: 15, color: (search == 'German') ? Colors.white : Colors.black,)),
          onPressed: (search == 'German') ? () {return;} : () {
            setState(() {
              search = 'German';
            });
            saveSearch(search);
            courseGroupSearch(germanCourses);
          },
        );
      }
      break;
      case 17: {
        return RaisedButton(
          color: (search == 'Japanese') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Japanese",
              style: TextStyle(fontSize: 15, color: (search == 'Japanese') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Japanese') ? () {return;} : () {
            setState(() {
              search = 'Japanese';
            });
            saveSearch(search);
            courseGroupSearch(japaneseCourses);
          },
        );
      }
      break;
      case 19: {
        return RaisedButton(
          color: (search == 'Chinese') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("Chinese",
              style: TextStyle(fontSize: 15, color: (search == 'Chinese') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Chinese') ? () {return;} : () {
            setState(() {
              search = 'Chinese';
            });
            saveSearch(search);
            courseGroupSearch(chineseCourses);
          },
        );
      }
      break;
      case 21: {
        return RaisedButton(
          color: (search == 'Electives') ? studycloudred : studycloudblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("AP Electives",
              style: TextStyle(fontSize: 15, color: (search == 'Electives') ? Colors.white : Colors.black,) ),
          onPressed: (search == 'Electives') ? () {return;} : () {
            setState(() {
              search = 'Electives';
            });
            saveSearch(search);
            courseGroupSearch(electiveCourses);
          },
        );
      }
      break;
    }
  }
}

class reqHelpNavBar extends StatelessWidget {
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
                onPressed: () {return;},
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
                },
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
                }
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
                }
            ),
          ),
        ],
      ),
    );
  }
}