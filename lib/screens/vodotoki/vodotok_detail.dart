import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/screens/detail_card.dart';
import 'package:vreme/style/custom_icons.dart';

class VodotokDetail extends StatefulWidget {
  @override
  _VodotokDetailState createState() => _VodotokDetailState();
}

class _VodotokDetailState extends State<VodotokDetail> {
  
  MerilnoMestoVodotok vodotok;
  RestApi restApi = RestApi();
  double _screenHeight;
  List<DetailCard> cards;
  Favorites favorites = Favorites();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await restApi.fetchPostajeData();
    //vodotok = restApi.getPostaja(postaja.id);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void initCards() {
    cards = [
      /* new DetailCard(
          title: "Veter",
          mainMeasure: postaja.averageWind == null
              ? null
              : postaja.averageWind == 0 ? null : postaja.averageWind,
          unit: "km/h",
          secondData: postaja.windAngle != null
              ? "${postaja.windAngle}° ${postaja.windDir}"
              : null,
          thirdData:
              postaja.maxWind != null ? "max ${postaja.maxWind} km/h" : null), */
      new DetailCard(
        title: "Temperatura vode",
        mainMeasure: vodotok.tempVode == null ? null : vodotok.tempVode,
        unit: "°C",
      ),
      new DetailCard(
        title: "Vodostaj",
        mainMeasure: vodotok.vodostaj == null ? null : vodotok.vodostaj,
        unit: "cm"
      ),
      new DetailCard(
        title: "Pretok",
        mainMeasure: vodotok.pretok == null ? null : vodotok.pretok,
        unit: "m3/s"
      ),
      new DetailCard(
        title: "Visokovodni pretok",
        mainMeasure: vodotok.prviPretok == null ? null : vodotok.prviPretok,
        unit: "m3/s",
        secondData: "${vodotok.drugiPretok} m3/s",
        thirdData: "${vodotok.tretjiPretok} m3/s"
      ),
      new DetailCard(
        title: "Visokovodni vodostaj",
        mainMeasure: vodotok.prviVodostaj == null ? null : vodotok.prviVodostaj,
        unit: "cm",
        secondData: "${vodotok.drugiVodostaj} cm",
        thirdData: "${vodotok.tretjiVodostaj} cm"
      )
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    vodotok = data['vodotok'];
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
          title: Text(vodotok.merilnoMesto.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  vodotok.isFavourite = !vodotok.isFavourite;
                  favorites.addToFavorites(vodotok);
                });
              },
              icon: Icon(vodotok.isFavourite? Icons.star : Icons.star_border),
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
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 50 - 120,
                            child: Text(vodotok.reka,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                                color: Colors.white
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(vodotok.pretokZnacilni != null ? vodotok.pretokZnacilni :
                            vodotok.vodostajZnacilni != null ? vodotok.vodostajZnacilni : "",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 24,
                              fontWeight: FontWeight.w200,
                              color: Colors.white
                            ),  
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: _setImage(vodotok),
                      )
                    ],
                  ),
                ),
              ),
              /* SliverToBoxAdapter(
                child: FlatButton(
                  child: Text("klik"),
                  onPressed: () async {
                    String url =
                      "https://www.google.com/maps/search/?api=1&query=${vodotok.geoLat},${vodotok.geoLon}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
              ), */
              SliverToBoxAdapter(
                child: SizedBox(height: _screenHeight * 0.3),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: _screenHeight * 0.32,
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

  Widget _setImage(MerilnoMestoVodotok vodotok) {
    String url = "assets/images/vodotoki/";

    if(vodotok.pretokZnacilni != null) {
      switch(vodotok.pretokZnacilni) {
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
    } else if(vodotok.vodostajZnacilni != null){
      switch(vodotok.vodostajZnacilni) {
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

    if (url != null)
      return Image.asset(url, height: 100,);
    else
      return Container();
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