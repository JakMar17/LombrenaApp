import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/screens/detail_card.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostajaDetail extends StatefulWidget {
  PostajaDetail({Key key}) : super(key: key);

  @override
  _PostajaDetailState createState() => _PostajaDetailState();
}

class _PostajaDetailState extends State<PostajaDetail> {
  Postaja postaja;

  static RestApi restApi = RestApi();
  List<DetailCard> cards;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await restApi.fetchPostajeData();
    postaja = restApi.getPostaja(postaja.id);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void initCards() {
    cards = [
      new DetailCard(
          title: "Veter",
          mainMeasure: postaja.averageWind == null
              ? null
              : postaja.averageWind == 0 ? null : postaja.averageWind,
          unit: "km/h",
          secondData: postaja.windAngle != null
              ? "${postaja.windAngle}° ${postaja.windDir}"
              : null,
          thirdData:
              postaja.maxWind != null ? "max ${postaja.maxWind} km/h" : null),
      new DetailCard(
          title: "Padavine",
          mainMeasure: postaja.rain == null
              ? (postaja.snow == null ? null : 0)
              : postaja.rain == 0
                  ? (postaja.snow == null ? null : 0)
                  : postaja.rain,
          unit: "mm",
          secondData: postaja.snow != null ? "${postaja.snow} cm" : null),
      new DetailCard(
          title: "Zračni tlak", mainMeasure: postaja.preassure, unit: "hPa"),
      new DetailCard(
        title: "Vlažnost zraka",
        mainMeasure:
            postaja.averageHum != null ? postaja.averageHum : postaja.humidity,
        unit: "%",
      ),
      new DetailCard(
          title: "Dolžina dneva",
          mainMeasure: postaja.dayLength,
          unit: "",
          secondData: "${postaja.sunrise}",
          thirdData: "${postaja.sunset}"),
      new DetailCard(
          title: "Temperatura rosišča",
          mainMeasure: postaja.dewpoint != null ? postaja.dewpoint : null,
          unit: "°C"),
      new DetailCard(
          title: "Sončno obsevanje",
          mainMeasure:
              postaja.obsevanje == null ? null : "${postaja.obsevanje}",
          unit: "W/m2"),
      new DetailCard(
          title: "Vidljivost",
          mainMeasure: postaja.vidnost == null ? null : "${postaja.vidnost}",
          unit: "km"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Favorites favorites = Favorites();

    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    postaja = data['postaja'];
    initCards();

    double screenHeight = MediaQuery.of(context).size.height;

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
          title: Text(postaja.titleLong.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  postaja.isFavourite = !postaja.isFavourite;
                  favorites.addToFavorites(postaja);
                });
              },
              icon: Icon(postaja.isFavourite ? Icons.star : Icons.star_border),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              postaja.averageTemp.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 100,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 2),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "°C",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w100,
                                    letterSpacing: 2),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      minMaxTemp(),
                      SizedBox(
                        height: 10,
                      ),
                      altitudeRow()
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: screenHeight * 0.10),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: screenHeight * 0.32,
                  margin: EdgeInsets.only(bottom: 60, left: 0),
                  child: Expanded(
                    child: detailCard(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row minMaxTemp() {
    if (postaja.minTemp == null || postaja.maxTemp == null) return Row();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("${postaja.minTemp}°C",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w300,
                letterSpacing: 1.2)),
        SizedBox(width: 5),
        Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
        SizedBox(width: 10),
        Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        SizedBox(width: 5),
        Text("${postaja.maxTemp}°C",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w300,
                letterSpacing: 1.2))
      ],
    );
  }

  Row altitudeRow() {
    if (postaja.altitude == null) return Row();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              "${postaja.altitude} m",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w300),
            ),
            Text(
              "Višina",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
        SizedBox(
          width: 50,
        ),
        Column(
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                String url =
                    "https://www.google.com/maps/search/?api=1&query=${postaja.geoLat},${postaja.geoLon}";
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.map,
                    color: Colors.white,
                    size: 36,
                  ),
                  Text(
                    "Lokacija",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  ListView detailCard() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          DetailCard card = cards[index];
          double paddingLeft = 0;
          if (index == 0) paddingLeft = 20;

          if (card.mainMeasure == null) if (index == 0)
            return Container(
              margin: EdgeInsets.only(left: 20),
            );
          else
            return Container();

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
                child: Padding(
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
              ));
        });
  }
}
