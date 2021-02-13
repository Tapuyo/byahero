import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tts/tts.dart';
import 'package:byaherov1/MyClass/myVar.dart';

class HistoryTask extends StatefulWidget {
  String something;
  HistoryTask(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<HistoryTask> {
  String something;
  MyPage(this.something);



  Future<List<User>> getUsers() async{

    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + something};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/assigned/history/";
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

      if(u['transaction_no'] == null)
      {
        tranid = "none";
      }else{
        tranid = u['transaction_no'];
      }

      //tranid = u['transaction_no'];
      print("history");
      //if(tranid != null){
        //if(u['status'] >= 10){
          User user = User(tranid,title,slug,desc,price,email,
              picname,picadd, piclat, piclong, picnum,
              delname,deladd,dellat,dellong,delnum);
          users.add(user);
        //}
      //}


    }

    print(users.length);
    return users;


  }
  void initState() {
    super.initState();
    getUsers();

  }

  speakme(String tspk) async {
    final languages = await Tts.getAvailableLanguages();
    print(languages);
    var isGoodLanguage = await Tts.isLanguageAvailable("fil-PH");
    print(isGoodLanguage);
    Tts.speak('Get ready for starting the transaction.');

  }


  mydata(){
    return Container(
      child: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null){
            return Container(
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
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                    color: Color.fromRGBO(240, 233, 251, 1),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.fromLTRB(2,10,2,2),

                      child: GestureDetector(

                        onTap: () {
                         // speakme("Hello");
                        },
                        child: ListTile(

                            title: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(2,2,2,5),
                                    child: Text(snapshot.data[index].title,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                  ),
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

                                  //Row(
                                  //  children: <Widget>[
                                  //    Text("Description: "),
                                  //    Flexible(
                                  //      fit: FlexFit.loose,
                                  //      child: Text(snapshot.data[index].desc),
                                  //    ),

                                  //  ],
                                  //),


                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.fromLTRB(2,2,2,10),

                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Pickup: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(snapshot.data[index].pickadd),
                                      ),

                                    ],
                                  ),


                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.fromLTRB(2,2,2,2),

                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Delivery: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                                  //Row(
                                   // children: <Widget>[
                                   //   Text("Status: "),
                                   //   Flexible(
                                   //     fit: FlexFit.loose,
                                   //     child: Text("Complete", style: TextStyle(color: Colors.green),),
                                   //   ),

                                   // ],
                                  //),

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


  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: const EdgeInsets.fromLTRB(10,0,10,0),
        child: mydata(),

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
  final String picname;
  final String pickadd;
  final String latitude;
  final String longitude;


  //delivery
  final String delname;
  final String deladd;
  final String dellat;
  final String dellong;
  final String delnum;

  User(this.index, this.title, this.slugs, this.desc, this.address, this.creatdt,
      this.picname,this.pickadd,this.latitude,this.longitude,this.contact,
      this.delname,this.deladd,this.dellat,this.dellong,this.delnum);
}
