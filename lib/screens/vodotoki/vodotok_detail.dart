import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/favorites/favorites_database.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/screens/detail_card.dart';
import 'package:vreme/screens/loading_data.dart';
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
  bool dataLoaded = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await restApi.fetchPostajeData();
    vodotok = restApi.getVodotok(vodotok.id);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void initCards() {
    cards = [
      new DetailCard(
        title: "Temperatura vode",
        mainMeasure: vodotok.tempVode == null ? null : vodotok.tempVode,
        unit: "°C",
      ),
      new DetailCard(
          title: "Vodostaj",
          mainMeasure: vodotok.vodostaj == null ? null : vodotok.vodostaj,
          unit: "cm"),
      new DetailCard(
          title: "Pretok",
          mainMeasure: vodotok.pretok == null ? null : vodotok.pretok,
          unit: "m3/s"),
      new DetailCard(
          title: "Visokovodni pretok",
          mainMeasure:
              vodotok.prviPretok == null ? null : vodotok.prviPretok.toInt(),
          unit: "m3/s",
          secondData:
              "${vodotok.drugiPretok == null ? null : vodotok.drugiPretok.toInt()} m3/s",
          thirdData:
              "${vodotok.tretjiPretok == null ? null : vodotok.tretjiPretok.toInt()} m3/s"),
      new DetailCard(
          title: "Visokovodni vodostaj",
          mainMeasure: vodotok.prviVodostaj == null
              ? null
              : vodotok.prviVodostaj.toInt(),
          unit: "cm",
          secondData:
              "${vodotok.drugiVodostaj == null ? null : vodotok.drugiVodostaj.toInt()} cm",
          thirdData:
              "${vodotok.tretjiVodostaj == null ? null : vodotok.tretjiVodostaj.toInt()} cm")
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  void loadData(String id) async {
    vodotok = restApi.getVodotok(id);
    if (vodotok == null) {
      await restApi.fetchVodotoki();
      vodotok = restApi.getVodotok(id);
    } else
      setState(() {
        dataLoaded = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!dataLoaded) {
      Map data = {};
      data = ModalRoute.of(context).settings.arguments;
      vodotok = data['vodotok'];

      if (vodotok == null)
        loadData(data['vodotokID']);
      else
        setState(() {
          dataLoaded = true;
        });
    }

    initCards();
    _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: dataLoaded
          ? _buildWithData(context)
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: LoadingData(),
            ),
    );
  }

  Scaffold _buildWithData(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: Text(vodotok.merilnoMesto.toUpperCase()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                setState(() {
                  FavoritesDatabase db = FavoritesDatabase();
                  if (vodotok.isFavourite)
                    db.removeFromFavorite(vodotok);
                  else
                    db.addToFavorite(vodotok);
                  vodotok.isFavourite = !vodotok.isFavourite;

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
                  ));
                });
              },
              icon: Icon(vodotok.isFavourite ? Icons.star : Icons.star_border),
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
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 50 - 120,
                            child: Text(
                              vodotok.reka,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            vodotok.pretokZnacilni != null
                                ? vodotok.pretokZnacilni
                                : vodotok.vodostajZnacilni != null
                                    ? vodotok.vodostajZnacilni
                                    : "",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 24,
                                fontWeight: FontWeight.w200,
                                color: Colors.white),
                          )
                        ],
                      ),
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
              child: SizedBox(height: _screenHeight * 0.15),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: _screenHeight * 0.32,
                margin: EdgeInsets.only(bottom: 60, left: 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: detailCard(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Text(
            vodotok.isFavourite
                ? "Dodan med priljubljene"
                : "Odstranjen iz priljubljenih",
          ),
          FlatButton(
            onPressed: () {},
            child: Text("V redu"),
          )
        ],
      ),
    ));
  }

  Widget _setImage(MerilnoMestoVodotok vodotok) {
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

    if (url != null)
      return Image.asset(
        url,
        height: 100,
      );
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
                                      fontSize: 16,
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
