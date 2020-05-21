import 'package:flutter/material.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/data/postaja.dart';
import 'package:vreme/data/rest_api.dart';
import '../style/custom_icons.dart';
import '../data/dummyData.dart';
import 'dart:math';
import '../data/menu_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var currentPage_postaje = avtomatskePostaje.length - 1.0;
  var currentPage_burja = burja.length - 1.0;

  static RestApi restApi = RestApi();
  List<Postaja> postaje = restApi.getAvtomatskePostaje();

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
    print("cisti zacetek");
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
            title: Text("Vreme"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ))
            ],
          ),
          drawer: Drawer(
            child: Container(
              color: CustomColors.darkBlue,
              child: SafeArea(
                child: Text("drawer"),
              ),
            ),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: onRefresh,
            child: CustomScrollView(
              slivers: <Widget>[
                favorites.getFavorites().length != 0 ? SliverToBoxAdapter(
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CustomIcons.option,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 300,
                                child: Expanded(
                                  child: favCards()
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ))),
                ) : SliverToBoxAdapter(),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CustomIcons.option,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          )
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
                            Navigator
                              .pushNamed(context, categoryMenu[index].url)
                              .then((value) {setState(() {
                                
                              });});
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
    List<Object> priljubljene = favorites.getFavorites();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: priljubljene.length,
      itemBuilder: (context, index) {
        double paddingLeft = index == 0 ? 20 : 0;

        return Padding(
          padding: EdgeInsets.only(left: paddingLeft),
          //child: FavCard(postaja: postaje[index], refresh: () {initState();} ),
          child: favCard(priljubljene[index]),
        );
      },
    );
  }

  Widget favCard(Postaja postaja) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator
          .pushNamed(context, "/postaja",
              arguments: {'postaja': postaja})
          .then((value) {
            setState(() {
              
            });
          });
        },
        child: Container(
          width: 230,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                      colors: [CustomColors.lightGrey, CustomColors.darkGrey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(15)
            ),
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
                          postaja.temperature.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "°C",
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
                        Icon(
                          Icons.compare_arrows,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          postaja.averageWind != null
                              ? "${postaja.averageWind} km/h"
                              : postaja.windSpeed != null
                                  ? "${postaja.windSpeed} km/h"
                                  : "0 km/h",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          postaja.averageHum != null
                              ? "${postaja.averageHum} %"
                              : "${postaja.humidity} %",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  postaja.titleShort,
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

class FavCard extends StatelessWidget {
  var data;
  final Postaja postaja;
  final void refresh;
  FavCard({this.postaja, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator
          .pushNamed(context, "/postaja",
              arguments: {'postaja': postaja})
          .then((value) {
            refresh;
          });
        },
        child: Container(
          width: 230,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                      colors: [CustomColors.lightGrey, CustomColors.darkGrey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(15)
            ),
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
                          postaja.temperature.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "°C",
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
                        Icon(
                          Icons.compare_arrows,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          postaja.averageWind != null
                              ? "${postaja.averageWind} km/h"
                              : postaja.windSpeed != null
                                  ? "${postaja.windSpeed} km/h"
                                  : "0 km/h",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          postaja.averageHum != null
                              ? "${postaja.averageHum} %"
                              : "${postaja.humidity} %",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  postaja.titleShort,
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
