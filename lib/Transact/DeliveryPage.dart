import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocation/geolocation.dart';
import 'dart:async';

class DeliveryPage extends StatefulWidget {
  String something,transid;
  String delname,pickadd,pickcon;
  String picklat,picklong;
  String mylat,mylong;

  DeliveryPage(this.something,this.transid,this.delname,this.pickadd,this.pickcon,this.picklat,this.picklong,this.mylat,this.mylong);

  State<StatefulWidget> createState() {


    return MyPage(this.something,this.transid,this.delname,this.pickadd,this.pickcon,this.picklat,this.picklong,this.mylat,this.mylong);
  }
}
class MyPage extends State<DeliveryPage> {
  String something,transid;
  String delname,pickadd,pickcon;
  String picklat,picklong;

  String mylat,mylong;
  MyPage(this.something,this.transid,this.delname,this.pickadd,this.pickcon,this.picklat,this.picklong,this.mylat,this.mylong);

  LocationResult locations = null;
  StreamSubscription<LocationResult> streamSubscription;
  bool trackLocation = false;


  initState() {
    super.initState();
    checkGps();


  }


  getLocations() {
    if (trackLocation) {
      setState(() => trackLocation = false);
      streamSubscription.cancel();
      streamSubscription = null;
      locations = null;
    } else {
      setState(() => trackLocation = true);

      streamSubscription = Geolocation
          .locationUpdates(
        accuracy: LocationAccuracy.best,
        displacementFilter: 0.0,
        inBackground: true,
      )
          .listen((result) {
        final location = result;

      });

      streamSubscription.onDone(() => setState(() {
        trackLocation = false;
      }));
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
  _dialogNum(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Call"),
      onPressed:  () {
        _callMe();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Text"),
      onPressed:  () {
        _textMe();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choice"),
      content: Text("What would you like to do?"),
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
  _callMe() async {
    // Android
    String uri = 'tel:' + pickcon ;
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }




  _textMe() async {
    // Android
    String uri = 'sms:' + pickcon + '?body=Good day,';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:0039-222-060-888';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  _launchURL() async {
    print("googlemap");
    String url = "https://www.google.com/maps/dir/?api=1&origin=" +
        mylat + "," + mylong + "&destination=" + picklat + "," + picklong + "&travelmode=driving&dir_action=navigate";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _waze() async {
    String url = "https://waze.com/ul?ll="+ picklat + "%2C" + picklong + "&navigate=yes&zoom=17";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Googel Map"),
      onPressed:  () {
        _launchURL();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Waze"),
      onPressed:  () {
        _waze();
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



  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,

                background: Container(
                  child: Container(

                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(0,50,0,0),//images/indi.png
                      child: Column(
                        children: <Widget>[
                          Image.asset('images/inditransit.png'),
                          Text("Delivery In-Transit", style: TextStyle(fontSize: 40, color: Colors.grey),),
                          Text("Delivery is on the wy to delivery point", style: TextStyle(fontSize: 14, color: Colors.grey),),
                          Container(height: 150,child: Image.asset('images/carrunn.gif'),),
                        ],
                      )

                  ),
                )

            ),
          )
        ];
      },
      body: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white70,


          ),

          child: Container(
            child: mybody(),
          )
      ),
    );
  }
  maymap(){

    return Container(
      height: 150,
      child: Image.asset('images/carrunn.gif'),
    );

  }

  mybody(){
    return Container(

        child: Container(

          child: GestureDetector(

            onTap: () {


            },
            child: ListTile(

                title: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(2,2,2,5),
                      child: Text("Transaction ID: " + transid, style: TextStyle(color: Colors.white, fontSize: 12.0),),
                    ),
                  ],
                ),
                subtitle: Container(


                  child: Column(
                    children: <Widget>[





                      Card(
                        child: GestureDetector(
                          onTap: (){
                            _dialogNum(context);
                          },

                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5,5,5,10),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[

                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                              fit: FlexFit.loose,
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                child:  Icon(
                                                  Icons.phone_android,
                                                  color: Colors.indigo,
                                                  size: 30.0,
                                                ),
                                              )
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(5,0,5,0),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text("Contact No", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                          ),

                                        ],
                                      ),

                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text(pickcon, style: TextStyle(color: Colors.grey),),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          height: 40,
                                          width: 40,
                                          child: GestureDetector(
                                              onTap: (){
                                                _callMe();
                                              },
                                              child: Icon(Icons.call, color: Colors.indigo,))
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      ),
                                      Container(
                                          height: 40,
                                          width: 40,
                                          child: GestureDetector(
                                              onTap: (){
                                                _textMe();
                                              },
                                              child: Icon(Icons.chat, color: Colors.indigo))
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),


                          ),
                        ),

                      ),

                      Card(
                        child: GestureDetector(
                          onTap: (){
                            _showAlertDialog(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(5,5,5,10),

                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    child:  Icon(
                                                      Icons.add_location,
                                                      color: Colors.indigo,
                                                      size: 30.0,
                                                    ),
                                                  )
                                              ),
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(5,0,5,0),
                                              ),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text("Address", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                              ),


                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(pickadd, style: TextStyle(color: Colors.grey, fontSize: 14.0),),
                                              ),

                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            height: 40,
                                            width: 40,
                                            child: GestureDetector(
                                                onTap: (){
                                                  _launchURL();
                                                },
                                                child: Image.asset('images/googlemap.png'))
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        ),
                                        Container(
                                            height: 40,
                                            width: 40,
                                            child: GestureDetector(
                                                onTap: (){
                                                  _waze();
                                                },
                                                child: Image.asset('images/waze.png'))
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                          ),
                        ),

                      ),



                    ],
                  ),
                )


            ),
          ),
        )

    );
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child:nested(),
      ),
    );
  }
}