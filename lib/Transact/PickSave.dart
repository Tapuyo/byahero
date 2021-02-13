import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:byaherov1/MyClass/myVar.dart';
import 'dart:typed_data';


class PickSave extends StatefulWidget {
  String something;
  PickSave(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<PickSave> {
  String something;
  MyPage(this.something);

  File _imageFile;
  final picker = ImagePicker();

  ByteData _img = ByteData(0);
  final _sign = GlobalKey();

  getsign (final signme)async{
    TransVar.picksign = signme.getData();

  }

  signaturedialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Sign'),
              content: Container(
                height: 250,
                child: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        child: Signature(

                          color: Colors.black,// Color of the drawing path
                          strokeWidth: 5.0, // with
                          backgroundPainter: null, // Additional custom painter to draw stuff like watermark
                           // Callback called on user pan drawing
                          key: _sign,
                          onSign:  () {
                            final sign = _sign.currentState;
                            getsign(sign);
                          },
                        ),
                      ),
                      Container(
                        width: 200,
                        color: Colors.amber[800],
                        child: FlatButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("Submit", style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ]
                ),
              )
          );
        }
    );

  }




  _openGallery(BuildContext context) async{
    final picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      print("Picture from gallery");
      print(picture);
      _imageFile = File(picture.path);
      TransVar.pickimg = _imageFile;
      print(TransVar.pickimg);
    });
    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async{
    final picture = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      print("Picture from camera");
      print(picture);
      _imageFile = File(picture.path);
      TransVar.pickimg = _imageFile;
      print(TransVar.pickimg);
    });
    Navigator.of(context).pop();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Gallery"),
      onPressed:  () {
        _openGallery(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Camera"),
      onPressed:  () {
        _openCamera(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choice"),
      content: Text("What would you like to open?"),
      actions: [
        cancelButton,
        continueButton,
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

  Widget _decideImageview(){
    if(_imageFile == null){
      return Icon(Icons.picture_in_picture, size: 30, color: Colors.indigo,);
    }else
      {
        return Container(child: Image.file(_imageFile, height: 50, width:  50,),);
      }
  }

  nested() {
    return mybody();
  }

  mybody(){
    return Container(
        padding: const EdgeInsets.fromLTRB(2,0,2,2),
        decoration: BoxDecoration(

        ),
        child: Center(
            child: Column(


              children: <Widget>[

                Image.asset('images/indipickup.png'),
                Text("Pick Up", style: TextStyle(fontSize: 40, color: Colors.grey),),


                Container(
                  height: 150,
                  child: Image.asset('images/delgiv.gif'),
                ),

                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(30,20,2,2),
                      child: Text("Notes", style: TextStyle(color: Colors.grey, fontSize: 14.0),),
                    )

                  ],
                ),

                Container(

                    padding: const EdgeInsets.fromLTRB(30,5,30,2),
                    child: TextField(
                      //controller: emailController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autocorrect: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10,30,10,30),
                        border: new OutlineInputBorder(

                            borderSide: new BorderSide(color: Colors.white)
                        ),


                      ),
                    )
                ),








              ],
            )
        )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: nested(),
    );
  }
}