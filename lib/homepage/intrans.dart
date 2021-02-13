import 'dart:convert';

import 'package:byaherov1/Transact/Dispatch.dart';
import 'package:byaherov1/main.dart';
import 'package:flutter/material.dart';
import 'package:byaherov1/Transact/PickSave.dart';
import 'package:byaherov1/Transact/DeliverySave.dart';
import 'package:byaherov1/Transact/ReturnSave.dart';
import 'package:http/http.dart' as http;
import 'package:byaherov1/MyClass/myVar.dart';



class intrans extends StatefulWidget {
  String something,transid,ctype;
  int stat;

  intrans(this.something,this.stat,this.transid,this.ctype);

  State<StatefulWidget> createState() {

    return MyPage(this.something,this.stat,this.transid,this.ctype);
  }
}
class MyPage extends State<intrans> {
  int delrequired = 1;

  String something,transid,ctype;
  int stat;
  MyPage(this.something, this.stat,this.transid,this.ctype);

  void initState() {



    super.initState();
   TransVar.delotp = "";
   TransVar.delimg = null;
   TransVar.delsign = "";
  }

  mytab(){
    if(stat == 5){
      return PickSave(this.transid);
    }

    if(stat == 7){
      return DeliverySave(this.transid,ctype);
    }

    if(stat == 9){
      return ReturnSave(this.transid);
    }

  }
  btns(){
    if(stat == 5){
      pickup();
    }

    if(stat == 7){
      delivered();
    }

    if(stat == 9){
      Complte();
    }
  }
  shownosig(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Signature!"),
      content: Text("Please add signature."),
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
  shownoimg(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Image!"),
      content: Text("Please add image."),
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
  showotpnot(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OTP!"),
      content: Text("Please verify your OTP"),
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
  oknaotpmo(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OTP!"),
      content: Text(TransVar.delotp.toString()),
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


//showdialog status

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
  void pickup() async {
    showProgressDialog(context);
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + TransVar.token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'pickup'};
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200){
      TransVar.reloadme = "reload";
      Navigator.pop(context);
    }else{
      print(response.body);
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }
  void delivered() async {
    if (ctype == "Image"){
      delfirst();
    }
    if (ctype == "QR Code"){
      delsecond();
    }
    if (ctype == "OTP"){
      setState(() {
        String ot = TransVar.delotp;
        if(ot == "otp"){
          delthird();
        }else
        {
          showotpnot(context);
        }
      });
    }
  }

  void delfirst()async{

   if(TransVar.delimg != null){
     if(TransVar.delsign != null) {
       String base64Image = base64Encode(TransVar.delimg.readAsBytesSync());
       print(base64Image);
       showProgressDialog(context);
       Map<String, String> headers = {
         "Accept": "application/json",
         'Authorization': 'Bearer ' + TransVar.token
       };
       String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
       Map<String, String> body = {
         "transaction_id": transid,
         "action": 'delivered',
         'photo': base64Image,
         'signature': TransVar.delsign,
       }; //
       final response = await http.post(url, headers: headers, body: body);

       if (response.statusCode == 200) {
         TransVar.reloadme = "reload";
         TransVar.delimg = null;
         TransVar.delsign = null;
         Navigator.pop(context);
         print(response.body);
         showerrorimage(context,response.body.toString());
       } else {
         print(response.body);
         showerrorimage(context,response.body.toString());
       }
       Navigator.pop(context);
     }else{
       shownosig(context);
     }
   }else
     {
       shownoimg(context);
     }
   Navigator.pop(context);
  }
  void delsecond()async{
    if(TransVar.qr == transid) {
      //String base64Image = base64Encode(TransVar.delimg.readAsBytesSync());
      //print(base64Image);
      showProgressDialog(context);
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer ' + TransVar.token
      };
      String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
      Map<String, String> body = {
        "transaction_id": transid,
        "action": 'delivered',
        //'photo': TransVar.noimage,
        //'signature': TransVar.noimage,
      }; //
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        TransVar.reloadme = "reload";
        TransVar.delimg = null;
        TransVar.delsign = null;
        Navigator.pop(context);
        print(response.body);
        showerrorimage(context,response.body.toString());
      } else {
        print(response.body);
        showerrorimage(context,response.body.toString());
      }
      Navigator.pop(context);
    }else{
      showwrongqr(context);
    }
    Navigator.pop(context);
  }
  void delthird()async{

      showProgressDialog(context);
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer ' + TransVar.token
      };
      String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
      Map<String, String> body = {
        "transaction_id": transid,
        "action": 'delivered',
       // 'photo': TransVar.noimage,
       // 'signature': TransVar.noimage,
      }; //
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        TransVar.reloadme = "reload";
        TransVar.delimg = null;
        TransVar.delsign = null;

        Navigator.pop(context);
        showerrorimage(context,response.body.toString());
        print(response.body);
      } else {
        print(response.body);
        showerrorimage(context,response.body.toString());
      }
      Navigator.pop(context);
      showerrorimage(context,response.body.toString());

  }

  showerrorimage(BuildContext context, String error) {

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
      content: Text(error),
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


  showwrongqr(BuildContext context) {

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
      content: Text("QR Code is not valid"),
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

  void Complte() async {
    if(TransVar.retsign != null){
      showProgressDialog(context);
      Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + TransVar.token};
      String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
      Map<String, String> body = {"transaction_id": transid, "action": 'completed','signature': TransVar.retsign,};
      final response = await http.post(url,headers: headers,body: body);

      if(response.statusCode == 200){
        TransVar.reloadme = "reload";
        Navigator.pop(context);
        print(response.body);
      }else{
        print(response.body);
      }
      Navigator.pop(context);
    }else{
      shownosig(context);
    }
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: new Center(child: new Text("Byahero", textAlign: TextAlign.center)),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.directions_bus,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
          body: TabBarView(
            children: <Widget>[
              mytab(),
            ],
          ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber[800],
          onPressed: (){
            btns();
          },
          icon: Icon(Icons.save_alt),
          label: Text("Continue"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      ),
    );
  }
}
