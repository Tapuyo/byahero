import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:byaherov1/MyClass/myVar.dart';


class ProfInfo extends StatefulWidget {
  String something;
  ProfInfo(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ProfInfo> {
  String something;
  MyPage(this.something);

  final fname = TextEditingController();
  final lname = TextEditingController();

  void changename(){
    TransVar.fname = fname.text;
    TransVar.lname = lname.text;
    print(TransVar.fname);
    print(TransVar.lname);
  }


  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          padding: const EdgeInsets.fromLTRB(2,100,2,2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.blue]),
          ),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("User Info", style: TextStyle(color: Colors.white, fontSize: 20.0),),

              Container(

                  width: 280,
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: TextField(
                    controller: fname,
                    onChanged: (text) {
                      changename();
                    },
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)
                      ),
                      hintText: 'First Name',

                    ),
                  )
              ),

              Container(

                  width: 280,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    controller: lname,
                    onChanged: (text) {
                      changename();
                    },
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)
                      ),
                      hintText: 'Last Name',

                    ),
                  )
              ),
              Container(

                  width: 280,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: Text("swipe >>>", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  )
              ),
            ],
          )
        )
      ),
    );
  }
}