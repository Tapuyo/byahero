import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:byaherov1/homepage/viewinf.dart';
import 'package:byaherov1/MyClass/myVar.dart';

class NewSched extends StatefulWidget {
  String something;
  NewSched(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}





class MyPage extends State<NewSched> with TickerProviderStateMixin {
  int dtme = 0;
  String something;
  MyPage(this.something);

      List mylist =  [];



  DateTime startDate = DateTime.now().subtract(Duration(days: 100));
  DateTime endDate = DateTime.now().add(Duration(days: 100));
  DateTime selectedDate = DateTime.now();
  List<DateTime> markedDates = [];
  List datesData = [];

  onSelect(data) {
    setState(() {
      datesData.clear();
    });
    print("Selected Date -> $data");


    for(int i = 0; i < mylist.length; i++){
      DateTime mydt;
      if(mylist[i]['pickup']['pickup_date'] == null){
        mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      }else{
        mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd").parse(mylist[i]['pickup']['pickup_date'])));
      }

      if(DateTime.parse(DateFormat('yyyy-MM-dd').format(data)) == DateTime.parse(DateFormat('yyyy-MM-dd').format(mydt))){
        setState(() {
          datesData.add(mylist[i]);
        });
      }
    }
    dtme = mylist.length;
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(monthName,
          style:
          TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber[800]),
      ),

    ]);
  }

  dateTileBuilder(date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(), style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }



  @override
  void dispose() {

    super.dispose();

  }

  void initState() {
    showdata();
    // TODO: implement initState
    super.initState();

  }

  showdata()async{
    Map<String, String> headers = {"Content-type": "application/json", 'Authorization': 'Bearer ' + something};
    String url = "https://admin.byaherongpinoy.com/api/v1/driver/transaction/assigned/all/";
    final response = await http.get(url,headers: headers);

    //String arrayObjsText = json.decode(response.body)['data'];

    var tagObjsJson = jsonDecode(response.body)['data'] as List;
    setState(() {
      mylist = tagObjsJson;
    });

    print(mylist);

    for(int i = 0; i < mylist.length; i++) {
      DateTime dtnow = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      DateTime dtme = DateFormat("yyyy-MM-dd").parse(mylist[i]['pickup']['pickup_date']);

      if(dtnow.isBefore(dtme)){

      if (mylist[i]['status'] <= 9) {
        DateTime mydt;

        setState(() {
          DateTime dtme = new DateFormat("yyyy-MM-dd").parse(
              mylist[i]['pickup']['pickup_date']);
          //print(DateFormat('yyyy-MM-dd').format(mylist[i]['pickup']['pickup_date']));
          if (mylist[i]['pickup']['pickup_date'] == null) {
            mydt =
                DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
          } else {
            mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(
                DateFormat("yyyy-MM-dd").parse(
                    mylist[i]['pickup']['pickup_date'])));
          }


          markedDates.add(mydt);
          datesData.add(mylist[i]);
        });
      }
    }
    }

  }
  myimageads(int stat){
    if(stat == 4){
      return RotatedBox(
        quarterTurns: 3,
        child: Text("Not Stated",style: TextStyle(fontSize: 8, color: Colors.white),),
      );
    }
   if(stat == 5){
    return RotatedBox(
         quarterTurns: 3,
         child: Text("To Pickup",style: TextStyle(fontSize: 8, color: Colors.white),),
     );
   }
   if(stat == 6){
     return RotatedBox(
       quarterTurns: 3,
       child: Text("To Pickup",style: TextStyle(fontSize: 8, color: Colors.white),),
     );
   }
   if(stat == 7){
     return RotatedBox(
       quarterTurns: 3,
       child: Text("To Deliver",style: TextStyle(fontSize: 8, color: Colors.white),),
     );
   }
   if(stat == 8){
     return RotatedBox(
       quarterTurns: 3,
       child: Text("Delivered",style: TextStyle(fontSize: 8, color: Colors.white),),
     );
   }
   if(stat == 9){
     return RotatedBox(
       quarterTurns: 3,
       child: Text("To Yard",style: TextStyle(fontSize: 8, color: Colors.white),),
     );
   }else{
     return RotatedBox(
       quarterTurns: 3,
       child: Text("",style: TextStyle(fontSize: 8, color: Colors.white),),
     );
   }
  }
  mydataview(){
    if (dtme == 0){
      return Container(

        padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
        child: Center(
          child: Column(
            children: <Widget>[
              //Image.asset('images/truckgif.gif'),

              Text("Select other date", style: TextStyle(fontSize: 14, color: Colors.black45),),
              Text("No task found", style: TextStyle(fontSize: 20, color: Colors.black45, fontStyle: FontStyle.italic),),
            ],
          ),
        ),
      );
    }else{
      return ListView.builder(

          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: datesData.length,
          itemBuilder: (BuildContext context, i){
            return Card(
              color: Color.fromRGBO(240, 233, 251, 1),
              child: GestureDetector(
                onTap: (){
                  print(datesData[i]['confirmation_type']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => viewinf(TransVar.token,datesData[i]['status'],
                      datesData[i]['transaction_no'],
                      datesData[i]['pickup']['address'],
                      datesData[i]['pickup']['phone_number'],
                      datesData[i]['pickup']['latitude'],
                      datesData[i]['pickup']['longitude'],
                      datesData[i]['delivery']['name'],
                      datesData[i]['delivery']['address'],
                      datesData[i]['delivery']['latitude'],
                      datesData[i]['delivery']['longitude'],
                      datesData[i]['delivery']['phone_number'],

                      TransVar.mylatidute,
                      TransVar.mylongitude,

                      datesData[i]['description'],
                      datesData[i]['slug'],
                      datesData[i]['shipment_status'],
                      datesData[i]['shipping_line'],
                      datesData[i]['shipment_type'],
                      datesData[i]['container_weight'],
                      datesData[i]['container'],

                      datesData[i]['container_yard']['name'],
                      datesData[i]['container_yard']['latitude'],
                      datesData[i]['container_yard']['longitude'],
                    ),

                    ),
                  );
                },
                child: new Column(

                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Expanded(
                          flex:1,
                          child: Card(
                            color: Color.fromRGBO(240, 233, 251, 1),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10,5,0,2),
                             // height: 120,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(datesData[i]['title'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                  Container(height: 10,),
                                  Row(
                                    children: <Widget>[
                                      Text("Pickup: ", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                                      Flexible(child: Text(datesData[i]['pickup']['address'], style: TextStyle(color: Colors.black, fontSize: 12),)),
                                    ],
                                  ),
                                  Container(height: 10,),
                                  //Text(datesData[i]['pickup']['phone_number'], style: TextStyle(color: Colors.black45, fontSize: 12),),
                                  Row(
                                    children: <Widget>[
                                      Text("Delivery: ", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                                      Flexible(child: Text(datesData[i]['delivery']['address'], style: TextStyle(color: Colors.black, fontSize: 12),)),
                                    ],
                                  ),
                                  Container(height: 10,),
                                  //Text(datesData[i]['delivery']['phone_number'], style: TextStyle(color: Colors.black45, fontSize: 12),),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(

        body: ListView(
          children: <Widget>[
            Container(
                height: 130,
                child: CalendarStrip(
                  startDate: startDate,
                  endDate: endDate,
                  onDateSelected: onSelect,
                  dateTileBuilder: dateTileBuilder,
                  iconColor: Colors.black87,
                  monthNameWidget: _monthNameWidget,
                  markedDates: markedDates,
                  containerDecoration: BoxDecoration(color: Colors.black12),
                )),
            mydataview(),


          ],
        ),

      );

  }


}
