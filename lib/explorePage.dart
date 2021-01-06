import 'package:flutter/material.dart';

import 'main.dart';
import 'reqHelpPage.dart';
import 'notifPage.dart';
import 'profilePage.dart';
import 'studySharePage.dart';

class explore extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
                  child: Text('Explore',
                    style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 150,
                  child: Container(
                    color: studycloudyellow,
                    child: Center(
                      child: Text('Coming Soon!',
                        style: TextStyle(color: Colors.black, fontSize: 17), textAlign: TextAlign.center,),
                    ),
                  ),
                )
              ],
            ),
          ),
          exploreNavBar()
        ],
      ),
    );
  }
}

class exploreNavBar extends StatelessWidget {
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
                onPressed: null
            ),
          ),
        ],
      ),
    );
  }
}