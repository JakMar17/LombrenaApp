import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/data/menu_data.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/screens/home/drawer.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/style/weather_icons2.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static RestApi restApi = RestApi();
  List<Postaja> postaje = restApi.getAvtomatskePostaje();
  List<MerilnoMestoVodotok> vodotoki = restApi.getVodotoki();

  List<MenuItem> categoryMenu = [
    MenuItem(menuName: "Vremenske razmere", url: "/postaje"),
    MenuItem(menuName: "Vodotoki", url: '/vodotoki'),
    MenuItem(menuName: "Vremenska napoved", url: "/napovedi"),
    MenuItem(menuName: "Tekstovna napoved", url:"/napoved/tekst"),
    //MenuItem(menuName: "Zemljevid", url: "/map")
    /* MenuItem(menuName: "Sistem Burja"),
  MenuItem(menuName: "Kakovost zraka"),
  MenuItem(menuName: "Vremenska napoved"), */
  ];

  Favorites favorites;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await restApi.fetchPostajeData();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favorites = Favorites();
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
                    //showSearch(context: context, delegate: Search());
                    
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
                  end: Alignment.topLeft
                )
              ),
              child: SafeArea(
                child: CustomDrawer()
              ),
            ),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: onRefresh,
            child: CustomScrollView(
              slivers: <Widget>[
                favorites.getFavorites().length != 0
                    ? SliverToBoxAdapter(
                        child: Container(
                            color: Colors.transparent,
                            child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 15, bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Priljubljeno',
                                            style: TextStyle(
                                                fontSize: 36,
                                                letterSpacing: 1,
                                                color: Colors.white,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500),
                                          ),

                                          /* 
                                            custom menu for category
                                          */

                                          /* Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CustomIcons.option,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ) */
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 300,
                                      child: Expanded(child: favCards()),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ))),
                      )
                    : SliverToBoxAdapter(),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.transparent,
                    child:
                        /* 
                      Kategorije
                    */
                        Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Kategorije",
                            style: TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500),
                          ),
                          /* 
                                            custom menu for category
                                          */
                          /* Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CustomIcons.option,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ) */
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 10),
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
              ],
            ),
          )),
    );
  }

  Widget favCards() {
    List<dynamic> priljubljene = favorites.getFavorites();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: priljubljene.length,
      itemBuilder: (context, index) {
        dynamic temp = priljubljene[index];
        double leftPadding = 0;
        if (index == 0) leftPadding = 20;
        if (temp.type == "avtomatskaPostaja" && temp.titleShort == null)
          return Container();
        return Padding(
            padding: EdgeInsets.only(left: leftPadding),
            child:
                /* temp.type == "avtomatskaPostaja"
                ? favCard(new FavCard(
                    url: '/postaja',
                    urlArgumentName: "postaja",
                    title: temp.titleShort,
                    object: temp,
                    mainData: temp.temperature.toString(),
                    unit: "°C",
                    secondData: temp.averageWind != null
                        ? "${temp.averageWind} km/h"
                        : temp.windSpeed != null
                            ? "${temp.windSpeed} km/h"
                            : "0 km/h",
                    thirdData: temp.averageHum != null
                        ? "${temp.averageHum} %"
                        : "${temp.humidity} %",
                    secondDataIcon: WeatherIcons.wind_1,
                    //secondDataIcon: WeatherIcons2.daySunny,
                    thirdDataIcon: WeatherIcons.water_drop))
                : temp.type == "vodotok"
                    ? favCard(new FavCard(
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
                            : temp.vodostajZnacilni != null
                                ? temp.vodostajZnacilni
                                : "",
                        thirdData:
                            temp.tempVode != null ? "${temp.tempVode} °C" : "",
                        secondDataIcon: WeatherIcons.water,
                        thirdDataIcon: WeatherIcons.temperatire))
                    : Container() */
                _doFav(temp));
      },
    );
  }

  Widget _doFav(var temp) {
    switch (temp.type) {
      case "avtomatskaPostaja":
        return favCard(new FavCard(
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
      case "vodotok":
        return favCard(new FavCard(
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
      case "napoved":
        return favCard(new FavCard(
            url: '/napoved',
            urlArgumentName: 'napoved',
            object: temp,
            title: temp.napovedi[0].longTitle,
            unit: "°C",
            mainData: temp.napovedi[0].temperature != null
                ? temp.napovedi[0].temperature.toString()
                : "${(temp.napovedi[0].tempMin.toInt() + temp.napovedi[0].tempMax.toInt())/2}",
            secondData:
                "${temp.napovedi[0].minWind.toInt()} - ${temp.napovedi[0].maxWind.toInt()} km/h",
            secondDataIcon: WeatherIcons.wind_1));
      default:
        return Container();
    }
  }

  Widget favCard(FavCard card) {
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
          width: 230,
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
                        Text(
                          card.secondData != null ? "${card.secondData}" : "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200),
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
                        Text(
                          card.thirdData != null ? "${card.thirdData}" : "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200),
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
                Text(
                  card.title.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavCard {
  String title;
  String unit;
  String mainData;
  String secondData;
  String thirdData;
  String url;
  String urlArgumentName;

  var object;

  IconData secondDataIcon;
  IconData thirdDataIcon;

  FavCard(
      {this.title,
      this.unit,
      this.mainData,
      this.secondData,
      this.thirdData,
      this.object,
      this.url,
      this.urlArgumentName,
      this.secondDataIcon,
      this.thirdDataIcon});
}
