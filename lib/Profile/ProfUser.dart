import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:byaherov1/Profile/ProfInfo.dart';
import 'package:byaherov1/Profile/ProfDocu.dart';
import 'package:byaherov1/Profile/ProfPassword.dart';

class ProfUser extends StatefulWidget {
  String something;
  ProfUser(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ProfUser> {
  String token;
  MyPage(this.token);


  Widget build(BuildContext context) {
    return DefaultTabController(
      child:  Scaffold(



        body: PageView(
          children: <Widget>[
            ProfInfo("sample"),
            ProfDocu("sample"),
            ProfPassword(token),
          ],
        ),

      ),
      length: 3,
      initialIndex: 0,
    );
  }
}