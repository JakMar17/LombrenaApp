import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/fetching_data.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/favorites/favorites_database.dart';
import 'package:vreme/data/models/napoved_gore.dart';
import 'package:vreme/screens/detail_card.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons.dart';
import 'package:vreme/style/weather_icons2.dart';

class GoreDetail extends StatefulWidget {
  @override
  _GoreDetailState createState() => _GoreDetailState();
}

class _GoreDetailState extends State<GoreDetail> {
  NapovedGore napoved;
  NapovedGoreDan trenutna;
  _NadmorskaVisinaSelector selected;
  String selectedNadmorskaVisina = "500 m nv.";
  List<_NadmorskaVisinaSelector> dropdownOptions = [
    _NadmorskaVisinaSelector(name: "500 m nv.", value: 500),
    _NadmorskaVisinaSelector(name: "1000 m nv.", value: 1000),
    _NadmorskaVisinaSelector(name: "1500 m nv.", value: 1500),
    _NadmorskaVisinaSelector(name: "2000 m nv.", value: 2000),
    _NadmorskaVisinaSelector(name: "2500 m nv.", value: 2500),
    _NadmorskaVisinaSelector(name: "3000 m nv.", value: 3000),
    _NadmorskaVisinaSelector(name: "5500 m nv.", value: 5500)
  ];
  bool dataLoaded = false;

  List<DetailCard> _cards;
  double _screenHeight;

  void loadData(Map data) async {
    DataModel m = data['data_model'];
    if (m != null) {
      FetchingData f = FetchingData();
      napoved = await f.fetchNapovedGore(m.url);
      napoved.isFavourite = m.favorite;
    } else {
      napoved = data["napoved"];
    }

    setTrenutnaNapoved();
    setState(() {
      dataLoaded = true;
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    FetchingData f = FetchingData();
    napoved = await f.fetchNapovedGore(napoved.url);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void setTrenutnaNapoved() {
    trenutna = napoved.napovedi[0];
    switch (selectedNadmorskaVisina) {
      case "500 m nv.":
        selected = dropdownOptions[0];
        break;
      case "1000 m nv.":
        selected = dropdownOptions[1];
        break;
      case "1500 m nv.":
        selected = dropdownOptions[2];
        break;
      case "2000 m nv.":
        selected = dropdownOptions[3];
        break;
      case "2500 m nv.":
        selected = dropdownOptions[4];
        break;
      case "3000 m nv.":
        selected = dropdownOptions[5];
        break;
      case "5500 m nv.":
        selected = dropdownOptions[6];
        break;
    }

    _cards = [];
    for (NapovedGoreDan n in napoved.napovedi) {
      _cards.add(DetailCard(
          title: n.getDay(),
          mainMeasure: "${n.getNapovedNaVisini(selected.value).temp}",
          unit: "°C",
          secondData:
              "${n.getNapovedNaVisini(selected.value).windSpeed * 3.6} km/h ${n.getNapovedNaVisini(selected.value).windDir}",
          thirdData: "${n.getNapovedNaVisini(selected.value).humidity} %",
          icon: selected.value <= 2000 ? n.weather1500 : n.weather2500));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!dataLoaded) {
      Map data = {};
      data = ModalRoute.of(context).settings.arguments;
      loadData(data);
    }

    _screenHeight = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [CustomColors.blue, CustomColors.blue2],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: dataLoaded
            ? _loadWithData()
            : Scaffold(
                backgroundColor: Colors.transparent, body: LoadingData()));
  }

  Widget _loadWithData() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          napoved.title,
          style: TextStyle(fontFamily: "Montserrat"),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                setState(() {
                  FavoritesDatabase fd = FavoritesDatabase();
                  if (napoved.isFavourite)
                    fd.removeFromFavorite(napoved);
                  else
                    fd.addToFavorite(napoved);
                  napoved.isFavourite = !napoved.isFavourite;

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 9,
                          child: Text(
                            napoved.isFavourite
                                ? "Napoved je dodana med priljubljene"
                                : "Napoved je odstranjena izmed priljubljenih",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: FlatButton(
                            child: Text("OK",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                )),
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ),
                        )
                      ],
                    ),
                  ));
                });
              },
              icon: Icon(napoved.isFavourite ? Icons.star : Icons.star_border),
            ),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Center(child: _nadmorskaVisinaDropdown())),
            SliverToBoxAdapter(
              child: Icon(
                selected.value <= 2000
                    ? napoved.napovedi[0].weather1500
                    : napoved.napovedi[0].weather2500,
                color: Colors.white,
                size: 84,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "${trenutna.getNapovedNaVisini(selected.value).temp} °C",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Montserrat"),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${trenutna.snowingPoint.toInt()} m",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Montserrat"),
                            ),
                            Text(
                              "Meja sneženja",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.ac_unit,
                          color: Colors.white,
                          size: 36,
                        ),
                      ],
                    ),
                    //SizedBox(width: 10,),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Icon(
                              WeatherIcons.wind_1,
                              color: Colors.white,
                              size: 36,
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${trenutna.getNapovedNaVisini(selected.value).windSpeed * 3.6} km/h",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Montserrat"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: _screenHeight*0.04,),),
            SliverToBoxAdapter(child: Container(
              height: _screenHeight*0.38, child: Row(children: <Widget>[Expanded(child: _buildCards(),)],),),)
          ],
        ),
      ),
    );
  }

  DropdownButton _nadmorskaVisinaDropdown() {
    return DropdownButton<String>(
      value: selectedNadmorskaVisina,
      icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
      //iconSize: 20,
      dropdownColor: CustomColors.lightGrey,
      elevation: 0,
      style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
      underline: Container(
        height: 0.5,
        color: Colors.white,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedNadmorskaVisina = newValue;
          setTrenutnaNapoved();
        });
      },
      items: <String>[
        "500 m nv.",
        "1000 m nv.",
        "1500 m nv.",
        "2000 m nv.",
        "2500 m nv.",
        "3000 m nv.",
        "5500 m nv."
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildCards() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          DetailCard card = _cards[index];
          double paddingLeft = 0;
          if (index == 0) paddingLeft = 20;
          return Padding(
              padding: EdgeInsets.only(right: 10, left: paddingLeft),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [CustomColors.lightGrey, CustomColors.darkGrey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Positioned(
                        bottom: 80,
                        right: 40,
                        child: Icon(
                          card.icon,
                          size: 84,
                          color: Colors.white30,
                        )),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    card.mainMeasure.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Text(
                                      card.unit,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  card.secondData != null
                                      ? Text(
                                          "${card.secondData}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w300,
                                              fontSize: 20),
                                        )
                                      : Text("")
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  card.thirdData != null
                                      ? Text(
                                          "${card.thirdData}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                          Text(
                            card.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}

class _NadmorskaVisinaSelector {
  int value;
  String name;

  _NadmorskaVisinaSelector({this.value, this.name});
}
