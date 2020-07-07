import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/data/shared_preferences/shared_preferences.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/shared_preferences/favorites.dart';
import 'package:vreme/data/static_data.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  RestApi restApi = new RestApi();
  Favorites favorites = Favorites();

  Future<bool> loadData() async {
    bool postaje = await restApi.fetchPostajeData();
    bool vodotoki = await restApi.fetchVodotoki();
    bool napoved = await restApi.fetch5DnevnaNapoved();
    bool napoved3 = await restApi.fetch3DnevnaNapoved();
    bool napovedPokrajine = await restApi.fetchPokrajinskaNapoved();
    restApi.fetchTextNapoved();
    restApi.fecthWarnings();

    if (postaje && vodotoki && napoved && napoved3 && napovedPokrajine)
      return true;
    else
      return false;

    /* if (postaje && vodotoki && napoved && napoved3 && napovedPokrajine)
      Navigator.pushReplacementNamed(context, "/");
    else {
      String errorMessage;
      //check for internet connection
      try {
        final result = await InternetAddress.lookup(StaticData.BASE_URL);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
          //internet is availbale, unknown error
          errorMessage = "Neznana napaka, poskusite resetirati aplikacijo";
      } on SocketException catch (_) {
        //internet is not available, network error
        errorMessage = "Preverite povezavo z internetom in poskusite znova";
      }
      showErrorDialog(errorMessage);
    } */
  }

  void doingSomething() async {
    SettingsPreferences sp = SettingsPreferences();
    bool data = sp.getSetting(sp.loadedData);
    print(data);
    //checkConnection();

    if (!data) {
      print("loading data");
      //load all data
      bool loaded = await loadData();
      if (loaded) {
        //store data
        List<Postaja> postaje = restApi.getAvtomatskePostaje();
        for (Postaja p in postaje) {
          DataModel d = DataModel(
              id: p.id,
              title: p.titleLong,
              url: p.url,
              geoLat: p.geoLat.toString(),
              geoLon: p.geoLon.toString(),
              type: TypeOfData.postaja,
              favorite: false);
            DBProvider.db.insert(d);
            print(d.url);
        }

        List<MerilnoMestoVodotok> vodotoki = restApi.getVodotoki();
        for(MerilnoMestoVodotok v in vodotoki) {
          DataModel d = DataModel(id: v.id,
              title: v.reka,
              url: "",
              geoLat: v.geoLat.toString(),
              geoLon: v.geoLon.toString(),
              type: TypeOfData.vodotok,
              favorite: false);
          DBProvider.db.insert(d);
        }

        List<NapovedCategory> napoved5 = [restApi.get5dnevnaNapoved()];
        for(NapovedCategory n in napoved5) {
          DataModel d = DataModel(id: n.id,
              title: n.categoryName,
              url: n.napovedi[0].url,
              geoLat: n.geoLat.toString(),
              geoLon: n.geoLon.toString(),
              type: TypeOfData.napoved5Dnevna,
              favorite: false);
          DBProvider.db.insert(d);
        }

        List<NapovedCategory> napoved3 = restApi.get3dnevnaNapoved();
        for(NapovedCategory n in napoved3) {
          DataModel d = DataModel(id: n.id,
              title: n.categoryName,
              url: n.napovedi[0].url,
              geoLat: n.geoLat.toString(),
              geoLon: n.geoLon.toString(),
              type: TypeOfData.napoved3Dnevna,
              favorite: false);
          DBProvider.db.insert(d);
        }

        List<NapovedCategory> pokrajinskaNapoved = restApi.getPokrajinskaNapoved();
        for(NapovedCategory n in pokrajinskaNapoved) {
          DataModel d = DataModel(id: n.id,
              title: n.categoryName,
              url: n.napovedi[0].url,
              geoLat: n.geoLat.toString(),
              geoLon: n.geoLon.toString(),
              type: TypeOfData.napoved3Dnevna,
              favorite: false);
          DBProvider.db.insert(d);
        }

        //sp.setSetting(sp.loadedData, true);

      } else {
        checkConnection();
      }
    } else {
      // load favorites
      // load closests
    }
  }

  void checkConnection() async {
    String errorMessage;
    try {
      final result = await InternetAddress.lookup(StaticData.BASE_URL);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        //internet is availbale, unknown error
        errorMessage = "Neznana napaka, poskusite resetirati aplikacijo";
    } on SocketException catch (_) {
      //internet is not available, network error
      errorMessage = "Preverite povezavo z internetom in poskusite znova";
    }
    showErrorDialog(errorMessage);
  }

  @override
  void initState() {
    Preferences p = Preferences();
    doingSomething();
    super.initState();
  }

  Future<void> showErrorDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Napaka pri pridobivanju podatkov'),
          content: SingleChildScrollView(child: Text(error)),
          actionsPadding: EdgeInsets.all(5),
          actions: <Widget>[
            FlatButton(
              child: Text('Poskusi ponovno'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  doingSomething();
                });
              },
            ),
            FlatButton(
              child: Text("Zapri aplikacijo"),
              onPressed: () {
                SystemNavigator.pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue2, CustomColors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(height: 28),
                  Text(
                    "Nalaganje",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: <Widget>[
                    Text(
                      "2020",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "MarelaTeam",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
