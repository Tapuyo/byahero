import 'package:byaherov1/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:byaherov1/MyClass/myVar.dart';

class upcoming extends StatefulWidget {
  String something;
  upcoming(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<upcoming> {
  String something;
  MyPage(this.something);

  dynamic _scrollController;
  String transid;
  int dtme = 0;

  showAlertDialog(BuildContext context, String transid, String pickadd, String pickcon, String piclat,
      String piclong, String delname, String deladd, String dellat, String dellong,String delcon) {
    print(transid);
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Accept"),
      onPressed:  () {
        //acceptme(transid);
        Navigator.pop(context);
        //var mdt = transid;

      },
    );
    Widget saveButton = FlatButton(
      child: Text("Dispatch"),
      onPressed:  () {
        //sendcoor(transid);
        //dispatchme(transid);

        //Navigator.pop(context);

        //Navigator.push(
        //  context,
        //  MaterialPageRoute(builder: (context) => TransactionStart(token,"4",transid,pickadd,pickcon,piclat,piclong,delname,deladd,dellat,dellong,delcon,mlat,mlong),

        //  ),
        //);
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



  Future<List<User>> getUsers() async{

    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + TransVar.token};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/assigned/upcoming/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<User> users = [];
    print(jsondata);

    for (var u in jsondata){
      String tranid,title,slug,desc,price,email,
          picname, picadd,piclat,piclong,picnum,
          delname, deladd,dellat,dellong,delnum,pickdate;


      if(u['pickup']['pickup_date'] == null)
      {
        pickdate = "none";
      }else{
        pickdate = u['pickup']['pickup_date'];
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

      if(u['pickup']['pickup_date'] == null)
      {
        email = "none";
      }else{
        email = u['pickup']['pickup_date'];
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


      //DateTime dtnow =  DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      //DateTime dtme =  DateFormat("yyyy-MM-dd").parse(u['pickup']['pickup_date']);

      if(u['transaction_no'] == null)
      {
        tranid = "0";
      }else{
        tranid = u['transaction_no'];
      }

      //if(dtnow.isBefore(dtme)){
      //tranid = u['transaction_no'];
      //if(tranid != null){
        //if(u['status'] >= 4 && u['status'] <= 9){
          User user = User(tranid,title,slug,desc,price,email,
              picadd, piclat, piclong, picnum,
              delname,deladd,dellat,dellong,delnum,pickdate);
          users.add(user);
        //}
      //}
      //}



    }

    dtme = users.length;
    print(dtme);
    return users;


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
              controller: _scrollController,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(

                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              //color: Color.fromRGBO(240, 233, 251, 1),
                              padding: EdgeInsets.fromLTRB(0, 9, 0, 9),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].pickdate, style: TextStyle(color: Colors.black87,fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            )
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Color.fromRGBO(240, 233, 251, 1),
                            width: 400,
                            padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),

                            child: GestureDetector(

                              onTap: () {
                               // transid = snapshot.data[index].index.toString();
                               // print(transid);
                                //MaterialPageRoute(builder: (context) => TransAccept(token,snapshot.data[index].index.toString(),
                                // snapshot.data[index].pickadd,snapshot.data[index].contact,snapshot.data[index].latitude,snapshot.data[index].longitude,
                                //snapshot.data[index].deladd,snapshot.data[index].dellat,snapshot.data[index].dellong)
                                //_getCurrentLocation();
                                //showAlertDialog(
                                //    context,
                                //    snapshot.data[index].index.toString(),
                                //    snapshot.data[index].pickadd,
                                //    snapshot.data[index].contact,
                                //    snapshot.data[index].latitude,
                                //    snapshot.data[index].longitude,
                                //    snapshot.data[index].delname,
                                //    snapshot.data[index].deladd,
                                //    snapshot.data[index].dellat,
                                //    snapshot.data[index].dellong,
                                //    snapshot.data[index].delnum
                               // );
                              },
                              child: ListTile(

                                  title: Row(

                                    children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 2, 2, 5),
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


                                      ],
                                    ),
                                  )


                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                );
              },
            );
          }
        },
      ),
    );

  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: mydata(),
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
  final String pickdate;

  //delivery
  final String delname;
  final String deladd;
  final String dellat;
  final String dellong;
  final String delnum;

  User(this.index, this.title, this.slugs, this.desc, this.address, this.creatdt,
      this.pickadd,this.latitude,this.longitude,this.contact,
      this.delname,this.deladd,this.dellat,this.dellong,this.delnum,this.pickdate);
}

