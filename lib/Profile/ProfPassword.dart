import 'package:byaherov1/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:byaherov1/MyClass/myVar.dart';

class ProfPassword extends StatefulWidget {
  String something;
  ProfPassword(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ProfPassword> {
  String something;
  MyPage(this.something);
  final oldpass = TextEditingController();
  final newpass = TextEditingController();

  void changename(){
    TransVar.pass = oldpass.text;
    TransVar.cpass = newpass.text;


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
    if(TransVar.pass != TransVar.cpass){
      showAlertDialog(context);
    }else {
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Authorization': 'Bearer ' + TransVar.token
      };
      var body = jsonEncode({
        "password": TransVar.pass,
        "confirm_password": TransVar.cpass,
        "first_name": TransVar.fname,
        "last_name": TransVar.lname,
        "driver_license_no": TransVar.driveli,
        "driver_license_exp_date": TransVar.drivexp
      });
      String url = "https://admin.byaherongpinoy.com/api/v1/profile/force-change/";
      final response = await http.post(url, headers: headers, body: body);


      if (response.statusCode == 200) {
        print(response.body.toString());
      } else {
        print(response.body.toString());
      }
    }
  }



  bool _passhow = true;

  void _toggle() {
    setState(() {
      _passhow = !_passhow;
    });
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
                  Text("Change Password", style: TextStyle(color: Colors.white, fontSize: 20.0),),

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
                              borderSide: new BorderSide(color: Colors.white)
                          ),
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white,),
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
                              borderSide: new BorderSide(color: Colors.white)
                          ),
                          hintText: 'Confirmed Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white,),
                        ),
                      )
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 10, 10),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed: _toggle,
                            child: new Text(_passhow ? "Show" : "Hide", style: TextStyle(color: Colors.white,fontSize: 12.0),))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(70, 0, 10, 30),

                  ),
                  ButtonTheme(

                    minWidth: 280.0,
                    height: 70.0,
                    child: RaisedButton(

                      onPressed: (){

                        Navigator.pop(context);
                        changeprof();
                      },


                      color: Colors.white,
                      textColor: Colors.blueGrey,

                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      child: Text('Continue',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue,
                          )
                      ),
                    ),
                  ),

                ],
              )
          )
      ),
    );
  }
}