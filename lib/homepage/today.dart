import 'package:byaherov1/MyClass/myVar.dart';
import 'package:byaherov1/homepage/viewinf.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocation/geolocation.dart';
import 'dart:async';
import 'package:byaherov1/homepage/intrans.dart';
import 'package:workmanager/workmanager.dart';
import 'package:byaherov1/MyClass/notification.dart' as notif;
import 'package:draggable_fab/draggable_fab.dart';

const fetchBackground = "fetchBackground";

class today extends StatefulWidget {

  String something;
  today(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<today> {


  String something;
  MyPage(this.something);
  int dtme = 0;
  int _counter = 1;
  int undonetask = 0;
  int todaytask = 0;





  dynamic _scrollController;
  String transid;
  String bt = "Dispatch";
  bool trackLocation = false;





  LocationResult locations = null;
  StreamSubscription<LocationResult> streamSubscription;

  void initState() {

      todaytask = 0;
      undonetask = 0;

    if(TransVar.reloadme == "reloadme"){
      print("asdnalsdlajdslajsdlkjaslkdjasd");
      TransVar.reloadme = "";
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (BuildContext context) => super.widget));

    }


    super.initState();
      //getUsers();
      //getLocations();


//    Workmanager.initialize(
//      callbackDispatcher,
//      isInDebugMode: true,
//    );
//    Workmanager.registerPeriodicTask(
//      "1",
//      fetchBackground,
//      frequency: Duration(minutes: 30),
//    );
  }



  void callbackDispatcher() {
    Workmanager.executeTask((task, inputData) async {
      switch (task) {
        case fetchBackground:
          setState(() => trackLocation = true);

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
              sendcoor();
              TransVar.mylatidute = locations.location.latitude.toString();
              TransVar.mylongitude = location.location.longitude.toString();
            });
          });

          notif.Notification notification = new notif.Notification();
          notification.showNotificationWithoutSound(locations.location.latitude.toString() + ":" + locations.location.latitude.toString());
          break;
      }
      return Future.value(true);
    });
  }

  void _startTimer() {
    _counter = 1;
    if (TransVar.timer != null) {
      TransVar.timer.cancel();
    }
    TransVar.timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        if (_counter > 0) {


        } else {
          TransVar.timer.cancel();
        }
      });
    });
  }

 /* getLocations() {

      setState(() => trackLocation = true);

      streamSubscription = Geolocation
          .locationUpdates(
        accuracy: LocationAccuracy.best,
        displacementFilter: 0.0,
        inBackground: true,
      )
          .listen((result) {
        final location = result;
        Timer(Duration(seconds: 5), () {
          print("Yeah, this line is printed after 3 seconds");
          locations = location;
          sendcoor();
        });

      });




  }*/


  stoplocation(){

      setState(() => trackLocation = false);
      streamSubscription.cancel();
      streamSubscription = null;
      locations = null;

  }

  Future sendcoor() async{
    print(TransVar.token);
    print("longitude" + locations.location.latitude.toString() + "latitude"+ locations.location.longitude.toString() + "driver_id" + TransVar.driverid);
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + TransVar.token};
    var body = jsonEncode({"longitude": locations.location.latitude, "latitude": locations.location.longitude, "driver_id": TransVar.driverid});
    String url = "https://admin.byaherongpinoy.com/api/v1/truck/location/set-current/";
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200)
    {
      print(response.body.toString());
    }else{
      print('Failed to get data');
      print(response.body.toString());
    }
  }

  checkGps() async {
    final GeolocationResult result = await Geolocation.isLocationOperational();
    if (result.isSuccessful) {
      try {
        //getLocations();
      } on Exception catch (_) {
        print("throwing new error");
      }
    }
  }




  showAlertDialog(BuildContext context,int stat, String transid, String pickadd, String pickcon, String piclat,
      String piclong, String delname, String deladd, String dellat, String dellong,String delcon, String desc, String slugs, String shipstat, String shipline, String shiptype,
      String conwei, String container, String retname, String retlat, String retlong) {



    print(transid);
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget saveButton = FlatButton(
      child: Text("View"),
      onPressed:  () {
        //sendcoor(transid);
        //dispatchme(transid);

        Navigator.pop(context);
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => viewinf(TransVar.token,stat,
    transid,
    pickadd,
    pickcon,
    piclat,
    piclong,
    delname,
    deladd,
    dellat,
    dellong,
    delcon,
            TransVar.mylatidute,
            TransVar.mylongitude,
    desc,
    slugs,
    shipstat,
    shipline,
    shiptype,
    conwei,
    container,
    retname,retlat,retlong
    ),

    ),
    );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Task Details"),
      content: Text("Would you like to view task details?"),
      actions: [
        cancelButton,
        saveButton,
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



  Future<List<User>> getUsers() async{
    print("loading data today task");
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + TransVar.token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/assigned/today/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<User> users = [];

    print("today task");
    print(jsondata);

    undonetask = 0;
    todaytask = 0;

    for (var u in jsondata){
      String tranid,title,slug,desc,price,email,
          picname, picadd,piclat,piclong,picnum,
          delname, deladd,dellat,dellong,delnum,pickdate,
          shipstat,shipline,shiptype,containerweight,container,ctype, retname, retlat, retlong;
      int pickstat;

      if(u['container_yard']['name'] == null)
      {
        retname = "none";
      }else{
        retname = u['container_yard']['name'];
      }

      if(u['container_yard']['latitude'] == null)
      {
        retlat = "none";
      }else{
        retlat = u['container_yard']['latitude'];
      }

      if(u['container_yard']['longitude'] == null)
      {
        retlong = "none";
      }else{
        retlong = u['container_yard']['longitude'];
      }//return

      if(u['container'] == null)
      {
        container = "none";
      }else{
        container = u['container'];
      }

      if(u['container_weight'] == null)
      {
        containerweight = "none";
      }else{
        containerweight = u['container_weight'];
      }

      if(u['shipment_type'] == null)
      {
        shiptype = "none";
      }else{
        shiptype = u['shipment_type'];
      }

      if(u['shipping_line'] == null)
      {
        shipline = "none";
      }else{
        shipline = u['shipping_line'];
      }

      if(u['shipment_status'] == null)
      {
      shipstat = "none";
      }else{
      shipstat = u['shipment_status'];
      }

      if(u['pickup']['pickup_date'] == null)
      {
        pickdate = "none";
      }else{
        pickdate = u['pickup']['pickup_date'];
      }

      if(u['status'].toString() == null)
      {
        pickstat = 0;
      }else{
        pickstat = int.parse(u['status']);
      }


      if(u['title'] == null)
      {
        title = "none";
      }else{
        title = u['title'];
      }


      if(u['slug'] == null)
      {
        slug = "none";
      }else{
        slug = u['slug'];
      }

      if(u['description'] == null)
      {
        desc = "none";
      }else{
        desc = u['description'];
      }

      if(u['price'] == null)
      {
        price = "none";
      }else{
        price = u['price'];
      }

      if(u['email'] == null)
      {
        email = "none";
      }else{
        email = u['email'];
      }



      if(u['pickup']['address'] == null)
      {
        picadd = "none";
      }else{
        picadd = u['pickup']['address'];
      }


      if(u['pickup']['latitude'] == null)
      {
        piclat = "0.0000";
      }else{
        piclat = u['pickup']['latitude'];
      }

      if(u['pickup']['longitude'] == null)
      {
        piclong = "0.0000";
      }else{
        piclong = u['pickup']['longitude'];
      }

      if(u['pickup']['phone_number'] == null)
      {
        picnum = "none";
      }else{
        picnum = u['pickup']['phone_number'];
      }

      //del
      if(u['delivery']['name'] == null)
      {
        delname = "none";
      }else{
        delname = u['delivery']['name'];
      }
      if(u['delivery']['address'] == null)
      {
        deladd = "none";
      }else{
        deladd = u['delivery']['address'];
      }
      if(u['delivery']['latitude'] == null)
      {
        dellat = "0.000";
      }else{
        dellat = u['delivery']['latitude'];
      }
      if(u['delivery']['longitude'] == null)
      {
        dellong = "0.000";
      }else{
        dellong = u['delivery']['longitude'];
      }
      if(u['delivery']['phone_number'] == null)
      {
        delnum = "0.000";
      }else{
        delnum = u['delivery']['phone_number'];
      }



      if(u['confirmation_type'] == null)
      {
        ctype = "none";
      }else{
        ctype = u['confirmation_type'];
      }

      DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      DateTime dtme =  DateFormat("yyyy-MM-dd").parse(u['pickup']['pickup_date']);

      //if(dtnow.isAtSameMomentAs(dtme)){

          tranid = u['transaction_no'];
          if(tranid != null){
            if(int.parse(u['status']) >= 4 && int.parse(u['status']) <= 9){
              User user = User(tranid,title,slug,desc,price,email,
                  picadd, piclat, piclong, picnum,
                  delname,deladd,dellat,dellong,delnum,pickdate,pickstat,shipstat,shipline,shiptype,containerweight,container,ctype, retname,retlat,retlong);
              users.add(user);
            }
          }
      //}

    if(int.parse(u['status']) >= 4){
      TransVar.duty = "on";
    }

      if(dtnow.isAtSameMomentAs(dtme)){
       setState(() {
         todaytask = todaytask + 1;
       });
      }else{
      setState(() {
        undonetask = undonetask + 1;
      });
      }

    }

    if(users.length > 0){
      TransVar.floatvisi = true;
    }else{
      TransVar.floatvisi = false;
    }


    dtme = users.length;
    return users;


  }
  mybtnon(int st){
    if(st == 4){
     //Dispatch
    }
    if(st == 5){
     //Pickup
    }
    if(st == 6){
     //to delivery
    }
    if(st == 7){
      //Delivered
    }
    if(st == 8){
      //To Return
    }
    if(st == 9){
     //Complete
    }else{
      //none
    }
  }

  transme(String transid,int me, String ctype){

    if(me == 4){
        dispatch(transid);
    }
    if(me == 5){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => intrans(TransVar.token,me,transid,ctype),

        )
      );
    }
    if(me == 6){
      transit(transid);
    }
    if(me == 7){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => intrans(TransVar.token,me,transid,ctype),

        ),
      );
    }
    if(me == 8){
      retruning(transid);
    }
    if(me == 9){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => intrans(TransVar.token,me,transid,ctype),

        ),
      );
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
  void dispatch(String transid) async {
    print("Your transaction ID:"+ transid);
    showProgressDialog(context);
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + TransVar.token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'dispatch'};
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200){
      //Toast.show(message:"You are now dispatch",duration: Delay.SHORT);
      setState(() {
        getUsers();
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
      });
      print(response.body);
    }else{
      //Toast.show(message:"Something went wrong! Please try again later.",duration: Delay.SHORT);
      print("Something weong in dispatch "+ response.body.toString());
    }
    Navigator.pop(context);
  }
  void transit(String transid) async {
    showProgressDialog(context);
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + TransVar.token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'transit'};
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200){
      //Toast.show(message:"You are now on way to delivery",duration: Delay.SHORT);
      setState(() {
        getUsers();
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
      });
      print(response.body);
    }else{
      //Toast.show(message:"Something went wrong! Please try again later.",duration: Delay.SHORT);
      print(response.body);
    }
    Navigator.pop(context);
  }
  void retruning(String transid) async {
    showProgressDialog(context);
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + TransVar.token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": transid, "action": 'return'};
    final response = await http.post(url,headers: headers,body: body);

    if(response.statusCode == 200){
      //Toast.show(message:"You are now returning to yard",duration: Delay.SHORT);
      setState(() {
        getUsers();
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
      });
      print(response.body);
    }else{
      //Toast.show(message:"Something went wrong! Please try again later.",duration: Delay.SHORT);
      print(response.body);
    }
    Navigator.pop(context);
  }

  mydtst(String dtme){
    DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    DateTime dtm =  DateFormat("yyyy-MM-dd").parse(dtme);

    if(dtnow.isAtSameMomentAs(dtm)){
      return Text("Today", style: TextStyle(fontSize: 12, color: Colors.green),);
    }else{
      final difference = dtnow.difference(dtm).inDays;
      if(difference >= 0){
        if(difference == 1){
          return Text("Yesterday", style: TextStyle(fontSize: 12),);
        }else{
          if(difference <= 6){
            return Text(difference.toString() + " days ago", style: TextStyle(fontSize: 12),);
          }
          else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text(dtme, style: TextStyle(fontSize: 12),),
              Text("warning, task is week ago", style: TextStyle(fontSize: 10, color: Colors.red),),
              ],
            );
          }
        }
      }else{
        return Text(dtme, style: TextStyle(fontSize: 12),);
      }

    }

  }

  mystat(int st){
    if(st == 4){
      bt = "Dispatch";
      return Text("", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }
    if(st == 5){
      bt = "Pickup";
      return Text("Dispatch", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }
    if(st == 6){
      bt = "In Intransit";
      return Text("Picked Up", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }
    if(st == 7){
      bt = "Delivered";
      return Text("To Delivery", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }
    if(st == 8){
      bt = "To Origin";
      return Text("Delivered", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }
    if(st == 9){
      bt = "Complete";
      return Text("To Return", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }else{
      bt = "Dispatch";
      return Text("", style: TextStyle(color: Colors.amber[800],fontSize: 14,fontWeight: FontWeight.bold),);
    }

  }
  mydata(){

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(

              padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0,40,0,0),
                      height: 50,),
                    Text("Please wait", style: TextStyle(fontSize: 14, color: Colors.black45),),
                    //Text("No task found", style: TextStyle(fontSize: 20, color: Colors.black45, fontStyle: FontStyle.italic),),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0,40,0,0),
                      height: 20,),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(

              //scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Color.fromRGBO(240, 233, 251, 1),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,

                      secondaryActions: <Widget>[

                        IconSlideAction(
                          caption: 'View',
                          color: Colors.amber[800],
                          icon: Icons.developer_mode,
                          onTap: (){


                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => viewinf(TransVar.token,snapshot.data[index].pickstat,
                                  snapshot.data[index].index,
                                  snapshot.data[index].pickadd,
                                  snapshot.data[index].contact,
                                  snapshot.data[index].latitude,
                                  snapshot.data[index].longitude,
                                  snapshot.data[index].delname,
                                  snapshot.data[index].deladd,
                                  snapshot.data[index].dellat,
                                  snapshot.data[index].dellong,
                                  snapshot.data[index].delnum,

                                TransVar.mylatidute,
                                TransVar.mylongitude,

                                snapshot.data[index].desc,
                                snapshot.data[index].slugs,
                                  snapshot.data[index].shipstat,
                                  snapshot.data[index].shipline,
                                  snapshot.data[index].shiptype,
                                  snapshot.data[index].containerweight,
                                  snapshot.data[index].container,

                                //return details
                                snapshot.data[index].retname,
                                snapshot.data[index].retlat,
                                snapshot.data[index].retlong,

                              ),

                              ),
                            );
                          }
                        ),
                      ],
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(

                              width: 400,
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),

                              child: GestureDetector(

                                onTap: () {
                                  transid = snapshot.data[index].index.toString();
                                  print(transid);
                                  //MaterialPageRoute(builder: (context) => TransAccept(token,snapshot.data[index].index.toString(),
                                  // snapshot.data[index].pickadd,snapshot.data[index].contact,snapshot.data[index].latitude,snapshot.data[index].longitude,
                                  //snapshot.data[index].deladd,snapshot.data[index].dellat,snapshot.data[index].dellong)
                                  //_getCurrentLocation();
                                  showAlertDialog(
                                    context,snapshot.data[index].pickstat,
                                    snapshot.data[index].index,
                                    snapshot.data[index].pickadd,
                                    snapshot.data[index].contact,
                                    snapshot.data[index].latitude,
                                    snapshot.data[index].longitude,
                                    snapshot.data[index].delname,
                                    snapshot.data[index].deladd,
                                    snapshot.data[index].dellat,
                                    snapshot.data[index].dellong,
                                    snapshot.data[index].delnum,
                                    snapshot.data[index].desc,
                                    snapshot.data[index].slugs,
                                    snapshot.data[index].shipstat,
                                    snapshot.data[index].shipline,
                                    snapshot.data[index].shiptype,
                                    snapshot.data[index].containerweight,
                                    snapshot.data[index].container,
                                    snapshot.data[index].retname,
                                    snapshot.data[index].retlat,
                                    snapshot.data[index].retlong,
                                  );
                                },
                                child: ListTile(

                                    title: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                2, 2, 2, 5),// + " | " + snapshot.data[index].index
                                            child: Text(snapshot.data[index].title,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Container(


                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            padding: const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),

                                          ),

                                          Container(height: 5,),



                                          Row(
                                            children: <Widget>[
                                              Text("Pickup: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                    snapshot.data[index].pickadd, style: TextStyle(fontSize: 12),),
                                              ),
                                            ],
                                          ),


                                          Container(height: 5,),
                                          Row(
                                            children: <Widget>[
                                              Text("Delivery: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                    snapshot.data[index].deladd, style: TextStyle(fontSize: 12),),
                                              ),
                                            ],
                                          ),
                                          Container(height: 2,),

                                          Container(
                                            width: 100,
                                            padding: const EdgeInsets.fromLTRB(
                                                2, 2, 2, 10),

                                          ),
                                          Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: mydtst(snapshot.data[index].pickdate)

                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                    )


                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Color.fromRGBO(240, 233, 251, 1),
                              padding: EdgeInsets.fromLTRB(0, 9, 0, 9),

                              child: Column(
                                children: <Widget>[
                                  mystat(snapshot.data[index].pickstat),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: ButtonTheme(

                                      height: 50.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            side: BorderSide(color: Colors.indigo)),
                                        onPressed: (){

                                         transme(snapshot.data[index].index,snapshot.data[index].pickstat,snapshot.data[index].ctype);
                                        },
                                        color: Colors.indigo,
                                        child: Text(bt,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                );
              },
            );
          }
        },
      ),
    );

  }

  void floatv(){
    setState(() {
      TransVar.floatvisi = false;
    });
  }

  mynumtask(){
    if(todaytask == 0){
      return Column(
        children: <Widget>[
          Text(undonetask.toString(),style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
          Text("Undone",style: TextStyle(color: Colors.white, fontSize: 9),),
          Text("Task",style: TextStyle(color: Colors.white, fontSize: 9),),
        ],
      );
    }
    if(undonetask == 0){
      return Column(
        children: <Widget>[
          Text(todaytask.toString(),style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
          Text("Today",style: TextStyle(color: Colors.white, fontSize: 9),),
          Text("Task",style: TextStyle(color: Colors.white, fontSize: 9),),

        ],
      );
    }
    if(undonetask != 0 && todaytask != 0){
      return Column(
        children: <Widget>[
          Text(todaytask.toString(),style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
          Text("Today",style: TextStyle(color: Colors.white, fontSize: 6),),
          Text(undonetask.toString(),style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
          Text("Undone",style: TextStyle(color: Colors.white, fontSize: 6),),

        ],
      );
    }
    if(undonetask == 0 && todaytask == 0){
      setState(() {
        TransVar.floatvisi = false;
      });
    }else{
      setState(() {
        TransVar.floatvisi = false;
      });
    }

  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: mydata(),
      floatingActionButton: new Visibility(
        visible: TransVar.floatvisi,
        child: DraggableFab(
          child: GestureDetector(
            onTap: (){
              floatv();
            },
            child: Container(
              width: 70,
              height: 70,
              child: Column(
                children: <Widget>[
                  Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.asset('images/floatbar.gif'),
                        mynumtask(),
                      ]
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}

class User {
  final String index;
  final String title;
  final String slugs;
  final String desc;
  final String address;
  final String creatdt;
  final String contact;


  //pickup
  final int pickstat;
  final String pickadd;
  final String latitude;
  final String longitude;
  final String pickdate;

  //delivery
  final String delname;
  final String deladd;
  final String dellat;
  final String dellong;
  final String delnum;

  final String retname;
  final String retlat;
  final String retlong;

  String shipstat,shipline,shiptype,containerweight,container,ctype;

  User(this.index, this.title, this.slugs, this.desc, this.address, this.creatdt,
      this.pickadd,this.latitude,this.longitude,this.contact,
      this.delname,this.deladd,this.dellat,this.dellong,this.delnum,this.pickdate,this.pickstat,
  this.shipstat,this.shipline,this.shiptype,this.containerweight,this.container,this.ctype, this.retname, this.retlat, this.retlong);
}

