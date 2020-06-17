import 'package:flutter/material.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsPreferences _settings;

  Toggle pokaziBliznje;
  Toggle pokaziKategorije;

  @override
  void initState() {
    super.initState();
    _settings = SettingsPreferences();
    pokaziBliznje = Toggle(
        title: "Bližnje lokcaije",
        description: "Prikaži bližnje postaje in napovedi",
        isSwitched: _settings.getSetting("settings_bliznje_lokacije"),
        id: "settings_bliznje_lokacije");
    pokaziKategorije = Toggle(
        title: "Kategorije",
        description: "Vidnost menuja s kategorijami",
        isSwitched: _settings.getSetting("settings_visible_categories"),
        id: "settings_visible_categories");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/");
        return false;
      },
      child: Container(
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
            centerTitle: true,
            title: Text(
              "Nastavitve",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, "/about");
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Domači zaslon",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 28,
                        fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 15,
                ),
                toggleSettingRow(pokaziBliznje),
                SizedBox(
                  height: 5,
                ),
                toggleSettingRow(pokaziKategorije),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Postavitev",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Prilagodi postavitev domačega zaslona",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector toggleSettingRow(Toggle toggle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          toggle.switchToggle(_settings);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  toggle.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  toggle.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Switch(
              onChanged: (value) {
                setState(() {
                  toggle.switchToggle(_settings);
                });
              },
              value: toggle.isSwitched,
              activeTrackColor: CustomColors.lightGrey,
              activeColor: CustomColors.darkGrey,
            ),
          )
        ],
      ),
    );
  }
}

class Toggle {
  String title;
  String description;
  String id;
  bool isSwitched = false;

  Toggle({this.title, this.description, this.id, this.isSwitched}) {
    if (isSwitched == null) isSwitched = true;
  }

  void switchToggle(SettingsPreferences s) {
    isSwitched = !isSwitched;
    s.setSetting(id, isSwitched);
  }
}
