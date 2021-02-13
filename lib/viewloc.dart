import 'package:flutter/material.dart';




class viewloc extends StatefulWidget {
  String something;
  viewloc(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<viewloc> {
  String something;
  MyPage(this.something);







  void initState() {

    super.initState();


  }



  Widget build(BuildContext context) {
    return Scaffold(

       );

  }


}


