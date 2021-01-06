import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:study_cloud_android/main.dart';

List<String> searchingSchoolsArray = [];

class codesRef extends StatefulWidget {
  @override
  _codesRefState createState() => _codesRefState();
}

class _codesRefState extends State<codesRef> {

  final schoolSearchBar = TextEditingController();
  double codeCopied = 0;
  String copiedSchool = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text("School codes help refine the process of signing up for Study Cloud. If you do not know your school code, search for your school below. Tap to copy the code.",
              style: TextStyle(fontSize: 17, color: Colors.black,), textAlign: TextAlign.left,),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                  top: BorderSide(color: Colors.grey)
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: TextField(
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        controller: schoolSearchBar,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          contentPadding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                          isDense: true,
                          hintText: "School Name",
                        ),
                        onTap: () {
                          setState(() {
                            codeCopied = 0;
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
                        FocusScope.of(context).unfocus();
                        final search = schoolSearchBar.text;
                        setState(() {
                          searchingSchoolsArray = schoolsArray.where((school) => school.toLowerCase().trim().contains(search.toLowerCase().trim())).toSet().toList();
                          if (searchingSchoolsArray.isEmpty) {
                            searchingSchoolsArray = ["No results!"];
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Container(
              height: 50,
              color: codeCopied == 0 ? Colors.grey : studycloudblue,
              child: Center(
                child: Text('Code Copied!',
                  style: TextStyle(color: Colors.black, fontSize: 17), textAlign: TextAlign.center,),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            height: 750,
            child: ListView(
              children: [
                for (var school in searchingSchoolsArray) Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey)
                      )
                    ),
                    child: FlatButton(
                      textColor: Colors.black,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(school, style: TextStyle(fontSize: 15, fontFamily: 'Alegreya', fontWeight: FontWeight.normal), textAlign: TextAlign.start,),
                      ),
                      onPressed: () {
                        setState(() {
                          final schoolIndex = schoolsArray.indexOf(school);
                          if (schoolIndex != -1) {
                            final code = schoolCodesArray[schoolIndex];
                            if (code != null) {
                              codeCopied = 1;
                              Clipboard.setData(new ClipboardData(text: code));
                            } else {
                              copiedSchool = "Error retrieving school code!";
                              codeCopied = 1;
                            }
                          } else {
                            copiedSchool = "Error retrieving school code!";
                            codeCopied = 1;
                          }
                        });
                      },
                    ),
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}