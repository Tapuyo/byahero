import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:byaherov1/Transact/PickPage.dart';
import 'package:byaherov1/Transact/DeliveryPage.dart';
import 'package:byaherov1/Transact/ReturnPage.dart';
import 'package:byaherov1/Transact/PickSave.dart';
import 'package:byaherov1/Transact/DeliverySave.dart';
import 'package:byaherov1/Transact/ReturnSave.dart';
import 'package:byaherov1/Transact/Dispatch.dart';
import 'package:geolocation/geolocation.dart';
import 'dart:async';
import 'package:byaherov1/MyClass/myVar.dart';
import 'package:tts/tts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class TransactionStart extends StatefulWidget {
  String token,stat,transid;
  String pickadd,pickcon;
  String picklat,picklong;
  String delname,deladd,dellat,dellong,delcon;
  String mlat,mlong;

  TransactionStart(this.token,this.stat,this.transid,this.pickadd,this.pickcon,this.picklat,this.picklong,this.delname,this.deladd,this.dellat,this.dellong,this.delcon,this.mlat,this.mlong);

  State<StatefulWidget> createState() {


    return MyPage(this.token,this.stat,this.transid,this.pickadd,this.pickcon,this.picklat,this.picklong,this.delname,this.deladd,this.dellat,this.dellong,this.delcon,this.mlat,this.mlong);
  }
}
class MyPage extends State<TransactionStart> {
  bool locis = true;
  String togle = "Start traveling to pickup location.";
  bool boldis = true;
  bool bolpickinf,bolpick,boltrans,boldelinf,boldel,bolret,bolretinf,bolretcom = false;
  String token,stat,transid;
  String pickadd,pickcon;
  String picklat,picklong;
  String delname,deladd,dellat,dellong,delcon;
  String mlat,mlong;

  final notcontroller = TextEditingController();
  final apcontroller = TextEditingController();


  MyPage(this.token,this.stat,this.transid,this.pickadd,this.pickcon,this.picklat,this.picklong,this.delname,this.deladd,this.dellat,this.dellong,this.delcon,this.mlat,this.mlong);





  int tabindex = 0;
  String swipevale = "Click to Start";
  LocationResult locations = null;
  StreamSubscription<LocationResult> streamSubscription;
  bool trackLocation = false;




  dynamic _controller;
  int _shouldAnimate = 0;

  initState() {
    print(stat);
    if(stat == '1'){
      swipevale = "Click to Start";
      speak("'Get ready for starting the transaction.'");
      tabindex = 0;
      _controller  = PageController(initialPage: 0, keepPage: false);
    }
    if(stat == '2'){
      swipevale = "Click to Start";
      speak("'Get ready for starting the transaction.'");
      tabindex = 0;
      _controller  = PageController(initialPage: 0, keepPage: false);
    }
    if(stat == '3'){
      swipevale = "Click to Start";
      speak("'Get ready for starting the transaction.'");
      tabindex = 0;
      _controller  = PageController(initialPage: 0, keepPage: false);
    }
    if(stat == '4'){
      swipevale = "Click to Start";
      speak("'Get ready for starting the transaction.'");
      tabindex = 0;
      _controller  = PageController(initialPage: 0, keepPage: false);
    }
    if(stat == '5'){
      swipevale = "Pickup Item";
      _shouldAnimate = 0;
      tabindex = 2;
      print(tabindex);
      _controller  = PageController(initialPage: 2, keepPage: false);
    }
    if(stat == "6"){
      swipevale = "Start Transit";
      _shouldAnimate = 2;
      tabindex = 4;
      _controller  = PageController(initialPage: 3, keepPage: false);
    }
    if(stat == "7"){
      swipevale = "Delivery Item";
      _shouldAnimate = 3;
      tabindex = 5;
      _controller  = PageController(initialPage: 4, keepPage: false);
    }
    if(stat == "8"){
      swipevale = "Go to container yard";
      _shouldAnimate = 5;
      tabindex = 6;
      _controller  = PageController(initialPage: 5, keepPage: false);
    }
    if(stat == "9"){
      swipevale = "Complete";
      _shouldAnimate = 6;
      tabindex = 9;
      _controller  = PageController(initialPage: 6, keepPage: false);
    }

    checkGps();
    super.initState();



  }
  stoplocation(){
    setState(() => trackLocation = false);
    streamSubscription.cancel();
    streamSubscription = null;
    locations = null;
  }
  getLocations() {
    if (trackLocation) {
      setState(() => trackLocation = false);
      streamSubscription.cancel();
      streamSubscription = null;
      locations = null;
    } else {
      setState(() => trackLocation = true);
//location
      streamSubscription = Geolocation
          .locationUpdates(
        accuracy: LocationAccuracy.best,
        displacementFilter: 0.0,
        inBackground: true,
      )
          .listen((result) {
        final location = result;
        setState(() {

          locations = location;
          notcontroller.text = "Longitude: " + locations.location.longitude.toString() + ", Latitude: " + locations.location.longitude.toString();
          sendcoor();
        });
      });


    }

  }

  checkGps() async {
    final GeolocationResult result = await Geolocation.isLocationOperational();
    if (result.isSuccessful) {
      try {
        getLocations();
      } on Exception catch (_) {
        print("throwing new error");
      }
    } else {
      trackLocation = false;
      locations = null;
      print("Failed");
    }
  }



  Future sendcoor() async{
    print(transid);
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + token};
    var body = jsonEncode({"longitude": locations.location.latitude, "latitude": locations.location.longitude, "transaction_id": transid});
    String url = "https://admin.byaherongpinoy.com/api/v1/shipment/location/set-current/";
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200)
    {


        print(response.body.toString());


    }else{
      print('Failed to get data');
      print(response.body.toString());
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



  void dispatch() async {
    showProgressDialog(context);
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'dispatch'};
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200){
      apcontroller.text = response.body.toString();
      print(response.body);
      speak("You are now going to pick up point.");
      setState(() {
        togle = "Your on way to pickup location.";
        bolpickinf = true;
        swipevale = "Pickup Item";
      });
      _controller.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeOut);
    }else{
      apcontroller.text = response.body.toString();
      _shouldAnimate--;
      _controller.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeOut);
      print(response.body);
    }
    Navigator.pop(context);
  }
  void pickup() async {
    showProgressDialog(context);
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'pickup'};
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200){
      apcontroller.text = response.body.toString();
      print(response.body);
      transit();
      speak("Success");

      setState(() {

        togle = "Start travelling to delivery location.";
        boltrans = true;
        swipevale = "Delivery Item";
      });
      _controller.animateToPage(3, duration: Duration(seconds: 1), curve: Curves.easeOut);
    }else{
      apcontroller.text = response.body.toString();
      print(response.body);
      _shouldAnimate--;
      _controller.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.easeOut);
    }
    Navigator.pop(context);
  }
  void transit() async {

    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'transit'};
    final response = await http.post(url,headers: headers,body: body);

    print(response.body);
  }
  void delivered() async {
    getLocations();

    //if(TransVar.delimg != null){

      if(TransVar.delsign != null){
        String base64Image = base64Encode(TransVar.delimg.readAsBytesSync());
        print(base64Image);
        if(TransVar.qr != transid) {
          showProgressDialog(context);
          Map<String, String> headers = {
            "Accept": "application/json",
            'Authorization': 'Bearer ' + token
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
            TransVar.delsign = null;
            TransVar.delimg = null;
            apcontroller.text = response.body.toString();
            speak("You delivered the item successfully, and you are now in returning to container yard");
            print(response.body);
            setState(() {
              togle = "Start returning to container yard.";
              bolret = true;
              swipevale = "Go to Container Yard";
            });
            _controller.animateToPage(5, duration: Duration(seconds: 1), curve: Curves.easeOut);
            returning();
          } else {
            apcontroller.text = response.body.toString();
            print(response.body);
            _shouldAnimate--;
            _controller.animateToPage(4, duration: Duration(seconds: 1), curve: Curves.easeOut);
          }
          Navigator.pop(context);
        }else
        {
          showwrongqr(context);
          _shouldAnimate--;
          _controller.animateToPage(5, duration: Duration(seconds: 1), curve: Curves.easeOut);
        }
      }else{
        shownosig(context);
      }
    //}else{
    //  shownoimg(context);
    //}
    getLocations();

  }
  void returning() async {

    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'return'};
    final response = await http.post(url,headers: headers,body: body);
    print(response.body);
  }
  void complete() async {
    showProgressDialog(context);
      Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + token};
      String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
      Map<String, String> body = {"transaction_id": transid,"action": 'completed'};
      final response = await http.post(url, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        apcontroller.text = response.body.toString();
        print(response.body);
        speak("Congratulations! You successfully finish the transaction.");
        stoplocation();
        Navigator.pop(context);
        showAlertDialog(context);
        setState(() {
          locis = false;
        });
        Navigator.pop(context);
      } else {
        apcontroller.text = response.body.toString();
        print(response.body);
        _shouldAnimate--;
        _controller.animateToPage(8, duration: Duration(seconds: 1), curve: Curves.easeOut);
      }
    Navigator.pop(context);
    }

  speak(String tspk) async {
    final languages = await Tts.getAvailableLanguages();
    print(languages);
    var isGoodLanguage = await Tts.isLanguageAvailable("fil-PH");
    print(isGoodLanguage);
    Tts.speak(tspk);

  }

  choose1(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget okBotton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        dispatch();

      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Do you want to continue?"),
      actions: [
        okBotton,
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
  choose2(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget okBotton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        pickup();

      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Do you want to continue?"),
      actions: [
        okBotton,
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
  choose3(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget okBotton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        delivered();

      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Do you want to continue?"),
      actions: [
        okBotton,
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
  choose4(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget okBotton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        speak("You arrive to container yard");
        _controller.animateToPage(6, duration: Duration(seconds: 1), curve: Curves.easeOut);
        setState(() {
          togle = "You are now on way to container yard.";
          bolretinf = true;
          swipevale = "Complete";
        });
        returning();

      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Do you want to continue?"),
      actions: [
        okBotton,
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
  choose5(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget okBotton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        print("The page count is " + _shouldAnimate.toString());
        complete();

      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
      content: Text("Do you want to continue?"),
      actions: [
        okBotton,
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
//next pages
  _nxtpage(){

    _shouldAnimate++;
    print(_shouldAnimate);
    if(_shouldAnimate == 1){

     choose1(context);
    }

    if(_shouldAnimate == 2){
      speak("You arrive to your pick up point.");
      setState(() {
        togle = "You are now on pickup location";
        bolpick = true;
        swipevale = "Start Transit";
      });

      _controller.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.easeOut);
    }

    if(_shouldAnimate == 3){

      choose2(context);

    }




    if(_shouldAnimate == 4){
      speak("You arrive to your delivery point");

      setState(() {
        togle = "You are now delivery location.";
        boldel = true;
        swipevale = "Confirm Delivery";
      });
      _controller.animateToPage(4, duration: Duration(seconds: 1), curve: Curves.easeOut);
    }

    if(_shouldAnimate == 5){

      choose3(context);

    }


    if(_shouldAnimate == 6){
    choose4(context);

    }
    if(_shouldAnimate == 7){

      choose5(context);

    }

    //Complete task after this will close



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
      title: Text("Image!"),
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

//showdialog status
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
      content: Text("Please take/upload a picture."),
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

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Congrats!"),
      content: Text("You completed the transaction. Thank you for using byahero app."),
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
  int swipeme;
  bool phys = true;

  Widget fbod(){
    if(TransVar.snacknot == false){
      return SlidingUpPanel(
        panel: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 10,
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Icon(Icons.drag_handle, color: Colors.grey,),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10,25,5,5),
                    child: Text('System response:'),
                  ),


                ],
              ),
            ),

            Positioned(
                left: 0,
                top: 50,
                right: 0,
                bottom: 100,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10,25,0,2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text("GPS Location", style: TextStyle(color: Colors.black45),),
                      ),
                      Container(
                          child: TextField(
                            style: TextStyle(fontSize: 12),
                            controller: notcontroller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            autocorrect: true,

                          )
                      ),
                    ],
                  ),
                )
            ),
            Positioned(
                left: 0,
                top: 50,
                right: 0,
                bottom: 100,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10,120,0,2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text("Web com", style: TextStyle(color: Colors.black45),),
                      ),
                      Container(
                          child: TextField(
                            style: TextStyle(fontSize: 12),
                            controller: apcontroller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            autocorrect: true,

                          )
                      ),
                    ],
                  ),
                )
            ),

          ],
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(5,0,5,5),
          child: Container(
            child: PageView(
              onPageChanged: (swipeme){},
              physics: swipme(),
              controller: _controller,
              children: <Widget>[
                Dispatch(mlat,mlong,picklat,picklong,dellat,dellong),
                PickPage(token,transid,pickadd,pickcon,picklat,picklong,mlat,mlong),
                PickSave(token),
                DeliveryPage(token,transid,delname,deladd,delcon,dellat,dellong,mlat,mlong),
                DeliverySave(token,""),
                //Returning(),
                ReturnPage(token,transid,pickadd,pickcon,picklat,picklong,mlat,mlong),
                ReturnSave(token),

              ],

            ),


          ),
        ),


      );

    }else{
      return Container(
        padding: const EdgeInsets.fromLTRB(5,0,5,5),
        child: Container(
          child: PageView(
            onPageChanged: (swipeme){},
            physics: swipme(),
            controller: _controller,
            children: <Widget>[
              Dispatch(mlat,mlong,picklat,picklong,dellat,dellong),
              PickPage(token,transid,pickadd,pickcon,picklat,picklong,mlat,mlong),
              PickSave(token),
              DeliveryPage(token,transid,delname,deladd,delcon,dellat,dellong,mlat,mlong),
              DeliverySave(token,""),
              //Returning(),
              ReturnPage(token,transid,pickadd,pickcon,picklat,picklong,mlat,mlong),
              ReturnSave(token),

            ],

          ),


        ),
      );
  }
  }


  //widget start
  Widget build(BuildContext context) {
    return Scaffold(

        body: fbod(),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber[800],
        onPressed: (){
          _nxtpage();
        },
        icon: Icon(Icons.arrow_forward_ios),
        label: Text(swipevale),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }

  swipme(){
    if(phys == false){
      return new NeverScrollableScrollPhysics();
    }else
      {
        return null;
      }

  }

}
