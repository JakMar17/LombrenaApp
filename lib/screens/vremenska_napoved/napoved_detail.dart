import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/screens/detail_card.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons2.dart';

class NapovedDetail extends StatefulWidget {
  NapovedDetail({Key key}) : super(key: key);

  @override
  _NapovedDetailState createState() => _NapovedDetailState();
}

class _NapovedDetailState extends State<NapovedDetail> {
  NapovedCategory napoved;
  Napoved trenutna;
  double _screenHeight;
  RestApi restApi = RestApi();
  List<DetailCard> _cards;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await restApi.fetchPostajeData();
    //vodotok = restApi.getVodotok(vodotok.id);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void initCards() {
    _cards = [];
    for (Napoved n in napoved.napovedi) {
      var t = n.validDay.split(" ");
      _cards.add(DetailCard(
          title: t[0],
          mainMeasure: "${n.tempMin.toInt()} - ${n.tempMax.toInt()}",
          unit: "°C",
          secondData: "${n.minWind.toInt()} - ${n.maxWind.toInt()} km/h",
          icon: n.weatherIcon));
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    napoved = data['napoved'];
    trenutna = napoved.napovedi[0];
    initCards();
    _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          title: Text(napoved.categoryName.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  setState(() {
                    /* vodotok.isFavourite = !vodotok.isFavourite;
                    favorites.addToFavorites(vodotok);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 9,
                            child: Text(
                              vodotok.isFavourite
                                  ? "Vodotok je dodan med priljubljene"
                                  : "Vodotok je odstranjen izmed priljubljenih",
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
                    )); */
                  });
                },
                icon: Icon(Icons.star),
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
                child: SizedBox(height: 40),
              ),
              SliverToBoxAdapter(
                  child: Icon(
                trenutna.weatherIcon,
                color: Colors.white,
                size: 84,
              )),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${trenutna.tempMin} °C",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${trenutna.tempMax} °C",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          WeatherIcons2.wind,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${trenutna.minWind.toInt()} - ${trenutna.maxWind.toInt()} km/h",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: _screenHeight * 0.1),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: _screenHeight * 0.32,
                  margin: EdgeInsets.only(bottom: 0, left: 0),
                  child: Expanded(
                    child: _buildCards(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
                        bottom: 40,
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
