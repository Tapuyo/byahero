
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocation/geolocation.dart';
import 'dart:async';


class viewinf extends StatefulWidget {
  String something,transid;
  String pickadd,pickcon;
  String picklat,picklong;
  String delname,deladd,dellat,dellong,delcon;
  String mlat,mlong;
  int stat;
  String info,slug;
  String shipstat,shipline,shiptype,containerweight,container;
  String retname,retlat,retlong;

  viewinf(this.something,this.stat,this.transid,this.pickadd,this.pickcon,this.picklat,this.picklong,this.delname,this.deladd,this.dellat,this.dellong,this.delcon,this.mlat,this.mlong,this.info,this.slug,
      this.shipstat,this.shipline,this.shiptype,this.containerweight,this.container,this.retname,this.retlat,this.retlong);

  State<StatefulWidget> createState() {


    return MyPage(this.something,this.stat,this.transid,this.pickadd,this.pickcon,this.picklat,this.picklong,this.delname,this.deladd,this.dellat,this.dellong,this.delcon,this.mlat,this.mlong,this.info,this.slug,
        this.shipstat,this.shipline,this.shiptype,this.containerweight,this.container,this.retname,this.retlat,this.retlong);
  }
}
class MyPage extends State<viewinf> {
  String something,transid;
  String pickadd,pickcon;
  String picklat,picklong;
  String delname,deladd,dellat,dellong,delcon;
  String mlat,mlong;
  int stat;
  String shipstat,shipline,shiptype,containerweight,container;
  String info,slug;
  String retname,retlat,retlong;

  String mylat,mylong;
  MyPage(this.something,this.stat,this.transid,this.pickadd,this.pickcon,this.picklat,this.picklong,this.delname,this.deladd,this.dellat,this.dellong,this.delcon,this.mlat,this.mlong,this.info,this.slug,
      this.shipstat,this.shipline,this.shiptype,this.containerweight,this.container,this.retname,this.retlat,this.retlong);

  LocationResult locations = null;
  StreamSubscription<LocationResult> streamSubscription;
  bool trackLocation = false;


  initState() {
    super.initState();
    //getLocations();


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
    String con;
    if(stat == 4){
      con = pickcon;
    }
    if(stat == 5){
      con = pickcon;
    }
    if(stat == 6){
      con = delcon;
    }
    if(stat == 7){
      con = delcon;
    }
    if(stat == 8){
      con = pickcon;
    }
    if(stat == 9){
      con = pickcon;
    }
    String uri = 'tel:' + con ;
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
    String con;
    if(stat == 4){
      con = pickcon;
    }
    if(stat == 5){
      con = pickcon;
    }
    if(stat == 6){
      con = delcon;
    }
    if(stat == 7){
      con = delcon;
    }
    if(stat == 8){
      con = pickcon;
    }
    if(stat == 9){
      con = pickcon;
    }
    String uri = 'sms:' + con + '?body=Good day,';
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



  _launchURL() async {
    String deslat, deslong;
    if(stat == 4){
      deslat = picklat;
      deslong = picklong;
    }
    if(stat == 5){
      deslat = picklat;
      deslong = picklong;
    }
    if(stat == 6){
      deslat = dellat;
      deslong = dellong;
    }
    if(stat == 7){
      deslat = dellat;
      deslong = dellong;
    }
    if(stat == 8){
      deslat = retlat;
      deslong = retlong;
    }
    if(stat == 9){
      deslat = retlat;
      deslong = retlong;
    }
    String url = "https://www.google.com/maps/dir/?api=1&origin=" +
        mlat + "," + mlong+ "&destination=" + deslat + "," + deslong + "&travelmode=driving&dir_action=navigate";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _waze() async {
    String deslat, deslong;
    if(stat == 4){
      deslat = picklat;
      deslong = picklong;
    }
    if(stat == 5){
      deslat = picklat;
      deslong = picklong;
    }
    if(stat == 6){
      deslat = dellat;
      deslong = dellong;
    }
    if(stat == 7){
      deslat = dellat;
      deslong = dellong;
    }
    if(stat == 8){
      deslat = retlat;
      deslong = retlong;
    }
    if(stat == 9){
      deslat = retlat;
      deslong = retlong;
    }
    String url = "https://waze.com/ul?ll="+ deslat + "%2C" + deslong + "&navigate=yes&zoom=17";
    print(url);
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
  mytop(){
  if(stat == 4){
    return Column(
      children: <Widget>[
        Image.asset('images/indi.png'),
        Text("Scheduled", style: TextStyle(fontSize: 35, color: Colors.grey),),
        Container(height: 5,),
        Text("Driver task details.", style: TextStyle(fontSize: 14, color: Colors.grey),),

      ],
    );
  }
  if(stat == 5){
    return Column(
      children: <Widget>[
        Image.asset('images/indidispatch.png'),
        Text("Dispatched", style: TextStyle(fontSize: 35, color: Colors.grey),),
        Container(height: 5,),
        Text("Driver is on the way to pickup point.", style: TextStyle(fontSize: 14, color: Colors.grey),),


      ],
    );
  }
  if(stat == 6){
    return Column(
      children: <Widget>[
        Image.asset('images/inditransit.png'),
        Text("Delivery In-Transit", style: TextStyle(fontSize: 35, color: Colors.grey),),
        Container(height: 5,),
        Text("Driver is on the way to delivery point", style: TextStyle(fontSize: 14, color: Colors.grey),),

      ],
    );
  }
  if(stat == 7){
    return Column(
      children: <Widget>[
        Image.asset('images/inditransit.png'),
        Text("Delivery In-Transit", style: TextStyle(fontSize: 35, color: Colors.grey),),
        Container(height: 5,),
        Text("Driver is on the way to  delivery point", style: TextStyle(fontSize: 14, color: Colors.grey),),

      ],
    );
  }
  if(stat == 8){
    return Column(
      children: <Widget>[
        Image.asset('images/inditranor.png'),
        Text("In-Transit to Origin", style: TextStyle(fontSize: 35, color: Colors.grey),),
        Container(height: 5,),
        Text("Driver is on the way to return container", style: TextStyle(fontSize: 14, color: Colors.grey),),

      ],
    );
  }
  if(stat == 9){
    return Column(
      children: <Widget>[
        Image.asset('images/inditranor.png'),
        Text("In-Transit to Origin", style: TextStyle(fontSize: 35, color: Colors.grey),),
        Container(height: 5,),
        Text("Driver is on the way to return container", style: TextStyle(fontSize: 14, color: Colors.grey),),

      ],
    );
  }

  }


  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,

                background: Container(

                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(0,40,0,0),//images/indi.png
                    child: mytop(),
                )

            ),
          )
        ];
      },
      body: Container(
          //padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white70,

          ),

          child: Column(
            children: <Widget>[
              mytop(),
              Text("Container Description: " + info, style: TextStyle(color: Colors.grey),),


              mybody(),
            ],
          )
      ),
    );
  }

  mynumber(){
    if(stat == 4){
      return Text(pickcon, style: TextStyle(color: Colors.grey),);
    }
    if(stat == 5){
      return Text(pickcon, style: TextStyle(color: Colors.grey),);
    }
    if(stat == 6){
      return Text(delcon, style: TextStyle(color: Colors.grey),);
    }
    if(stat == 7){
      return Text(delcon, style: TextStyle(color: Colors.grey),);
    }
    if(stat == 8){
      return Text(pickcon, style: TextStyle(color: Colors.grey),);
    }
    if(stat == 9){
      return Text(pickcon, style: TextStyle(color: Colors.grey),);
    }
  }
  mynadd(){
    if(stat == 4){
      return Text(pickadd, style: TextStyle(color: Colors.grey, fontSize: 14.0),);
    }
    if(stat == 5){
      return Text(pickadd, style: TextStyle(color: Colors.grey, fontSize: 14.0),);
    }
    if(stat == 6){
      return Text(deladd, style: TextStyle(color: Colors.grey, fontSize: 14.0),);
    }
    if(stat == 7){
      return Text(deladd, style: TextStyle(color: Colors.grey, fontSize: 14.0),);
    }
    if(stat == 8){
      return Text(retname, style: TextStyle(color: Colors.grey, fontSize: 14.0),);
    }
    if(stat == 9){
      return Text(retname, style: TextStyle(color: Colors.grey, fontSize: 14.0),);
    }
  }


  mybody(){
    return SingleChildScrollView(

        child: Container(

          child: GestureDetector(

            onTap: () {


            },
            child: ListTile(

                title: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(2,0,2,2),
                      child: Text("Transaction ID: " + "transid", style: TextStyle(color: Colors.white, fontSize: 12.0),),
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
                            padding: const EdgeInsets.fromLTRB(5,5,5,5),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[

                                      Container(
                                        padding: const EdgeInsets.fromLTRB(5,0,0,0),
                                        child: Row(
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
                                      ),

                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: mynumber(),
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      ),
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
                            padding: const EdgeInsets.fromLTRB(5,5,5,5),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[


                                        Container(
                                          padding: const EdgeInsets.fromLTRB(5,0,0,0),
                                          child: Row(
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
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: mynadd(),
                                              ),

                                            ],
                                          ),
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
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      ),
                                      Container(
                                        color: Colors.white,
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
                                          color: Colors.white,
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

                      Card(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5,5,5,10),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[

                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text("Container Weight", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(containerweight, style: TextStyle(color: Colors.grey, fontSize: 16.0),),
                                            ),

                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ),
                        ),

                      ),
                      Card(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5,5,5,10),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[

                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text("Container Size", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(container, style: TextStyle(color: Colors.grey, fontSize: 16.0),),
                                            ),

                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ),
                        ),

                      ),
                      Card(
                        child: GestureDetector(

                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5,5,5,10),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[

                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text("Shipment Line", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(shipline, style: TextStyle(color: Colors.grey, fontSize: 16.0),),
                                            ),

                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ),
                        ),

                      ),
                      Card(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5,5,5,10),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[

                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text("Shipment Type", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(shiptype, style: TextStyle(color: Colors.grey, fontSize: 16.0),),
                                            ),

                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ),
                        ),

                      ),
                      Card(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5,5,5,10),

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[

                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text("Shipment Status", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(shipstat, style: TextStyle(color: Colors.grey, fontSize: 16.0),),
                                            ),

                                          ],
                                        ),


                                      ],
                                    ),
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
  btnpress(){
    Navigator.pop(context);

  }

  Widget build(BuildContext context) {
    return Scaffold(
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

      body: SingleChildScrollView(
        //padding: EdgeInsets.all(10.0),


          child: Column(
            children: <Widget>[
              mytop(),
              Container(height: 20,),
              Container(
                  child: Text("Container Description: " , style: TextStyle(color: Colors.black),)),
              Container(height: 5,),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(info, style: TextStyle(color: Colors.grey),)),

              mybody(),
            ],
          )
      ),
      //floatingActionButton: FloatingActionButton.extended(
      //  backgroundColor: Colors.amber[800],
      //  onPressed: (){
      //    btnpress();
      //  },
      //  icon: Icon(Icons.arrow_back),
      //  label: Text("Continue"),
      //),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}