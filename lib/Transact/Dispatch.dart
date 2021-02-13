import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Dispatch extends StatefulWidget {
  String picklat,picklong;
  String mylat,mylong;
  String dellat,dellong;

  Dispatch(this.mylat,this.mylong,this.picklat,this.picklong,this.dellat,this.dellong);

  State<StatefulWidget> createState() {


    return MyPage(this.mylat,this.mylong,this.picklat,this.picklong,this.dellat,this.dellong);
  }
}
class MyPage extends State<Dispatch> {
  String picklat,picklong;
  String mylat,mylong;
  String dellat,dellong;
  MyPage(this.mylat,this.mylong,this.picklat,this.picklong,this.dellat,this.dellong);

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
                    child: Container(

                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(0,50,0,0),//images/indi.png
                      child: Column(
                        children: <Widget>[
                          Image.asset('images/indi.png'),
                          Text("Scheduled", style: TextStyle(fontSize: 40, color: Colors.grey),),
                          Text("Assigned to Driver", style: TextStyle(fontSize: 14, color: Colors.grey),)
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
            child: Container(
                child: Container(
                  height: 200,
                  child: maymap(),)

            )
          ),
      ),
    );
  }

  maymap(){

      return FlutterMap(
        options: new MapOptions(
          center: new LatLng(double.parse(mylat),double.parse(mylong)),
          zoom: 8.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://atlas.microsoft.com/map/tile/png?api-version=1&layer=basic&style=main&tileSize=256&view=Auto&zoom={z}&x={x}&y={y}&subscription-key={subscriptionKey}",

            additionalOptions: {
              'subscriptionKey': 'W_xYK4mUSBN7rJK9S5eeWqWaEvNMt3SvUDnoZAlkEqc'
            },
          ),
          new MarkerLayerOptions(
            markers:[
              new Marker(
                  width: 10.0,
                  height: 10.0,
                  point: new LatLng(double.parse(mylat),double.parse(mylong)),
                  builder: (ctx) => new Container(
                    child: new Icon(Icons.location_on, size: 40, color: Colors.red,),
                  )
              ),

              new Marker(
                  width: 80.0,
                  height: 80.0,

                  point: new LatLng(double.parse(picklat),double.parse(picklong)),
                  builder: (ctx) => new Container(
                    child: new Icon(Icons.location_on, size: 40, color: Colors.blue,),
                  )
              ),
              new Marker(
                  width: 80.0,
                  height: 80.0,

                  point: new LatLng(double.parse(dellat),double.parse(dellong)),
                  builder: (ctx) => new Container(
                    child: new Icon(Icons.location_on, size: 40, color: Colors.green,),
                  )
              ),
            ],
          ),

        ],
      );


  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: nested(),
    );
  }
}