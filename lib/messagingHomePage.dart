import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'profilePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class messagingHome extends StatefulWidget {
  @override
  _messagingHomeState createState() => _messagingHomeState();
}

class _messagingHomeState extends State<messagingHome> {

  List<String> chatsArray = [];
  List<String> interChatsArray = [];
  List<String> lastMsgArray = [];
  List<String> interLastMsgArray = [];
  List<bool> showNotifsArray = [];
  List<bool> interShowNotifsArray = [];
  List<String> timestampsArray = [];
  List<String> interTimestampsArray = [];
  List<DateTime> interInterTimestampsArray = [];
  Map<DateTime, String> chatsMap = new Map();
  Map<DateTime, String> lastMsgMap = new Map();
  Map<DateTime, bool> showNotifsMap = new Map();

  void addInterData(DocumentSnapshot lastMsg, String intermediateChatUserUIDVar, String userUID) {

    interChatsArray.clear();
    interLastMsgArray.clear();
    interShowNotifsArray.clear();
    interTimestampsArray.clear();

    var date = lastMsg.data["created"].toDate();
    var lastMsgContent = lastMsg.data["content"];
    var wasRead = lastMsg.data["read"];
    var senderID = lastMsg.data["senderID"];
    chatsMap[date] = intermediateChatUserUIDVar;
    lastMsgMap[date] = lastMsgContent;
    showNotifsMap[date] = (senderID != userUID) ? wasRead : true;
    interInterTimestampsArray.add(date);
    interInterTimestampsArray.sort();
    for (var timestamp in interInterTimestampsArray.reversed) {
      interChatsArray.add(chatsMap[timestamp]);
      interLastMsgArray.add(lastMsgMap[timestamp]);
      interShowNotifsArray.add(showNotifsMap[timestamp]);
      //convert timestamp date to string format
      if (timestamp.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
        //message was sent over a day ago
        DateFormat dateFormat = DateFormat('MM-dd');
        String dateString = dateFormat.format(timestamp);
        timestampsArray.add(dateString);
      } else {
        DateFormat dateFormat = DateFormat('h:mma');
        String dateString = dateFormat.format(timestamp);
        timestampsArray.add(dateString);
      }
    }
  }


  Future loadChats() async {

    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection("Chats").where("users", arrayContains: user.uid).getDocuments()
        .then((querySnapshots) {
          for (var document in querySnapshots.documents) {

            String intermediateChatUserUIDVar = '';

            //add user uids
            var chatUsers = document["users"];
            for (var userUID in chatUsers) {
              if (userUID.toString() != user.uid) {
                intermediateChatUserUIDVar = userUID.toString();
              }
            }

            //getting last message information
            document.reference.collection("thread").orderBy("created", descending: true).limit(1).getDocuments()
                .then((chatSnapshot) => {
                  for (var lastMsg in chatSnapshot.documents) {

                    addInterData(lastMsg, intermediateChatUserUIDVar, user.uid),

                    setState(() {
                      chatsArray = interChatsArray;
                      lastMsgArray = interLastMsgArray;
                      showNotifsArray = interShowNotifsArray;
                      timestampsArray = interTimestampsArray;
                    }),

                    print('$chatsArray, $lastMsgArray, $showNotifsArray, $timestampsArray')
                  }
            }).catchError((onError) => print(onError.toString()));
          }
    }).catchError((onError) => print(onError.toString()));
  }

  @override
  void initState() {
    loadChats().then((value){
      print('Async done');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
      color: studycloudyellow,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 50, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: studycloudred,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
                  },
                ),
                Expanded(
                  child: Container(
                    child: Text('Messages',
                      style: TextStyle(color: studycloudred, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                for(var uid in chatsArray) StreamBuilder(
                  stream: Firestore.instance.collection("Users").document(uid).snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) {
                      return Container(
                        color: Colors.transparent,
                        height: 100,
                        child: Center(
                          child: Text('Loading...', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                        ),
                      );
                    } else {
                      return Container(
                        height: 70,
                        color: Colors.transparent,
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey)
                            )
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image(
                                  width: 50,
                                  height: 50,
                                  image: ExactAssetImage('assets/images/flutter_sudycloudprofileimage.png'),
                                ),
                              ),
                              Container(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(snapshot.data['Name'],
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        ),
                                        Text(timestampsArray[chatsArray.indexOf(uid)],
                                          style: TextStyle(color: Color.fromRGBO(80, 80, 81, 1.0), fontSize: 12))
                                      ],
                                    ),
                                    Container(
                                      height: 2,
                                    ),
                                    Text(lastMsgArray[chatsArray.indexOf(uid)],
                                      style: TextStyle(color: Color.fromRGBO(80, 80, 81, 1.0), fontSize: 15), overflow: TextOverflow.ellipsis,)
                                  ],
                                ),
                              ),
                              if(!showNotifsArray[chatsArray.indexOf(uid)]) Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 5, 10),
                                child: Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: studycloudblue,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                )
                              )
                            ],
                          ),
                        )
                      );
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}