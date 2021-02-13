import 'dart:ffi';
import 'dart:io';

import 'package:byaherov1/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:byaherov1/database_helper.dart';
import 'package:byaherov1/MyClass/myVar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class Account extends StatefulWidget {
  String something,userfull,usermail,userli,expli;
  Account(this.something,this.userfull,this.usermail,this.userli,this.expli);

  State<StatefulWidget> createState() {


    return MyPage(this.something,this.userfull,this.usermail,this.userli,this.expli);
  }
}
class MyPage extends State<Account> {
  String something,userfull,usermail,userli,expli;
  MyPage(this.something,this.userfull,this.usermail,this.userli,this.expli);

  int editme = 0;
  final oldpass = TextEditingController();
  final newpass = TextEditingController();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final driveli = TextEditingController();
  final contact = TextEditingController();

  String _selectedDate;
  bool _passhow = true;
  bool _passhow1 = true;

  String fullname;
  String conme;
  String drili;
  String dtexp;
  int passlength;
  String myas = "*******";

  final dbHelper = DatabaseHelper.instance;

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');

    _query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    if(allRows.length == 0){
      Navigator.pop(context);

    }else {
      print(allRows[0]['_id']);
      print(allRows[0]['name']);
      print(allRows[0]['password']);
      print(allRows[0]['onesignal']);
      print(allRows[0]['auth']);
      print(allRows[0]['email']);
      print(allRows[0]['driver']);
      print(allRows[0]['exp']);

    }

    if(_selectedDate.toString() == "null"){
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
      Navigator.pop(context);
    }

  }


  void initState() {
    fname.text = TransVar.fname;
    lname.text = TransVar.lname;
    contact.text = TransVar.contactno;
    driveli.text = TransVar.driveli;
    newpass.text = TransVar.pass;
    oldpass.text = TransVar.pass;
    fullname = TransVar.fname + " " + TransVar.lname;
    conme = TransVar.contactno;
    drili = TransVar.driveli;
    dtexp = TransVar.expli;


    super.initState();
    checkdrive();

  }

  getpassl(){

    for(int i = 0; i < TransVar.pass.length-1; i++){
      setState(() {
        myas = myas + "*";
      });
    }
  }
  static showProgressDialog(BuildContext context) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        "Loading",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  checkdate(){
    DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    DateTime dtme =  DateFormat("yyyy-MM-dd").parse(_selectedDate);

    if(dtme.isBefore(dtnow)){
      alertdate(context);
    }
  }

  alertdate(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Date is not valid."),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  succdialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        _delete();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Profile successfully updated."),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Password not matched."),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  passdialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Please fill up all the boxes."),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  Future changeprof() async{
    String firstname = fname.text;
    String lastname = lname.text;
    String conta = contact.text;
    String driveme = driveli.text;
    String dtli;
    String pass;
    String npass;
    DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    DateTime dtme;

    if(_selectedDate.toString() == "null"){
      dtli =  TransVar.expli;
      dtme =  DateFormat("yyyy-MM-dd").parse(dtli);
    }else{
      dtli = _selectedDate;
      dtme =  DateFormat("yyyy-MM-dd").parse(dtli);
    }
    if(pass == "null"){
      pass = TransVar.pass;
      npass = TransVar.pass;
    }else{
      pass = oldpass.text;
      npass = newpass.text;
    }

    print(dtli);



    if(dtme.isBefore(dtnow)){
      alertdate(context);
    }else{
      if(pass != null && pass != ""){
        if(pass != npass){
          showAlertDialog(context);
        }else {
          showProgressDialog(context);
          Map<String, String> headers = {
            "Content-type": "application/json",
            'Authorization': 'Bearer ' + TransVar.token
          };
          var body = jsonEncode({
            "password": pass,
            "confirm_password": npass,
            "first_name": firstname,
            "last_name": lastname,
            "driver_license_no": driveme,
            "driver_license_exp_date": dtli
          });
          String url = "https://admin.byaherongpinoy.com/api/v1/profile/force-change/";
          final response = await http.post(url, headers: headers, body: body);


          if (response.statusCode == 200) {
            print(response.body.toString());

            setState(() {
              TransVar.username = firstname + " " + lastname;
              TransVar.driveli = driveme;
              TransVar.expli = dtli;
              TransVar.contactno = conta;
              TransVar.pass = pass;

              oldpass.text = pass;
              newpass.text = pass;
              fname.text = firstname;
              lname.text = lastname;
              contact.text = conta;
              driveli.text = driveme;


              editme = 0;
            });


            succdialog(context);

          } else {
            print(response.body.toString());

          }
        }
      }else {
        passdialog(context);
      }
    }



  }



  void _toggle() {
    setState(() {
      _passhow = !_passhow;
    });
  }
  void _toggle1() {
    setState(() {
      _passhow1 = !_passhow1;
    });
  }

  checkdrive(){
    //TransVar.expli
   try{
     DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
     DateTime dtme =  DateFormat("yyyy-MM-dd").parse(TransVar.expli);
     final difference = dtme.difference(dtnow).inDays;

     if(difference < 7 && difference > 0){

       return Text("Your driver license is near to expire.", style: TextStyle(color: Colors.red),);

     }
     if(difference < 1){

       return Text("Your driver license is already expired", style: TextStyle(color: Colors.red),);

     }
     if(difference > 7){

       return null;
     }
   }on Exception catch (_) {
     return Text("Update your driver license as soon.", style: TextStyle(color: Colors.red),);
   }
  }

  sample(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OK!"),
      content: Text(expli),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  editicon(){
    if(editme == 0){
      return Container(
        width: 70,
        height: 50,
        color: Colors.white,
        child: GestureDetector(
            onTap: (){
              setState(() {
                editme = 1;
              });
            },
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(Icons.person, color: Colors.indigo,size: 50,),
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child: Icon(Icons.edit, color: Colors.indigo, size: 30,),
                  )
                ],
              ),
            )

        ),
      );
    }
    if(editme == 1){
      return Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            color: Colors.green,
            child: GestureDetector(
                onTap: (){
                changeprof();
              },
            child: Icon(Icons.check, color: Colors.white,)),
          ),
          Container(width: 10,),
          Container(
            width: 50,
            height: 50,
            color: Colors.red,
            child: GestureDetector(
                onTap: (){
                  setState(() {
                    editme = 0;
                  });
                },
                child: Icon(Icons.close, color: Colors.white,)),
          ),
        ],
      );
    }
  }



  mybody(){
    return Container(

      padding: const EdgeInsets.fromLTRB(10,0,10,0),
      child: ListView(

        children: <Widget>[
          Container(
            height: 130,
            child:Column(
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: CircleAvatar(
                    //backgroundColor: Colors.white70,
                    child: Image.asset('images/noback.png', fit: BoxFit.fill,),
                  ),
                ),

                Center(
                  child: checkdrive(),
                ),



              ],
            ),

          ),
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            color: Colors.indigo,
            child: Center(
              child: Text(TransVar.myplate, style: TextStyle(color: Colors.white, fontSize: 34),),
            )
          ),

            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 10, 2),

              height: 70,
              child: Row(
                children: <Widget>[

                  Text("ACCOUNT DETAILS", style: TextStyle(color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.bold),),
                  Spacer(),
                  editicon(),


                ],
              ),
            ),



          myfb(),


        ],
      ),

    );
  }

  myfb(){
    if(editme == 0){
      return Column(

        children: <Widget>[
          Container(

            padding: const EdgeInsets.fromLTRB(30, 30, 2, 2),

            height: 70,
            child: Row(
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.indigo,),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Column(
                  children: <Widget>[
                    Text('Name: ' + fname.text + " " + lname.text),

                  ],
                )
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(30, 5, 2, 10),
            child: Row(
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Icon(Icons.phone, color: Colors.indigo,),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Column(
                  children: <Widget>[
                    Text('Contact no: ' + conme),

                  ],
                )
              ],
            ),
          ),


          Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 2, 10),
            height: 90,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Row(
                  children: <Widget>[

                    Column(
                      children: <Widget>[
                        Icon(Icons.featured_video, color: Colors.indigo,),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    Column(
                      children: <Widget>[
                        Text('Driver License: ' + drili),

                      ],
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.calendar_today, color: Colors.indigo,),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    Column(
                      children: <Widget>[
                        Text('Expiration Date: ' + dtexp),

                      ],
                    )
                  ],
                ),

              ],
            ),
          ),

          Container(
            //color: Colors.white,
            padding: const EdgeInsets.fromLTRB(30, 10, 2, 2),

            height: 70,
            child: Row(
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Icon(Icons.lock_open, color: Colors.indigo,),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Column(

                  children: <Widget>[
                  Text("Password: " + myas),
                  ],
                )
              ],
            ),
          ),




        ],
      );
    }
    if(editme == 1){
      return Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(30, 30, 2, 2),

            height: 70,
            child: Row(
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.indigo,),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Container(

                    width: 100,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: TextField(
                      controller: fname,
                      onChanged: (text) {
                        // changename();
                      },
                      autocorrect: true,
                      decoration: InputDecoration(

                        hintText: 'First Name',

                      ),
                    )
                ),
                Container(

                    width: 100,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: TextField(
                      controller: lname,
                      onChanged: (text) {
                        // changename();
                      },
                      autocorrect: true,
                      decoration: InputDecoration(

                        hintText: 'Last Name',

                      ),
                    )
                ),
              ],
            ),
          ),
          Container(height: 5,),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(30, 30, 2, 2),

            height: 70,
            child: Row(
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Icon(Icons.phone, color: Colors.indigo,),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Container(

                    width: 150,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: TextField(
                      controller: contact,
                      onChanged: (text) {
                        // changename();
                      },
                      autocorrect: true,
                      decoration: InputDecoration(

                        hintText: 'Contact number',

                      ),
                    )
                ),
              ],
            ),
          ),
          Container(height: 5,),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(30, 5, 2, 2),
            height: 350,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
                ),
                Row(
                  children: <Widget>[

                    Column(
                      children: <Widget>[
                        Icon(Icons.featured_video, color: Colors.indigo,),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    Container(

                        width: 150,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          controller: driveli,
                          onChanged: (text) {
                            // changename();
                          },
                          autocorrect: true,
                          decoration: InputDecoration(

                            hintText: 'Driver License',

                          ),
                        )
                    ),
                  ],
                ),


                Column(
                  children: <Widget>[
                    Container(

                        width: 280,
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Text("Date Expiration")
                    ),
                    Container(
                      width: 280,
                      height: 200,
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),

                      child:  SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                      ),


                    ),



                  ],
                ),

              ],
            ),
          ),
          Container(height: 5,),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(30, 0, 10, 2),

              height: 140,
              child:  Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(Icons.lock, color: Colors.indigo,),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      ),

                      Container(

                          width: 220,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(

                            controller: newpass,
                            autocorrect: true,
                            obscureText: _passhow,
                            decoration: InputDecoration(

                                hintText: 'New Password',
                                suffixIcon: Container(
                                  width: 20,
                                  child: FlatButton(
                                    onPressed: _toggle,
                                    child: new Icon(Icons.remove_red_eye,  color: _passhow ?  Colors.grey: Colors.black54,size: 20,),),
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(Icons.lock, color: Colors.indigo,),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      ),

                      Container(

                          width: 220,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(

                            controller: oldpass,
                            autocorrect: true,
                            obscureText: _passhow1,
                            decoration: InputDecoration(

                                hintText: 'Confirm Password',
                                suffixIcon: Container(
                                  width: 20,
                                  child: FlatButton(
                                    onPressed: _toggle1,
                                    child: new Icon(Icons.remove_red_eye,  color: _passhow1 ?  Colors.grey: Colors.black54,size: 20,),),
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              )


          ),



        ],
      );
    }

  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        _selectedDate = DateFormat('yyyy-MM-dd').format(args.value).toString();

      }
      TransVar.drivexp = _selectedDate;
      print(TransVar.drivexp);
      checkdate();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: mybody(),
    );
  }
}