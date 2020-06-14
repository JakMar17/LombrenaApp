import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/map_marker.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons2.dart';

class ListOfNapovedi extends StatefulWidget {
  @override
  _ListOfNapovediState createState() => _ListOfNapovediState();
}

class _ListOfNapovediState extends State<ListOfNapovedi> {
  RestApi restApi = RestApi();

  List<NapovedCategory> napoved5dnevna;
  List<NapovedCategory> napoved3dnevna;
  List<NapovedCategory> napovedPoPokrajinah;

  @override
  void initState() {
    napoved5dnevna = [];
    napoved5dnevna.add(restApi.get5dnevnaNapoved());
    napoved3dnevna = restApi.get3dnevnaNapoved();
    napovedPoPokrajinah = restApi.getPokrajinskaNapoved();
    super.initState();
  }

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
                title: Text(
                  "Vremenska napoved",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 30),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  _buildList("Napoved po pokrajinah", napovedPoPokrajinah)),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  _buildList("3 dnevna napoved", napoved3dnevna)),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  _buildList("5 dnevna napoved", napoved5dnevna)),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
      ),
    );
  }

  List _buildList(String title, List<NapovedCategory> cat) {
    List<Widget> list = [];
    List<MapMarker> markers = [];

    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 10,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Flexible(
                flex: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    for (NapovedCategory c in cat) {
                      var n = c.napovedi[0];
                      markers.add(MapMarker(
                          title: n.longTitle,
                          mainData: n.temperature != null
                              ? "${n.temperature}"
                              : "${(n.tempMax + n.tempMin) / 2}",
                          mainDataUnit: "°C",
                          lat: n.geoLat,
                          lon: n.geoLon,
                          object: n,
                          leading: Column(
                            children: <Widget>[
                              Icon(n.weatherIcon, color: Colors.white, size: 40,),
                              SizedBox(height: 12,)
                            ],
                          ),
                          mark: setMarker(n.temperature == null ? ((n.tempMax - n.tempMin) /2) : n.temperature),
                          onPress: () {
                            Navigator.pushNamed(context, "/napoved",
                                arguments: {"napoved": c});
                          }));
                    }

                    Navigator.pushNamed(context, "/map",
                        arguments: {"markers": markers});
                  },
                ))
          ],
        ),
      ),
    );

    list.add(SizedBox(
      height: 10,
    ));

    for (int i = 0; i < cat.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/napoved",
                arguments: {"napoved": cat[i]});
          },
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    cat[i].categoryName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 22,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return list;
  }

  String setMarker(double temp) {
    String base = "assets/images/temperature/";
    print(temp);
    if(temp < -10)
      return "${base}temp001.png";
    else if(temp < 0)
      return "${base}temp002.png";
    else if(temp < 5)
      return "${base}temp003.png";
    else if(temp < 10)
      return "${base}temp004.png";
    else if(temp < 15)
      return "${base}temp005.png";
    else if(temp < 20)
      return "${base}temp006.png";
    else if(temp < 28)
      return "${base}temp007.png";
    else if(temp < 32)
      return "${base}temp008.png";
    else
      return "${base}temp009.png";

    //return "";
  }
}
