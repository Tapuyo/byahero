import 'package:byaherov1/MyClass/myVar.dart';
import 'package:flutter/material.dart';



class Setme extends StatefulWidget {
  String something;
  Setme(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<Setme> {
  String something;
  MyPage(this.something);


  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;
  bool isSwitched5 = false;

  void initState() {

    super.initState();
   if(TransVar.duty == "on"){
     isSwitched1 = true;
   }else{
     isSwitched1 = false;
   }
    if(TransVar.autosave == "on"){
      isSwitched4 = true;
    }else{
      isSwitched4 = false;
    }

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),

      body: Container(
          child:  ListView(
        children: <Widget>[
          Positioned(
            child: Container(
              padding: EdgeInsets.fromLTRB(0,40,0,0),
              child: Column(
              children: <Widget>[
//              Card(
//                child: GestureDetector(
//                  onTap: (){
//
//                  },
//                  child: Container(
//                    padding: EdgeInsets.fromLTRB(0,10,0,10),
//                    child: Row(
//                      children: <Widget>[
//                        Container(
//                          padding: EdgeInsets.fromLTRB(30,0,0,0),
//                        ),
//                        Container(
//                          child: Container(
//                            child: Icon(Icons.check_circle, size: 30, color: Colors.blue,),
//                          ),
//                        ),
//                        Container(
//                          padding: EdgeInsets.fromLTRB(10,0,0,0),
//                        ),
//                        Container(
//
//                          child: Container(
//                            child: Text("On Duty",style: TextStyle(fontSize: 16),),
//                          ),
//                        ),
//                        Spacer(),
//                        Switch(
//                          value: isSwitched1,
//                          onChanged: (value){
//                            setState(() {
//                              isSwitched1=value;
//                              print(value);
//                              //Navigator.pop(context);
//                            });
//                          },
//                          activeTrackColor: Colors.lightBlue,
//                          activeColor: Colors.blue,
//                        ),
//                        Container(
//                          padding: EdgeInsets.fromLTRB(0,0,30,0),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                padding: EdgeInsets.fromLTRB(0,20,0,0),
//              ),
              Card(
                child: GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0,10,0,10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(30,0,0,0),
                        ),
                        Container(
                          child: Container(
                            child: Icon(Icons.notifications_active, size: 30, color: Colors.blue,),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10,0,0,0),
                        ),
                        Container(

                          child: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Notify Me",style: TextStyle(fontSize: 16),),
                                Text("2 Weeks before Driver License Expired",style: TextStyle(fontSize: 10),),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isSwitched2,
                          onChanged: (value){
                            setState(() {
                              isSwitched2=value;
                              print(value);
                              //Navigator.pop(context);
                            });
                          },
                          activeTrackColor: Colors.lightBlue,
                          activeColor: Colors.blue,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0,0,30,0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
              ),
              Card(
                child: GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0,10,0,10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(30,0,0,0),
                        ),
                        Container(
                          child: Container(
                            child: Icon(Icons.surround_sound, size: 30, color: Colors.blue),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10,0,0,0),
                        ),
                        Container(

                          child: Container(
                            child: Text("Sound",style: TextStyle(fontSize: 16),),
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isSwitched3,
                          onChanged: (value){
                            setState(() {
                              isSwitched3=value;
                              print(value);
                              //Navigator.pop(context);
                            });
                          },
                          activeTrackColor: Colors.lightBlue,
                          activeColor: Colors.blue,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0,0,30,0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
              ),
              Card(
                child: GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0,10,0,10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(30,0,0,0),
                        ),
                        Container(
                          child: Container(
                            child: Icon(Icons.save, size: 30, color: Colors.blue),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10,0,0,0),
                        ),
                        Container(

                          child: Container(
                            child: Text("Auto Save User",style: TextStyle(fontSize: 16),),
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isSwitched4,
                          onChanged: (value){
                            setState(() {
                              isSwitched4=value;
                              print(value);
                              //Navigator.pop(context);
                            });
                          },
                          activeTrackColor: Colors.lightBlue,
                          activeColor: Colors.blue,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0,0,30,0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
              ),

            ],
          ),

        )
    ),
  ],
),
      )

    );
  }
}