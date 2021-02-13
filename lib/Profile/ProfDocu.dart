import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:byaherov1/MyClass/myVar.dart';

class ProfDocu extends StatefulWidget {
  String something;
  ProfDocu(this.something);

  State<StatefulWidget> createState() {


    return MyPage(this.something);
  }
}
class MyPage extends State<ProfDocu> {
  String something;
  MyPage(this.something);

  final driveli = TextEditingController();


  String _selectedDate;

  void changename(){
    TransVar.driveli = driveli.text;

    print(TransVar.driveli);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {

        _selectedDate = DateFormat('yyyy/MM/dd').format(args.value).toString();
      }
      TransVar.drivexp = _selectedDate;
      print(TransVar.drivexp);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          padding: const EdgeInsets.fromLTRB(2,100,2,2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.blue]),
          ),
          child: Center(
              child: Column(
                children: <Widget>[
                  Text("User Docu", style: TextStyle(color: Colors.white, fontSize: 20.0),),

                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: TextField(
                        controller: driveli,
                        onChanged: (text) {
                          changename();
                        },
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)
                          ),
                          hintText: 'Driver License No',

                        ),
                      )
                  ),
                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: Text("Date Expiration")
                  ),
                  Container(
                      width: 280,
                      height: 200,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child:  SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                      ),
                  ),
                  Container(

                      width: 280,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Center(
                        child: Text("swipe >>>", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      )
                  ),

                ],
              )
          )
      ),
    );
  }
}