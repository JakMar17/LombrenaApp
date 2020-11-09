import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vreme/data/api/rest_to_database.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/favorites/favorites_database.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/data/shared_preferences/shared_preferences.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/static_data.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_update/in_app_update.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  RestApi restApi = new RestApi();
  AppUpdateInfo _updateInfo;

  Future<bool> loadDataFirstTime() async {
    var postaje = await restApi.fetchPostajeData();
    var vodotoki = await restApi.fetchVodotoki();
    var napoved = await restApi.fetch5DnevnaNapoved();
    var napoved3 = await restApi.fetch3DnevnaNapoved();
    var napovedPokrajine = await restApi.fetchPokrajinskaNapoved();
    restApi.fetchTextNapoved();
    restApi.fecthWarnings();

    if (postaje != null &&
        vodotoki != null &&
        napoved != null &&
        napoved3 != null &&
        napovedPokrajine != null)
      return true;
    else
      return false;
  }

  SettingsPreferences sp = SettingsPreferences();
  void doingSomething() async {
    bool data = sp.getSetting(sp.loadedData) == null
        ? false
        : sp.getSetting(sp.loadedData);
    int loadingVersion = sp.getIntSetting(sp.loadingVersion);

    if (loadingVersion == null || loadingVersion <= 0) {
      RestToDatabase rtd = RestToDatabase();
      if(loadingVersion == null || loadingVersion == -1) {
        await rtd.savingNapovediToDatabase();
      }

      //dodaj napoved gore v database
      await rtd.savingNapovedGoreToDatabase();

      sp.setIntSetting(sp.loadingVersion, 1);
    }

    if (!data) {
      print("loading data from internet");
      //load all data
      bool loaded = await loadDataFirstTime();
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
              typeOfData: TypeOfData.postaja,
              favorite: false);
          DBProvider.db.insert(d);
        }

        List<MerilnoMestoVodotok> vodotoki = restApi.getVodotoki();
        for (MerilnoMestoVodotok v in vodotoki) {
          DataModel d = DataModel(
              id: v.id,
              title: "${v.reka} (${v.merilnoMesto})",
              url: "",
              geoLat: v.geoLat.toString(),
              geoLon: v.geoLon.toString(),
              typeOfData: TypeOfData.vodotok,
              favorite: false);
          DBProvider.db.insert(d);
        }

        /* List<NapovedCategory> napoved5 = [restApi.get5dnevnaNapoved()];
        for(NapovedCategory n in napoved5) {
          DataModel d = DataModel(id: n.id,
              title: n.categoryName,
              url: n.napovedi[0].url,
              geoLat: n.geoLat.toString(),
              geoLon: n.geoLon.toString(),
              typeOfData: TypeOfData.napoved5Dnevna,
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
              typeOfData: TypeOfData.napoved3Dnevna,
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
              typeOfData: TypeOfData.napoved3Dnevna,
              favorite: false);
          DBProvider.db.insert(d);
        } */

        sp.setSetting(sp.loadedData, true);
      } else {
        checkConnection();
      }
    } else {
      print("loading data from database");
      // load favorites
      // load closests
    }
    FavoritesDatabase f = FavoritesDatabase();
    await f.getFavorites();

    /* sp.setSetting(sp.marelaWarningsIntroScreen, true); */

    checkForUpdates().then((value) {
      if(_updateInfo == null)
        Navigator.pushReplacementNamed(context, "/");

      if(_updateInfo.updateAvailable)
        showUpdateDialog();
      else
        if (
          sp.getSetting(sp.marelaWarningsIntroScreen) == null || sp.getSetting(sp.marelaWarningsIntroScreen) ||
          sp.getSetting(sp.marelaWarningsIntroScreenV2) == null || sp.getSetting(sp.marelaWarningsIntroScreenV2)
        ) {
          sp.setSetting(sp.marelaWarningsIntroScreen, false);
          sp.setSetting(sp.marelaWarningsIntroScreenV2, false);
          Navigator.pushReplacementNamed(context, "/intro/marela-warnings");
        }
        else
          Navigator.pushReplacementNamed(context, "/");
    }).catchError(() => Navigator.pushReplacementNamed(context, "/"));
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

  Future<void> checkForUpdates() async {
    _updateInfo =  await InAppUpdate.checkForUpdate().catchError((e) => print(e));
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

  Future<void> showUpdateDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Na voljo je nova posodobitev', style: TextStyle(fontFamily: "Montserrat"),),
          content: SingleChildScrollView(child: Text("Posodobitev prinaša nove funkcionalnosti in izboljšano delovanje, zato je priporočljivo, da namestitev namestite z izborom 'Namesti aplikacijo'. Posodobitev se bo izvedla v ozadju in ne bo vplivala na delovanje aplikacije.")),
          actionsPadding: EdgeInsets.all(5),
          actions: <Widget>[
            FlatButton(
              child: Text('Namesti posodobitev', style: TextStyle(fontFamily: "Montserrat"),),
              onPressed: () {
                setState(() {
                  InAppUpdate.startFlexibleUpdate().then((value) => InAppUpdate.completeFlexibleUpdate());
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/");
                });
              },
            ),
            FlatButton(
              child: Text("Posodobi kasneje", style: TextStyle(fontFamily: "Montserrat"),),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/");
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
