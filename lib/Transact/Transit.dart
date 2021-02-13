import 'dart:io';

import 'package:flutter/material.dart';


class Transit extends StatefulWidget {

  Transit();

  State<StatefulWidget> createState() {


    return MyPage();
  }
}
class MyPage extends State<Transit> {

  MyPage();


  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: const EdgeInsets.fromLTRB(50,100,50,2),
        decoration: BoxDecoration(
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Transit", style: TextStyle(fontSize: 40, color: Colors.grey),),
            Text("Start delivering parcel.>>>", style: TextStyle(fontSize: 12, color: Colors.grey),),
            Container(

              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Image.asset('images/delgiv.gif'),
            )
          ],
        ),
      ),
    );
  }
}