import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/fetching_data.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/favorites/favorites_database.dart';
import 'package:vreme/data/models/napoved_gore.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';

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

  void loadData(Map data) async {
    DataModel m = data['data_model'];
    if (m != null) {
      FetchingData f = FetchingData();
      napoved = await f.fetchNapovedGore(m.url);
      napoved.isFavourite = m.favorite;
    } else {
      napoved = data["napoved"];
    }

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
  }

  @override
  Widget build(BuildContext context) {
    if (!dataLoaded) {
      Map data = {};
      data = ModalRoute.of(context).settings.arguments;
      loadData(data);
    }

    setTrenutnaNapoved();

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
            SliverToBoxAdapter(child: SizedBox(height: 50,),),
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
            )
          ],
        ),
      ),
    );
  }

  DropdownButton _nadmorskaVisinaDropdown() {
    return DropdownButton<String>(
      value: selectedNadmorskaVisina,
      iconSize: 0,
      dropdownColor: CustomColors.lightGrey,
      elevation: 0,
      style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedNadmorskaVisina = newValue;
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
}

class _NadmorskaVisinaSelector {
  int value;
  String name;

  _NadmorskaVisinaSelector({this.value, this.name});
}
