import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/favorites/favorites_database.dart';
import 'package:vreme/data/menu_data.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/style/weather_icons2.dart';
import 'package:vreme/data/location_services/location_services.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static RestApi restApi = RestApi();
  List<Postaja> postaje = restApi.getAvtomatskePostaje();
  List<MerilnoMestoVodotok> vodotoki = restApi.getVodotoki();

  SettingsPreferences _settings = SettingsPreferences();

  List<MenuItem> categoryMenu = [
    MenuItem(menuName: "Vremenske razmere", url: "/postaje"),
    MenuItem(menuName: "Vodotoki", url: '/vodotoki'),
    MenuItem(menuName: "Vremenska napoved", url: "/napovedi"),
    MenuItem(menuName: "Tekstovna napoved", url: "/napoved/tekst"),
    MenuItem(menuName: "Izdana opozorila", url: "/warnings")
    /* MenuItem(menuName: "Sistem Burja"),
  MenuItem(menuName: "Kakovost zraka"),*/
  ];

  FavoritesDatabase fd;
  static List<dynamic> closestData;
  static bool loadedClosestData = false;
  bool showClosestLocations;
  bool showCategories;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    fd = FavoritesDatabase();
    await fd.getFavoritesFromDB();
    await loadClosestData(locationServices);
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  LocationServices locationServices = LocationServices();
  @override
  void initState() {
    showClosestLocations =
        _settings.getSetting("settings_bliznje_lokacije") == null
            ? true
            : _settings.getSetting("settings_bliznje_lokacije");
    showCategories = _settings.getSetting("settings_visible_categories") == null
        ? true
        : _settings.getSetting("settings_visible_categories");
    loadClosestData(locationServices);
    super.initState();
  }

  Future<void> loadClosestData(LocationServices locationServices) async {
    var y = await locationServices.getLocation();
    if (showClosestLocations) {
      closestData = await locationServices.getClosestData();
      setState(() {
        loadedClosestData = true;
        loadingData();
      });
    }
  }

  Future<void> loadingData() {
    restApi.fetchPostajeData();
    restApi.fetchVodotoki();
    restApi.fetch5DnevnaNapoved();
    restApi.fetch3DnevnaNapoved();
    restApi.fetchPokrajinskaNapoved();
    restApi.fetchTextNapoved();
    restApi.fecthWarnings();
  }

  @override
  Widget build(BuildContext context) {
    fd = FavoritesDatabase();

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
            backgroundColor: Colors.transparent,
            title: Text("MarelaApp"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/search');
                  },
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ))
            ],
          ),
          drawer: Drawer(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [CustomColors.darkBlue, CustomColors.darkBlue2],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft)),
              child: SafeArea(child: _drawer()),
            ),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: onRefresh,
            child: CustomScrollView(
              slivers: <Widget>[
                FavoritesDatabase.favorites != null &&
                        FavoritesDatabase.favorites.length != 0
                    ? SliverToBoxAdapter(
                        child: _cardRow(
                            "Priljubljene",
                            FavoritesDatabase.favorites,
                            /* () {
                          Navigator.pushNamed(context, "/reorder/favorites");
                        } */
                            null),
                      )
                    : SliverToBoxAdapter(),
                SliverToBoxAdapter(
                    child: showClosestLocations
                        ? loadedClosestData
                            ? _cardRow("V bližini", closestData, null)
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "V bližini",
                                      style: TextStyle(
                                          fontSize: 36,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: LoadingData(),
                                    ),
                                  ],
                                ),
                              )
                        : Container()),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
                SliverToBoxAdapter(
                    child: showCategories
                        ? Container(
                            color: Colors.transparent,
                            child:
                                /* 
                      Kategorije
                    */
                                Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Kategorije",
                                    style: TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()),
                showCategories
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 10),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                          context, categoryMenu[index].url)
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          categoryMenu[index].menuName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              letterSpacing: 0.6,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: categoryMenu.length,
                        ),
                      )
                    : SliverToBoxAdapter(),
                SliverToBoxAdapter(
                  child: SizedBox(height: 50),
                ),
              ],
            ),
          )),
    );
  }

  Widget _cardRow(String rowName, List<dynamic> list, void onPress()) {
    if (list == null) return Container();

    return Container(
        color: Colors.transparent,
        child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        rowName,
                        style: TextStyle(
                            fontSize: 36,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300),
                      ),
                      onPress != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: IconButton(
                                onPressed: onPress,
                                icon: Icon(
                                  CustomIcons.option,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 300,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          dynamic temp = list[index];
                          double leftPadding = 0;
                          if (index == 0) leftPadding = 20;
                          return Padding(
                              padding: EdgeInsets.only(left: leftPadding),
                              child: _createCard(temp));
                        },
                      )),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget buildCardList(List<dynamic> list) {
    //List<dynamic> priljubljene = favorites.getFavorites();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        dynamic temp = list[index];
        double leftPadding = 0;
        if (index == 0) leftPadding = 20;
        return Padding(
            padding: EdgeInsets.only(left: leftPadding),
            child: _createCard(temp));
      },
    );
  }

  Widget _createCard(var temp) {
    if(temp.typeOfData == null)
      return Container();
    if (temp.typeOfData == TypeOfData.postaja) {
      return _card(new Card(
          url: '/postaja',
          urlArgumentName: "postaja",
          title: temp.titleShort,
          object: temp,
          mainData: temp.temperature.toString(),
          unit: "°C",
          secondData: temp.averageWind != null
              ? "${temp.averageWind} km/h"
              : temp.windSpeed != null ? "${temp.windSpeed} km/h" : "0 km/h",
          thirdData: temp.averageHum != null
              ? "${temp.averageHum} %"
              : "${temp.humidity} %",
          secondDataIcon: WeatherIcons.wind_1,
          //secondDataIcon: WeatherIcons2.daySunny,
          thirdDataIcon: WeatherIcons.water_drop));
    } else if (temp.typeOfData == TypeOfData.vodotok) {
      return _card(new Card(
          url: '/vodotok',
          urlArgumentName: 'vodotok',
          object: temp,
          title: temp.merilnoMesto,
          mainData: temp.pretok != null
              ? temp.pretok.round().toString()
              : temp.vodostaj.round().toString(),
          unit: temp.pretok != null ? "m3/s" : "cm",
          secondData: temp.pretokZnacilni != null
              ? temp.pretokZnacilni
              : temp.vodostajZnacilni != null ? temp.vodostajZnacilni : "",
          thirdData: temp.tempVode != null ? "${temp.tempVode} °C" : "",
          secondDataIcon: WeatherIcons.water,
          thirdDataIcon: WeatherIcons.temperatire));
    } else if (temp.typeOfData == TypeOfData.napoved5Dnevna ||
        temp.typeOfData == TypeOfData.napoved3Dnevna ||
        temp.typeOfData == TypeOfData.pokrajinskaNapoved || temp.typeOfData.toLowerCase().contains("napoved")) {
      return _card(new Card(
          url: '/napoved',
          urlArgumentName: 'napoved',
          object: temp,
          title: temp.napovedi[0].longTitle,
          unit: "°C",
          icon: temp.napovedi[0].weatherIcon,
          mainData: temp.napovedi[0].temperature != null
              ? temp.napovedi[0].temperature.toString()
              : "${(temp.napovedi[0].tempMin.toInt() + temp.napovedi[0].tempMax.toInt()) / 2}",
          secondData: temp.napovedi[0].minWind.toInt() == 0
              ? temp.napovedi[0].maxWind.toInt() == 0
                  ? "0 km/h"
                  : "do ${temp.napovedi[0].maxWind.toInt()} km/h"
              : "${temp.napovedi[0].minWind.toInt()} - ${temp.napovedi[0].maxWind.toInt()} km/h",
          secondDataIcon: WeatherIcons.wind_1));
    } else
      return Container();
  }

  Widget _card(Card card) {
    double cardWidth = 230.0;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, card.url,
                  arguments: {"${card.urlArgumentName}": card.object})
              .then((value) {
            setState(() {});
          });
        },
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [CustomColors.lightGrey, CustomColors.darkGrey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          card.mainData,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            card.unit,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: cardWidth * 0.75,
                          child: Text(
                            card.secondData != null ? "${card.secondData}" : "",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 0.5,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          card.secondDataIcon,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: cardWidth * 0.75,
                          child: Text(
                            card.thirdData != null ? "${card.thirdData}" : "",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 0.5,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          card.thirdDataIcon,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ],
                    )
                  ],
                ),
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    card.icon != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    card.icon,
                                    color: Colors.white30,
                                    size: 96,
                                  ),
                                  SizedBox(
                                    height: 48,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 45,
                              )
                            ],
                          )
                        : Container(),
                    Text(
                      card.title.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Container(
        color: Colors.transparent,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onDoubleTap: () {
                            Navigator.pushNamed(context, "/test/notifications");
                          },
                          child: CircleAvatar(
                            //backgroundColor: Colors.black12,
                            radius: 50,
                            backgroundImage:
                                AssetImage("assets/images/icon128.png"),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "MarelaApp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 24,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "by MarelaTeam",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 0.6),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  drawerRow(Icons.cloud, "Vremenska napoved", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/napovedi").then((value) {
                      setState(() {});
                    });
                  }),
                  drawerRow(Icons.wb_sunny, "Vremenske razmere", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/postaje").then((value) {
                      setState(() {});
                    });
                  }),
                  drawerRow(Icons.textsms, "Tekstovna napoved", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/napoved/tekst")
                        .then((value) {
                      setState(() {});
                    });
                  }),
                  drawerRow(WeatherIcons.water, "Vodotoki", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/vodotoki").then((value) {
                      setState(() {});
                    });
                  }),
                  drawerRow(Icons.warning, "Opozorila", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/warnings").then((value) {
                      setState(() {});
                    });
                  })
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.22),
              Column(
                children: <Widget>[
                  drawerRow(Icons.settings, "Nastavitve", () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/settings", (r) => false);
                    /* Navigator.pop(context);
                    Navigator.pushNamed(context, "/settings"); */
                  }),
                  drawerRow(Icons.library_books, "O aplikaciji", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, ("/about"));
                  }),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget drawerRow(IconData icon, String title, void onPress()) {
    return FlatButton(
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}

class Card {
  String title;
  String unit;
  String mainData;
  String secondData;
  String thirdData;
  String url;
  String urlArgumentName;

  var object;
  IconData icon;

  IconData secondDataIcon;
  IconData thirdDataIcon;

  Card(
      {this.title,
      this.unit,
      this.mainData,
      this.secondData,
      this.thirdData,
      this.object,
      this.url,
      this.urlArgumentName,
      this.secondDataIcon,
      this.thirdDataIcon,
      this.icon});
}
