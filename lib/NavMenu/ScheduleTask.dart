import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:byaherov1/Transact/TransactionStart.dart';
import 'package:geolocator/geolocator.dart';



class ScheduleTask extends StatefulWidget {
  String something;
  ScheduleTask(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ScheduleTask> {
  String something;
  MyPage(this.something);
  var now = new DateTime.now();
  String _selectedDate;
  String mlat,mlong;
  Position _currentPosition;



  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        mlat = position.latitude.toString();
        mlong = position.longitude.toString();

        //sendcoor();
      });
    }).catchError((e) {
      print(e);
    });

    //sendcoor();
  }

  Future sendcoor(String transid) async{

    print(transid + " coordinates: " + mlat + "," + mlong);

    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + something};
    var body = jsonEncode({"longitude": mlat, "latitude": mlong, "ad_id": transid});
    String url = "https://admin.byaherongpinoy.com/api/v1/shipment/location/set-current/";
    final response = await http.post(url,headers: headers,body: body);


    if(response.statusCode == 200)
    {
      print(response.body.toString());
    }else{
      print('Failed to get data');
    }

  }




  Future<List<User>> getUsers() async{
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + something};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/assigned/all/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<User> users = [];
    print(jsondata);

    for (var u in jsondata){
      String tranid,title,slug,desc,price,email,
          picname, picadd,piclat,piclong,picnum,
          delname, deladd,dellat,dellong,delnum;

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

      if(u['pickup']['name'] == null)
      {
        picname = "none";
      }else{
        picname = u['pickup']['name'];
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

        tranid = u['transaction_no'];
      if(u['pickup']['pickup_date'] == _selectedDate){
        if(tranid != null){
          if(u['status'] >= 4 && u['status'] <= 10){
            User user = User(tranid,title,slug,desc,price,email,u['status'].toString(),
                picadd, piclat, piclong, picnum,
                delname,deladd,dellat,dellong,delnum);
            users.add(user);
          }
        }
      }
      else{
        if(tranid != null){
          if(u['status'] >= 4 && u['status'] <= 10){
            User user = User(tranid,title,slug,desc,price,email,u['status'].toString(),
                picadd, piclat, piclong, picnum,
                delname,deladd,dellat,dellong,delnum);
            users.add(user);
          }
        }
      }



    }



    print(users.length);
    return users;


  }
  void initState() {
    _selectedDate = DateFormat('MM/dd/yyyy').format(now).toString();
    super.initState();
    _getCurrentLocation();
    getUsers();

  }
  updateme(String myid) async{
    Map<String, String> headers = {"Accept": "application/json",'Authorization': 'Bearer ' + something};
    String url = "http://admin.byaherongpinoy.com/api/v1/driver/transaction/update/";
    Map<String, String> body = {"transaction_id": myid, "action": 'dispatch'};
    final response = await http.post(url,headers: headers,body: body);
  }

  mydata(){
    return Container(
      child: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null){
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.fromLTRB(2,10,2,2),

                      child: GestureDetector(

                        onTap: () {
                          Navigator.pop(context);
                          //updateme(snapshot.data[index].index);
                          sendcoor(snapshot.data[index].index);
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TransactionStart(something,snapshot.data[index].stat,snapshot.data[index].index
                              ,snapshot.data[index].pickadd,snapshot.data[index].contact,snapshot.data[index].latitude,snapshot.data[index].longitude,
                              snapshot.data[index].delname,snapshot.data[index].deladd,snapshot.data[index].dellat,
                              snapshot.data[index].dellong,snapshot.data[index].delnum,mlat,mlong)
                          ),
                          );

                        },
                        child: ListTile(

                            title: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2,2,2,5),
                                  child: Text(snapshot.data[index].title,style: TextStyle(color: Colors.black),),
                                ),
                              ],
                            ),
                            subtitle: Container(


                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.fromLTRB(2,2,2,2),

                                  ),


                                  Row(
                                    children: <Widget>[
                                      Text("Container Info: "),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(snapshot.data[index].slugs),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Description: "),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(snapshot.data[index].desc),
                                      ),

                                    ],
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Text("Pickup Address: "),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(snapshot.data[index].pickadd),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Delivery Address: "),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(snapshot.data[index].deladd),
                                      ),

                                    ],
                                  ),
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.fromLTRB(2,2,2,10),

                                  ),


                                ],
                              ),
                            )


                        ),
                      ),
                    )
                );
              },
            );
          }

        },
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {

        _selectedDate = DateFormat('MM/dd/yyyy').format(args.value).toString();
      }
      print(_selectedDate.toString());
      getUsers();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Schedule"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {
            setState(() {
              getUsers();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            });
          }),


        ],
      ),
      body: SlidingUpPanel(
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
                    padding: const EdgeInsets.fromLTRB(10,5,5,5),
                    child: Text('Selected date: ' + _selectedDate),
                  )
                ],
              ),
            ),
            Positioned(
                left: 0,
                top: 50,
                right: 0,
                bottom: 100,
                child: Container(
                  child:  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                )
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(5,20,5,5),
            child: mydata()
        ),


      )
    );

  }
 /* _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    appointments.add(Appointment(
        startTime: DateTime(2020, 06, 18),
        endTime: DateTime(2020, 06, 18),
        subject: 'Meeting',
        color: Colors.blue,
        ));

    return _AppointmentDataSource(appointments);
  }*/

}
/*class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}*/

class User {
  final String index;
  final String title;
  final String slugs;
  final String desc;
  final String address;
  final String creatdt;
  final String contact;
  final String stat;

  //pickup
  //final String picname;
  final String pickadd;
  final String latitude;
  final String longitude;


  //delivery
  final String delname;
  final String deladd;
  final String dellat;
  final String dellong;
  final String delnum;

  User(this.index, this.title, this.slugs, this.desc, this.address, this.creatdt,this.stat,
      this.pickadd,this.latitude,this.longitude,this.contact,
      this.delname,this.deladd,this.dellat,this.dellong,this.delnum);
}
