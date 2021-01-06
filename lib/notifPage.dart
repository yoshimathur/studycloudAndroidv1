import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'reqHelpPage.dart';
import 'profilePage.dart';
import 'studySharePage.dart';
import 'explorePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class notif extends StatelessWidget{
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
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 50, 15, 15),
                      child: Text('Notifications',
                        style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: FirebaseAuth.instance.currentUser(),
                        builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
                          if (userSnapshot.hasData) {
                            return StreamBuilder(
                              stream: Firestore.instance.collection("Users").document(userSnapshot.data.uid).collection("Notifs").orderBy("Created", descending: true).snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot>querySnapshot) {
                                if (querySnapshot.hasData) {
                                  return Container(
                                    child: ListView(
                                      children: [
                                        for (var document in querySnapshot.data.documents) Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                                          child: (document.data["Req"]) ? requestNotif(document, userSnapshot.data) : updateNotif(document)
                                        )
                                      ],
                                    )
                                  );
                                } else {
                                  return Center(
                                    child: Text('You have no notifications!',
                                      style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                                  );
                                }
                              },
                            );
                          }  else {
                            return Center(
                                child: Text('Please log in!',
                                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center,)
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              notifNavBar()
            ],
          ),
        ),
      )
    );
  }

  Widget requestNotif(DocumentSnapshot document, FirebaseUser user) {

    String timestamp;
    String name = document.data["Name"];
    String acceptedSubject = document.data["Subject"];
    DateTime created = document.data["Created"].toDate();

    if (created.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      DateFormat dateFormat = DateFormat('yMd');
      timestamp = dateFormat.format(created);
    } else {
      DateFormat dateFormat = DateFormat('h:mma');
      timestamp = dateFormat.format(created);
    }

    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name has requested for help with $acceptedSubject. Tap to accept!',
            style: TextStyle(color: studycloudred, fontSize: 15, fontWeight: FontWeight.bold),),
          Container(height: 10,),
          Text('Accepting this request will share your contact information with this user.',
            style: TextStyle(fontSize: 12),),
          Container(height: 5,),
          Text(timestamp,
            style: TextStyle(color: Color.fromRGBO(80, 80, 81, 1.0), fontSize: 12),)
        ],
      ),
      onTap: () async {
        //accepting the request
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final acceptedUID = document.data["From"];
        final number = (prefs.getString('Number') != null) ? prefs.getString('Number') : "";
        final uid = user.uid;
        final userName = user.displayName;
        final email = user.email;
        if (name != null || email != null) {
          final data = {"From" : uid, "Created" : Timestamp.now(), "Subject" : acceptedSubject, "Name" : userName, "#" : number, "email" : email, "Req" : false};
          Firestore.instance.collection("Users").document(acceptedUID).collection("Notifs").document().setData(data)
              .then((value) {
                document.reference.delete();
              })
              .catchError((onError) => print(onError.toString()));

          //send notification
        }
      },
    );
  }

  Widget updateNotif(DocumentSnapshot document) {
    String timestamp;
    DateTime created = document.data["Created"].toDate();

    if (created.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      DateFormat dateFormat = DateFormat('yMd');
      timestamp = dateFormat.format(created);
    } else {
      DateFormat dateFormat = DateFormat('h:mma');
      timestamp = dateFormat.format(created);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${document.data["Name"]} accepted your request for ${document.data["Subject"]}. Please contact them using the information below.',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        Container(height: 10,),
        SelectableText('Phone Number: ${document.data["#"]} \nEmail: ${document.data["email"]}',
          style: TextStyle(fontSize: 12),),
        Container(height: 5,),
        Text(timestamp,
          style: TextStyle(color: Color.fromRGBO(80, 80, 81, 1.0), fontSize: 12),)
      ],
    );
  }
}

class notifNavBar extends StatelessWidget {
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
                  onPressed: null
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
              },
            ),
          ),
        ],
      ),
    );
  }
}