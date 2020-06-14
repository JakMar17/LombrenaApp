import 'package:flutter/material.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/data/models/map_marker.dart';

class ListOfVodotoki extends StatefulWidget {
  @override
  _ListOfVodotokiState createState() => _ListOfVodotokiState();
}

class _ListOfVodotokiState extends State<ListOfVodotoki> {
  List<VodotokReka> vodotokiPoRekah;

  @override
  void initState() {
    VodotokiPoRekah vpr = VodotokiPoRekah();
    vodotokiPoRekah = vpr.fetchVodotokiPoRekah();
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
                  "Vodotoki",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    List<MapMarker> markers = [];
                    for (VodotokReka v in vodotokiPoRekah)
                      for (MerilnoMestoVodotok m in v.vodotoki)
                        markers.add(MapMarker(
                            title: "${m.merilnoMesto}",
                            subtitle: m.reka,
                            onPress: () {
                              Navigator.pushNamed(context, "/vodotok",
                                  arguments: {"vodotok": m});
                            },
                            mainData: m.pretok == null
                                ? "${m.vodostaj}"
                                : "${m.pretok}",
                            mainDataUnit: m.pretok == null ? "cm" : "m3/s",
                            leading: _setImage(m),
                            object: m,
                            lat: m.geoLat,
                            lon: m.geoLon,
                            mark: _setUrl(m)));

                    Navigator.pushNamed(context, "/map",
                        arguments: {"markers": markers});
                  },
                )
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 30),
            ),
            SliverList(
              delegate: SliverChildListDelegate(_buildList()),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
      ),
    );
  }

  List _buildList() {
    List<Widget> list = [];

    for (int i = 0; i < vodotokiPoRekah.length; i++) {
      list.add(Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                vodotokiPoRekah[i].reka,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5),
              for (int j = 0; j < vodotokiPoRekah[i].vodotoki.length; j++)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/vodotok", arguments: {
                        "vodotok": vodotokiPoRekah[i].vodotoki[j]
                      });
                    },
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Text(
                              vodotokiPoRekah[i].vodotoki[j].merilnoMesto,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          _setImage(vodotokiPoRekah[i].vodotoki[j])
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ));
    }

    return list;
  }

  String _setUrl(MerilnoMestoVodotok vodotok) {
    String url = "assets/images/vodotoki/";

    if (vodotok.pretokZnacilni != null) {
      switch (vodotok.pretokZnacilni) {
        case "mali pretok":
          url += "small128.png";
          break;
        case "srednji pretok":
          url += "medium128.png";
          break;
        case "velik pretok":
          url += "big128.png";
          break;
        case "prvi visokovodni pretok":
          url += "big1128.png";
          break;
        case "drugi visokovodni pretok":
          url += "big2128.png";
          break;
        case "tretji visokovodni pretok":
          url += "big3128.png";
          break;
        default:
          url = null;
      }
    } else if (vodotok.vodostajZnacilni != null) {
      switch (vodotok.vodostajZnacilni) {
        case "nizek vodostaj":
          url += "small128.png";
          break;
        case "srednji vodostaj":
          url += "medium128.png";
          break;
        case "visok vodostaj":
          url += "big128.png";
          break;
        case "prvi visokovodni vodostaj":
          url += "big1128.png";
          break;
        case "drugi visokovodni vodostaj":
          url += "big2128.png";
          break;
        case "tretji visokovodni vodostaj":
          url += "big3128.png";
          break;
        default:
          url = null;
      }
    } else {
      url = null;
    }

    print("${vodotok.merilnoMesto}  $url");
    return url;
  }

  Widget _setImage(MerilnoMestoVodotok vodotok) {
    String url = _setUrl(vodotok);

    if (url != null)
      return Image.asset(
        url,
        height: 32,
      );
    else
      return Container();
  }
}
