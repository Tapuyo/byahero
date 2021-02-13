import 'package:byaherov1/main.dart';
import 'package:flutter/material.dart';
import 'package:byaherov1/homepage/today.dart';
import 'package:byaherov1/homepage/upcoming.dart';
import 'package:intl/intl.dart';
import 'package:byaherov1/MyClass/myVar.dart';


class home extends StatefulWidget {
  String something;
  home(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<home> {
  String something;
  MyPage(this.something);

  void initState() {

    super.initState();

  }



  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:TabBar(

            unselectedLabelColor: Colors.indigo,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.indigo),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.indigo, width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("TODAY"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.indigo, width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("UPCOMING"),
                  ),
                ),
              ),

            ]),
       body: TabBarView(
         children: <Widget>[
           today(something),
           upcoming(something),
         ],
       )
      ),
    );
  }
}