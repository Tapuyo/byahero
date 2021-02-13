import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:byaherov1/MyClass/myVar.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';


class DeliverySave extends StatefulWidget {
  String something,dropdownValue;
  DeliverySave(this.something,this.dropdownValue);

  State<StatefulWidget> createState() {


    return MyPage(this.something,this.dropdownValue);
  }
}
class MyPage extends State<DeliverySave> {
  String something,dropdownValue;
  MyPage(this.something,this.dropdownValue);
  File imageFile,signFile;
  ByteData _img = ByteData(0);

  final ImagePicker _picker = ImagePicker();
  final _sign = GlobalKey<SignatureState>();





  otpdialog() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(child: Text('OTP Confirmation',style: TextStyle(fontSize:25),),),
              content: Container(
                height: 250,
                child: Column(
                    children: <Widget>[
                      Image.asset('images/delgiv.gif'),
                      Flexible(
                        child: Container(

                          child: OTPTextField(
                            length: 6,

                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 30,
                            style: TextStyle(
                                fontSize: 20
                            ),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              checkotp(pin);
                            },
                          ),

                        ),
                      )


                    ]
                ),
              )
          );
        }
    );

  }

  showotp(BuildContext context, String mes) {
    Navigator.pop(context);
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OTP"),
      content: Text(mes),
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
  void checkotp(String valotp) async{
    showProgressDialog(context);
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + TransVar.token
    };
    String url = "https://admin.byaherongpinoy.com/api/v1/shipment/otp/confirm/";
    Map<String, String> body = {
      "transaction_no": something,
      "otp_code": valotp,
    }; //
    final response = await http.post(url, headers: headers, body: body);

    String res = json.decode(response.body)['status'];
      if(res == 'success'){
          TransVar.delotp = "otp";
        print(response.body);
        showotp(context,json.decode(response.body)['message']);


      }else
        {
            TransVar.delotp = "";

          print(response.body);
         showotp(context,json.decode(response.body)['message']);

        }




  }


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

                              TransVar.delsign = encoded;
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

                                  TransVar.delsign = encoded;
                                });
                                print(TransVar.delsign);
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

  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);

    showqr(context, barcode);
    setState(() {
      TransVar.qr = barcode;
      TransVar.otp = "";
    });
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
      TransVar.delimg = imageFile;
    });
    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async{
    final picture = await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    this.setState(() {
      imageFile = File(picture.path);
      TransVar.delimg = imageFile;
      String base64Image = base64Encode(TransVar.delimg.readAsBytesSync());
      print(base64Image);
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
    if(imageFile == null){
      return Icon(Icons.picture_in_picture, size: 30, color: Colors.indigo,);
    }else
    {
      return Container(child: Image.file(imageFile, height: 50, width:  50,),);
    }
  }
  Widget _decideImageviewsig(){
    if(_img == null){
      return Icon(Icons.edit, size: 30, color: Colors.indigo,);
    }else
    {
      return Container(child: Image.memory(_img.buffer.asUint8List(), height: 50, width:  50,),);
    }
  }

  showAlertDialogQROTP(BuildContext context) {

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
      title: Text("Confirmation option"),
      content: Text("What would you like to choose?"),
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

  nested() {
    return mybody();
  }

  mybody(){
    if(dropdownValue == 'Image'){
      return Container(
          padding: const EdgeInsets.fromLTRB(2,0,2,2),
          decoration: BoxDecoration(

          ),
          child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset('images/indidelivered.png'),
                  Text("Delivered", style: TextStyle(fontSize: 40, color: Colors.grey),),
                  Text("Delivered Successfully", style: TextStyle(fontSize: 14, color: Colors.grey),),

                  Container(
                    height: 150,
                    child: Image.asset('images/delgiv.gif'),
                  ),

                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20,0,2,2),
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
                          contentPadding: const EdgeInsets.fromLTRB(10,10,10,30),
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
                                    showAlertDialog(context);
                                  },
                                  child: _decideImageview(),
                                )
                            ),
                            Spacer(),
                            FlatButton(
                              onPressed: (){
                                showAlertDialog(context);
                              },
                              color: Colors.white70,
                              child: Text("Add Image", style: TextStyle(color: Colors.indigo),),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    if(dropdownValue == 'QR Code'){
      return Container(
          padding: const EdgeInsets.fromLTRB(2,0,2,2),
          decoration: BoxDecoration(

          ),
          child: Center(
              child: Column(
                children: <Widget>[

                  Image.asset('images/indidelivered.png'),
                  Text("Delivered", style: TextStyle(fontSize: 40, color: Colors.grey),),
                  Text("Delivered Successfully", style: TextStyle(fontSize: 14, color: Colors.grey),),

                  Container(
                    height: 150,
                    child: Image.asset('images/delgiv.gif'),
                  ),


                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20,0,2,2),
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
                          contentPadding: const EdgeInsets.fromLTRB(10,10,10,30),
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
                                    _scan();
                                  },
                                  child: qrotpval(),
                                )
                            ),
                            Spacer(),
                            FlatButton(
                              onPressed: (){
                                _scan();
                              },
                              color: Colors.white70,
                              child: Text("Scan QR", style: TextStyle(color: Colors.indigo),),
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
    if(dropdownValue == 'OTP'){
      return Container(
          padding: const EdgeInsets.fromLTRB(2,0,2,2),
          decoration: BoxDecoration(

          ),
          child: Center(
              child: Column(
                children: <Widget>[

                  Image.asset('images/indidelivered.png'),
                  Text("Delivered", style: TextStyle(fontSize: 40, color: Colors.grey),),
                  Text("Delivered Successfully", style: TextStyle(fontSize: 14, color: Colors.grey),),

                  Container(
                    height: 150,
                    child: Image.asset('images/delgiv.gif'),
                  ),


                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20,0,2,2),
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
                          contentPadding: const EdgeInsets.fromLTRB(10,10,10,30),
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
                                    otpdialog();
                                  },
                                  child: qrotpval(),
                                )
                            ),
                            Spacer(),
                            FlatButton(
                              onPressed: (){
                                otpdialog();
                              },
                              color: Colors.white70,
                              child: Text("OTP Code", style: TextStyle(color: Colors.indigo),),
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

  }

  Widget qrotpval(){
    if(TransVar.otp != "" && TransVar.otp != null){
      return Text(TransVar.otp,);
    }
    if(TransVar.qr != "" && TransVar.qr != null){
      return Text(TransVar.qr,);
    }else{
      return Icon(Icons.code, size: 30, color: Colors.indigo,);
    }


  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: nested()
    );
  }
}