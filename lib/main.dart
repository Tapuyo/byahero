import 'dart:io';
import 'dart:async';
import 'package:byaherov1/MyClass/myVar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byaherov1/Transact/TransactionStart.dart';
import 'package:byaherov1/Profile/ProfUser.dart';
import 'package:byaherov1/NavMenu/NewSched.dart';
import 'package:byaherov1/NavMenu/ScheduleTask.dart';
import 'package:byaherov1/NavMenu/HistoryTask.dart';
import 'package:byaherov1/NavMenu/Account.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:byaherov1/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:byaherov1/NavMenu/Setme.dart';
import 'package:byaherov1/homepage/home.dart';
import 'package:geolocation/geolocation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Byahero',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Byahero Driver'),
        debugShowCheckedModeBanner: false
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);





  final String title;

  @override
  sppage createState() => sppage();

}
_save(String token) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('value_key', token);
}

_read()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('value_key');
}


class sppage extends State {
  int _counter = 0;
  void initState() {
    super.initState();
    //Timer(Duration(seconds: 3), () => {LoginUserState()});
    _startTimer();
  }

  void _startTimer() {
    _counter = 1;
    TransVar.timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        if (_counter > 5) {

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogScreeen())

          );
        } else {
          TransVar.timer.cancel();
          TransVar.timer.cancel();
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogScreeen())

          );
        }
      });
    });
  }
  clickme(){
    TransVar.timer.cancel();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogScreeen())

    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(

                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: (){
                      clickme();
                    },
                    child: Container(
                      //color: Colors.red,

                      child: Image.asset('images/byaheronoback.png', fit: BoxFit.fill, ),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 2,
                  child: LinearProgressIndicator(
                    //backgroundColor: kColorBlue,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Powered by: ", style: TextStyle(color: Colors.grey),),
                        Text("Qoreit Inc", style: TextStyle(color: Colors.indigo),),
                      ],
                    )
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
class LogScreeen extends StatefulWidget {

  LoginUserState createState() => LoginUserState();
}

class LoginUserState extends State {
  bool lognow = false;
  bool _passhow = true;
  List data = [];
  // For CircularProgressIndicator.
  bool visible = false ;
  String player_id = "none";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;
  void initState() {
    TransVar.token = "";
    //changeprof();
    _query();

    configOneSignal();

    super.initState();

  }



  Future changeprof() async{
      String toks = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODYxNjdiMTQ3NWViNWViOTZhOTRlZjg0NGY2ODEzZDM4YmQ0YzQ4OTk2Yzk4OThlNmJiYjg0OWEyYzZkNDAzYzVjNjkwNzczZTA2ZDJiMTEiLCJpYXQiOjE1OTQxMzA0MzYsIm5iZiI6MTU5NDEzMDQzNiwiZXhwIjoxNjI1NjY2NDM2LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.g3LhFzv-zELmIJj2lIAXdEahrwP1Ns8mMI9ttuTwf3jugzG9UV3CXRYEQU7X_Nn9oVeLLcJpet2WQetkwN42X8uHqZ7hMd1DU3S3g167Sz0IRst8wFxiV7lOlDkeICZKvL0fAjA3_1YwqKZ2qz7_8MquRIm9Plm9iYSIjpPONvE-pBUZWzFjkXoE23ThIL3EcCA0MId-LElF5iqyhNz9O711TuSsXYBK5IE7S_cg43pJpJPOJmCb8gxHfxMUbQPvjQN-nFos67LRSvrc6hWPFs6E344lVE4j_zBa8Yb3AB8HzNazgAmmCwj6ihR71lOslWVxC9mOX4BHCkn5rPWJ75j1_2kEUHyn32unTgNDlpqb-zoaCSQBRiaoE09_ytg_7bhrYDCviiXi4W8GJRZpojwdpBj7najafU28puOCbjDMiCOaheB1ve36uyeVBJ6iOC4e3EtBOriIxvSvseWMYnfnrIrIOQd8Ptfbf0M5z7xaB4ioaQwGyq4FhMDicl0mBT5Klsw-n53py9_JDo1v_K_IZA7HL764mUcFK9R7YdoPJVNAi6J_VJazO-vSAYkd8u3yp5W0RG59mp1yn9mi-AE-NC8BYhxejP7tIpKdnowtM8Ju2oHF5rLkP2w7yHGgtNXRPq9CyxYcGYMUmUi4opzGVr3AX_lWFoiiMYvm2DU";
      Map<String, String> headers = {
        "Content-type": "application/json",
        'Authorization': 'Bearer ' + toks
      };
      var body = jsonEncode({
        "password": 'john',
        "confirm_password": 'john',
        "first_name": 'John',
        "last_name": 'Taps',
        "driver_license_no": '12345',
        "driver_license_exp_date": '2020/12/20'
      });
      String url = "https://admin.byaherongpinoy.com/api/v1/profile/force-change/";
      final response = await http.post(url, headers: headers, body: body);


      if (response.statusCode == 200) {
        print(response.body.toString());
      } else {
        print(response.body.toString());
      }

  }
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    if(allRows.length == 0){
      print("awallalasldlasdklaskdlaksdlkqwlkalkdlasklkalskdlsakdlaksldkasd");
    }else {
      print(allRows[0]['_id']);
      print(allRows[0]['name']);
      print(allRows[0]['password']);
      print(allRows[0]['onesignal']);
      //print(allRows[0]['auth']);
      print(allRows[0]['email']);
      print(allRows[0]['driver']);
      print(allRows[0]['exp']);

      emailController.text = allRows[0]['name'];
      passwordController.text = allRows[0]['password'];

      checkme(allRows[0]['name'],allRows[0]['password'],allRows[0]['onesignal']);
    }
  }

  void checkme(String user,pass,plr)async{
    setState(() {
      visible = true ;
    });
    var mydata;

    final response = await http.post("https://admin.byaherongpinoy.com/api/v1/login",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"username": user, "password": pass, "player_id": plr});

    mydata = json.decode(response.body);
    print(mydata);

    if (response.statusCode == 200) {
      setState(() {
        visible = false;
        lognow = false;
      });

      TransVar.pass = pass;

      TransVar.driverid = json.decode(response.body)['data']['user_details']['id'].toString();

      if(json.decode(response.body)['data']['assigned_truck_details']['plate_no'] == null){
        TransVar.myplate = "none";
      }else
      {
        TransVar.myplate = json.decode(response.body)['data']['assigned_truck_details']['plate_no'];
      }

      if(json.decode(response.body)['data']['user_details']['first_name'] == null){
        TransVar.username = "none";
      }else
      {
        TransVar.username = json.decode(response.body)['data']['user_details']['first_name'] + " " + json.decode(response.body)['data']['user_details']['last_name'];
        TransVar.fname = json.decode(response.body)['data']['user_details']['first_name'];
        TransVar.lname = json.decode(response.body)['data']['user_details']['last_name'];
      }

      if(json.decode(response.body)['data']['user_details']['mobile'] == null){
        TransVar.contactno = "none";
      }else
      {
        TransVar.contactno = json.decode(response.body)['data']['user_details']['mobile'];
      }

      if(json.decode(response.body)['data']['user_details']['email'] == null){
        TransVar.usermail = "none";
      }else
      {
        TransVar.usermail = json.decode(response.body)['data']['user_details']['email'];
      }

      if(json.decode(response.body)['data']['user_details']['driver_license_no'] == null){
        TransVar.userli = "none";
        TransVar.driveli = "none";
      }else
      {
        TransVar.userli = json.decode(response.body)['data']['user_details']['driver_license_no'];
        TransVar.driveli = json.decode(response.body)['data']['user_details']['driver_license_no'];
      }

      if(json.decode(response.body)['data']['user_details']['driver_license_exp_date'] == null){
        TransVar.expli = "none";
      }else
      {
        TransVar.expli = json.decode(response.body)['data']['user_details']['driver_license_exp_date'];
      }

      passwordController.text = "";

      _save(TransVar.token);

      TransVar.plrid = player_id.toString();

      TransVar.token = json.decode(response.body)['data']['oauth'];

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskScreen())

        );



    }
    else{

      // If Email or Password did not Matched
      // Hiding the CircularProgressIndicator.
      setState(() {

        visible = false;
      });

      showqr(context, "You need to relog in.");

      // Showing Alert Dialog with Response JSON Message.
    }
    lognow = true;

  }

  void _insert(String name,pass,one,aut,email,drive,exp) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : name,
      DatabaseHelper.columnPass  : pass,
      DatabaseHelper.columnOne  : one,
      DatabaseHelper.columnAuth  : aut,
      DatabaseHelper.columnEmail  : email,
      DatabaseHelper.columnDrive  : drive,
      DatabaseHelper.columnExp  : exp,
    };
    final id = await dbHelper.insert(row);

    print('inserted row id: $id');

  }



  // Getting value from TextField widget.



  showqr(BuildContext context, String qrcode) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
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


  errorshow(BuildContext context, String qrcode) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Byahero"),
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


  Future userLogin() async{

    // Showing CircularProgressIndicator.


    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    if(email == "" && password != ""){
      errorshow(context,"Please fill up username.");
    }
    if(password == "" && email != ""){
      errorshow(context,"Please fill up password.");
    }
    if(email == "" && password == "" ){
      errorshow(context,"Please fill up username and password.");
    }
    if(email != "" && password != ""){

      print(player_id);
      setState(() {
        visible = true ;
      });

    var mydata;
    // Starting Web API Call.
    final response = await http.post("https://admin.byaherongpinoy.com/api/v1/login",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"username": email, "password": password, "player_id": player_id});

    // Getting Server response into variable.

    mydata = json.decode(response.body);
    print(mydata);





    // If the Response Message is Matched.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
      print('access token is -> ${json.decode(response.body)['data']['oauth']}');

      TransVar.driverid = json.decode(response.body)['data']['user_details']['id'].toString();

      TransVar.pass = password;


      if(json.decode(response.body)['data']['user_details']['name'] == null){
        TransVar.username = "none";
      }else
      {
        TransVar.username = json.decode(response.body)['data']['user_details']['first_name'] + " " + json.decode(response.body)['data']['user_details']['last_name'];
        TransVar.fname = json.decode(response.body)['data']['user_details']['first_name'];
        TransVar.lname = json.decode(response.body)['data']['user_details']['last_name'];
      }

      try{
        TransVar.myplate = json.decode(response.body)['data']['assigned_truck_details']['plate_no'].toString();
      }catch(e){

        TransVar.myplate = "none";
      }



      if(json.decode(response.body)['data']['user_details']['mobile'] == null){
        TransVar.contactno = "none";
      }else
      {
        TransVar.contactno = json.decode(response.body)['data']['user_details']['mobile'];
      }

      if(json.decode(response.body)['data']['user_details']['email'] == null){
        TransVar.usermail = "none";
      }else
      {
        TransVar.usermail = json.decode(response.body)['data']['user_details']['email'];
      }

      if(json.decode(response.body)['data']['user_details']['driver_license_no'] == null){
        TransVar.userli = "none";
        TransVar.driveli = "none";
      }else
      {
        TransVar.driveli = json.decode(response.body)['data']['user_details']['driver_license_no'];
        TransVar.userli = json.decode(response.body)['data']['user_details']['driver_license_no'];
      }

      if(json.decode(response.body)['data']['user_details']['driver_license_exp_date'] == null){
        TransVar.expli = "none";
      }else
      {
        TransVar.expli = json.decode(response.body)['data']['user_details']['driver_license_exp_date'];
      }



      _save(TransVar.token);

      TransVar.plrid = player_id.toString();

      TransVar.token = json.decode(response.body)['data']['oauth'];
      if(json.decode(response.body)['data']['user_details']['name'] == null)
      {
        _insert(email,password,TransVar.plrid,TransVar.token,TransVar.usermail,TransVar.userli,TransVar.expli);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskScreen())
        );
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfUser(TransVar.token))

        );
      }else{
        _insert(email,password,TransVar.plrid,TransVar.token,TransVar.usermail,TransVar.userli,TransVar.expli);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskScreen())

        );
      }

      passwordController.text = "";
    }
    else{

      // If Email or Password did not Matched
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      showqr(context, json.decode(response.body)['message'].toString());

      // Showing Alert Dialog with Response JSON Message.
   }
    }

  }
  void _toggle() {
    setState(() {
      _passhow = !_passhow;
    });
  }

  String notif;

  void configOneSignal()async{
    print("One signal init");
    await OneSignal.shared.init('354447a9-cde5-4abc-8af2-bb1d2df41a64');

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    player_id = playerId.toString();

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      setState(() {
        notif = notification.jsonRepresentation().replaceAll('\\n', '\n');
        player_id = playerId.toString();
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  height: 800,
                  decoration: BoxDecoration(

                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white]),



                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[


                        Center(
                          child:   Container(
                            padding: const EdgeInsets.fromLTRB(10, 130, 10, 20),
                            child: Container(

                              width: 300,
                              height: 100,
                              child: Image.asset('images/loginbyahero.png', fit: BoxFit.fill,),
                            ),
                          ),
                        ),


                        Divider(),

                        Container(

                            width: 300,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                            child: TextField(
                              controller: emailController,
                              autocorrect: true,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.indigo)
                                ),
                                hintText: 'Enter Your Username Here',

                                prefixIcon: const Icon(Icons.person, color: Colors.indigo,),
                              ),
                            )
                        ),

                        Container(

                            width: 300,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextField(

                              controller: passwordController,
                              autocorrect: true,
                              obscureText: _passhow,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.indigo)
                                ),
                                hintText: 'Enter Your Password Here',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.indigo,),
                                  suffixIcon: Container(
                                    width: 20,
                                    child: FlatButton(
                                      onPressed: _toggle,
                                      child: new Icon(Icons.remove_red_eye,  color: _passhow ?  Colors.grey: Colors.black54,size: 20,),),
                                  )
                              ),
                            )
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: _toggle,
                                  child: new Text("Forgot password ? ", style: TextStyle(color: Colors.indigo,fontSize: 12.0, fontWeight: FontWeight.bold),))
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
                             // if(lognow == true){
                                userLogin();
                             // }
                            },


                            color: Colors.indigo,
                            textColor: Colors.blueGrey,

                            padding: EdgeInsets.fromLTRB(10, 9, 10, 9),
                            child: Text('Login',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                )
                            ),
                          ),
                        ),






                        Visibility(
                            visible: visible,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: CircularProgressIndicator()
                            )
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Powered by: ", style: TextStyle(color: Colors.grey),),
                                Text("Qoreit Inc", style: TextStyle(color: Colors.indigo),),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  )))),
    );
  }
}



class TaskScreen extends StatefulWidget {

  MyPage createState() => MyPage();
}

class MyPage extends State {
  int _currentIndex = 0;
  bool dts = false;

  String hapitnaexpired = "no";
  //Position _currentPosition;
  String mlat,mlong;
  String transid;
  List data = [];
  int counttrans = 0 ;
  String notif;
  dynamic _scrollController;

  bool isSwitched = false;

  LocationResult locations = null;

  bool trackLocation = false;


  final dbHelper = DatabaseHelper.instance;

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    Navigator.pop(context);
    Navigator.pop(context);
    //_query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    if(allRows.length == 0){
      print("awallalasldlasdklaskdlaksdlkqwlkalkdlasklkalskdlsakdlaksldkasd");
      Navigator.pop(context);
      Navigator.pop(context);
      //exit(0);
    }else {
      print(allRows[0]['_id']);
      print(allRows[0]['name']);
      print(allRows[0]['password']);
      print(allRows[0]['onesignal']);
      print(allRows[0]['auth']);
      print(allRows[0]['email']);
      print(allRows[0]['driver']);
      print(allRows[0]['exp']);

    }
  }


  void ConfigOneSignal()async{
    print("One signal init");
    //await OneSignal.shared.init('354447a9-cde5-4abc-8af2-bb1d2df41a64');

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      setState(() {
        notif = notification.jsonRepresentation().replaceAll('\\n', '\n');
      });
    });
  }



  void initState() {
    ConfigOneSignal();

    super.initState();

    getLocations();
    counttrans = data.length;
    checkdrive();
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

  getLocations() {
    Timer(Duration(seconds: 5), () {
    setState(() => trackLocation = true);
    TransVar.streamSubscription = Geolocation
        .locationUpdates(
      accuracy: LocationAccuracy.best,
      displacementFilter: 0.0,
      inBackground: true,
    )
        .listen((result) {
      final location = result;

        print("Sending location every 5 seconds");
        locations = location;
        sendcoor();


    });

    });


  }
  Future sendcoor() async{
    TransVar.mylatidute = locations.location.latitude.toString();
    TransVar.mylongitude = locations.location.longitude.toString();
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

  @override
  void dispose() {
    locations = null;
    TransVar.streamSubscription.cancel();
  }


  checkdrive(){
    try{
      print(TransVar.expli);
      if(TransVar.expli != null && TransVar.expli != ""){
        DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
        DateTime dtme =  DateFormat("yyyy-MM-dd").parse(TransVar.expli);
        final difference = dtme.difference(dtnow).inDays;
        if(difference < 7 && difference > 0){
          _currentIndex = 3;

          print("nearly expire");
        }
        if(difference < 1){
          _currentIndex = 3;

          print("expired");
        }else{
          _currentIndex = 0;
        }

      }
    }on Exception catch (_) {
     _currentIndex = 3;

      print("Driver expireation update");
    }
    //TransVar.expli

  }



// User Logout Function.
  logout(BuildContext context){

    Navigator.pop(context);

  }





  showAlertDialog(BuildContext context, String transid, String pickadd, String pickcon, String piclat,
      String piclong, String delname, String deladd, String dellat, String dellong,String delcon) {
    print(transid);
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Accept"),
      onPressed:  () {

        Navigator.pop(context);

      },
    );
    Widget saveButton = FlatButton(
      child: Text("Dispatch"),
      onPressed:  () {

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionStart(TransVar.token,"4",transid,pickadd,pickcon,piclat,piclong,delname,deladd,dellat,dellong,delcon,mlat,mlong),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Transaction"),
      content: Text("Would you like to continue the task?"),
      actions: [

        continueButton,
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





  int _selectedIndex = 0;



  final tabs = [
    home(TransVar.token),
    NewSched(TransVar.token),
    HistoryTask(TransVar.token),
    Account(TransVar.token,TransVar.username,TransVar.usermail,TransVar.userli,TransVar.expli),
  ];


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(

          title: new Container(

              child: Center(child: new Text("Byahero"))),

          leading: new IconButton(
            icon: Container(width: 50,height: 50,
              child: Image.asset('images/noback.png', fit: BoxFit.fill,),
          ),
            onPressed: () {},
          ),

        ),

        body: Container(
          padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
          child: tabs[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black45,
          iconSize: 30,
          //unselectedFontSize: 14,
          //selectedFontSize: 16,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus),
                title: Text('Home'),
                backgroundColor: Colors.white70
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Schedule'),
              backgroundColor: Colors.white70
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text('History'),
                backgroundColor: Colors.white70
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
                backgroundColor: Colors.white70
            ),


          ],
         onTap: (index){
            setState(() {
              _currentIndex = index;
            });
         },
          selectedItemColor: Colors.amber[800],

        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child:Column(
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      width: 60.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('images/byaherologo.png', fit: BoxFit.fill,),
                      ),
                    ),
                    Container(

                      child: Text("", style: TextStyle(color: Colors.white, fontSize: 22.0),),
                    ),
                    Container(

                      child: Text(TransVar.username , style: TextStyle(color: Colors.white70, fontSize: 16.0),),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.indigo, Colors.blue]),
                ),
              ),

              ListTile(
                title: Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 5, 2, 2),

                    height: 90,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone_android, color: Colors.indigo,),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                        ),
                        Row(
                          children: <Widget>[
                            Text('Setting'),

                          ],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setme(TransVar.token),
                    ),
                  );
                },
              ),
              ListTile(
                title: Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 5, 2, 2),

                    height: 90,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.indigo,),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                        ),
                        Row(
                          children: <Widget>[
                            Text('Contact Us'),

                          ],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 5, 2, 2),

                    height: 90,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.help, color: Colors.indigo,),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                        ),
                        Row(
                          children: <Widget>[
                            Text('Help'),

                          ],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Card(
                  child: GestureDetector(
                    onTap: (){
                      _delete();
                      //exit(0);
                    },

                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30, 5, 2, 2),

                      height: 90,
                       child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.lock_open, color: Colors.indigo,),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),

                          ),
                          Row(
                            children: <Widget>[
                              Text('Log Out'),

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  _delete();
                },
              ),
            ],
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
  //final String picname;
  final String pickadd;
  final String latitude;
  final String longitude;
  //final String pickdate;

  //delivery
  final String delname;
  final String deladd;
  final String dellat;
  final String dellong;
  final String delnum;

  User(this.index, this.title, this.slugs, this.desc, this.address, this.creatdt,
      this.pickadd,this.latitude,this.longitude,this.contact,
      this.delname,this.deladd,this.dellat,this.dellong,this.delnum);
}

