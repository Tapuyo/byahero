import 'package:byaherov1/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:byaherov1/MyClass/myVar.dart';

import 'package:intl/intl.dart';
import 'package:byaherov1/database_helper.dart';

class ChangeProf extends StatefulWidget {
  String something;
  ChangeProf(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ChangeProf> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final dbHelper = DatabaseHelper.instance;

  String something;
  MyPage(this.something);
  final oldpass = TextEditingController();
  final newpass = TextEditingController();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final driveli = TextEditingController();


  String _selectedDate;

  void changename(){
    TransVar.driveli = driveli.text;

    print(TransVar.driveli);
  }

  /*void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {

        _selectedDate = DateFormat('yyyy/MM/dd').format(args.value).toString();
      }
      TransVar.drivexp = _selectedDate;
      print(TransVar.drivexp);
    });
  }
*/
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
    Navigator.pop(context);
  }
  showme(BuildContext context) {

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
      content: Text("You successfully update your profile."),
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
    String driveme = driveli.text;
    String dtli = _selectedDate;
    String pass = oldpass.text;
    String npass = newpass.text;


    print(firstname + ":" + lastname + ":" + driveme + ":" + dtli + ":" + pass + ":" + npass);

    // if(pass != null && pass != ""){
    //   if(pass != npass){
    //     showAlertDialog(context);
    //   }else {
    //     Map<String, String> headers = {
    //       "Content-type": "application/json",
    //       'Authorization': 'Bearer ' + TransVar.token
    //     };
    //     var body = jsonEncode({
    //       "password": pass,
    //       "confirm_password": npass,
    //       "first_name": firstname,
    //       "last_name": lastname,
    //       "driver_license_no": driveme,
    //       "driver_license_exp_date": dtli
    //     });
    //     String url = "https://admin.byaherongpinoy.com/api/v1/profile/force-change/";
    //     final response = await http.post(url, headers: headers, body: body);
    //
    //
    //     if (response.statusCode == 200) {
    //       print(response.body.toString());
    //       TransVar.username = firstname + " " + lastname;
    //       TransVar.driveli = driveme;
    //       TransVar.expli = dtli;
    //       TransVar.accreload = "reload";
    //      // showme(context);
    //       Navigator.pop(context);
    //     } else {
    //       print(response.body.toString());
    //
    //     }
    //   }
    // }
  }




  bool _passhow = true;

  void _toggle() {
    setState(() {
      _passhow = !_passhow;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(2,100,2,2),

          child: Center(
              child: Column(
                children: <Widget>[
                  Text("Update Profile", style: TextStyle(color: Colors.blue, fontSize: 20.0),),

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
                              borderSide: new BorderSide(color: Colors.blue)
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
                              borderSide: new BorderSide(color: Colors.blue)
                          ),
                          hintText: 'Last Name',

                        ),
                      )
                  ),
                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: TextField(
                        controller: driveli,
                        onChanged: (text) {
                          changename();
                        },
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.blue)
                          ),
                          hintText: 'Driver License No',

                        ),
                      )
                  ),
                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: Text("Date Expiration")
                  ),
                  // Container(
                  //   width: 280,
                  //   height: 200,
                  //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //   child:  SfDateRangePicker(
                  //     onSelectionChanged: _onSelectionChanged,
                  //     selectionMode: DateRangePickerSelectionMode.single,
                  //   ),
                  // ),

                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: TextField(
                        controller: oldpass,
                        onChanged: (text) {
                          changename();
                        },
                        autocorrect: true,
                        obscureText: _passhow,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.blue)
                          ),
                          hintText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue,),
                        ),
                      )
                  ),
                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(

                        controller: newpass,
                        onChanged: (text) {
                          changename();
                        },
                        autocorrect: true,
                        obscureText: _passhow,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.blue)
                          ),
                          hintText: 'Confirmed New Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue,),
                        ),
                      )
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 10, 10),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed: _toggle,
                            child: new Text(_passhow ? "Show" : "Hide", style: TextStyle(color: Colors.blue,fontSize: 12.0),))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(70, 0, 10, 0),

                  ),
                  ButtonTheme(

                    minWidth: 280.0,
                    height: 70.0,
                    child: RaisedButton(

                      onPressed: (){


                        changeprof();
                      },


                      color: Colors.white,
                      textColor: Colors.blueGrey,

                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      child: Text('Update',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue,
                          )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(70, 30, 10, 30),

                  ),

                ],
              )
          )
      ),
    );
  }
}