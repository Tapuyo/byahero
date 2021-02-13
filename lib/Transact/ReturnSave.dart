import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:byaherov1/MyClass/myVar.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class ReturnSave extends StatefulWidget {
  String something;
  ReturnSave(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ReturnSave> {
  String something;
  MyPage(this.something);
  final _sign = GlobalKey<SignatureState>();
  ByteData _img = ByteData(0);

  File imageFile;
  final ImagePicker _picker = ImagePicker();

  signaturedialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Sign'),
              content: Container(
                height: 270,
                width: 250,
                child: Column(
                    children: <Widget>[
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)
                          ),
                          padding: EdgeInsets.all(10.0),
                          height: 200,
                          child: Signature(
                            color: Colors.black,// Color of the drawing path
                            strokeWidth: 5.0, // with
                            backgroundPainter: null, // Additional custom painter to draw stuff like watermark
                            key: _sign,
                            onSign: () async{
                              final sign = _sign.currentState;
                              final image = await sign.getData();
                              var data = await image.toByteData();
                              final encoded = base64.encode(data.buffer.asUint8List());
                              _img = await image.toByteData(format: ui.ImageByteFormat.png);
                              setState(() {

                                TransVar.retsign = encoded;
                              });
                            },// key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0,10,0,0),
                              color: Colors.white,
                              child: FlatButton(
                                onPressed: (){
                                  final sign = _sign.currentState;
                                  sign.clear();
                                },
                                child: Text("Clear", style: TextStyle(color: Colors.black),),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(

                              color: Colors.amber[800],
                              child: FlatButton(
                                onPressed: ()async{
                                  final sign = _sign.currentState;
                                  final image = await sign.getData();
                                  var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                  final encoded = base64.encode(data.buffer.asUint8List());
                                  _img = await image.toByteData(format: ui.ImageByteFormat.png);
                                  setState(() {
                                    TransVar.retsign = encoded;
                                  });
                                  print(TransVar.retsign);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Submit", style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ]
                ),
              )
          );
        }
    );

  }


  otpdialog() {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('OTP'),
              content: Container(
                height: 100,
                child: Column(
                    children: <Widget>[
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10,10,10,10),
                          child: TextField(
                              keyboardType: TextInputType.number,
                               // Only numbers
                              style: TextStyle(
                                  fontSize: 24.0,
                                  height: 2.0,
                                  color: Colors.black,


                              )
                          )
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


  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);
    Navigator.of(context).pop();
    showqr(context, barcode);
  }
  showqr(BuildContext context, String qrcode) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("QR Code"),
      content: Text(qrcode),
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

  _openGallery(BuildContext context) async{
    final picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture.path);
      TransVar.retimg = imageFile;
    });
    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async{
    final picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture.path);
      TransVar.retimg = imageFile;
    });
    Navigator.of(context).pop();
  }

  showAlertDialogImage(BuildContext context) {
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
    if(imageFile == null){
      return Icon(Icons.picture_in_picture, size: 30, color: Colors.indigo,);
    }else
    {
      return Container(child: Image.file(imageFile, height: 50, width:  50,),);
    }
  }



  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("QR Code"),
      onPressed:  () {
        _scan();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("OTP"),
      onPressed:  () {
        otpdialog();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose"),
      content: Text("What would you like to scan?"),
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
  Widget _decideImageviewsig(){
    if(_img == null){
      return Icon(Icons.edit, size: 30, color: Colors.indigo,);
    }else
    {
      return Container(child: Image.memory(_img.buffer.asUint8List(), height: 50, width:  50,),);
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

                Image.asset('images/indicomplete.png'),
                Text("Complete", style: TextStyle(fontSize: 40, color: Colors.grey),),

                Container(
                  height: 150,
                  child: Image.asset('images/indicomplete.gif'),
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

                Container(
                  padding: const EdgeInsets.fromLTRB(25,10,25,2),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(

                              color: Colors.white,
                              child: GestureDetector(
                                onTap: (){
                                  signaturedialog();
                                },
                                child: _decideImageviewsig(),
                              )
                          ),
                          Spacer(),
                          FlatButton(
                            onPressed: (){
                              signaturedialog();
                            },
                            color: Colors.white70,
                            child: Text("Signature", style: TextStyle(color: Colors.indigo),),
                          ),
                        ],
                      ),
                    ),
                  ),
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