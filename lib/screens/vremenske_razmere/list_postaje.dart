import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/data/models/map_marker.dart';

class ListOfPostaje extends StatefulWidget {
  @override
  _ListOfPostajeState createState() => _ListOfPostajeState();
}

class _ListOfPostajeState extends State<ListOfPostaje> {

  List<MerilnoMestoVodotok> vodotoki = RestApi().getVodotoki();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              backgroundColor: CustomColors.blue,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Avtomatske postaje",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),),
          
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.map, color: Colors.white),
                  onPressed: (){
                    List<MapMarker> markers = [];
                    for (Postaja p in postaje)
                      markers.add(MapMarker(
                        title: p.titleLong,
                        onPress: () {
                          Navigator.pushNamed(context, "/postaja", arguments: {"postaja": p});
                        },
                        showData: "${p.temperature} °C",
                        object: p,
                        lat: p.geoLat,
                        lon: p.geoLon
                      ));
                    
                    Navigator.pushNamed(context, "/map", arguments: {"markers": markers});
                  },
                )
              ],
              
            ),
            SliverPadding(padding: EdgeInsets.only(top: 30),),
            SliverList(
              delegate: SliverChildListDelegate(
                _buildList()
              ),
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 30),)
          ],
        ),
      ),
    );
  }

  List<Postaja> postaje;

  List _buildList() {
    RestApi restApi = RestApi();
    postaje = restApi.getAvtomatskePostaje();
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> listItems = List();
    for (int i = 0; i < postaje.length; i++) {
      listItems.add(
        Container (
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: RaisedButton(
            color: Colors.transparent,
            onPressed: (){
              Navigator.pushNamed(context, "/postaja", arguments: {"postaja": postaje[i]});
            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.5,
                  child: Text(postaje[i].titleShort.toUpperCase(),
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(postaje[i].temperature.toString(),
                        style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w300
                    ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("°C",
                          style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w200
                        ),
                        ),
                    )
                  ],
                ),
              ],
            ),
                      ),
          ),
        )
      );
    }
    return listItems;
  }
}