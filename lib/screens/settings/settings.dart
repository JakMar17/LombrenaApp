import 'package:flutter/material.dart';
import 'package:vreme/data/notification_services/notification_manager.dart';
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
  Toggle pokaziOpozorila;

  List<Toggle> warningRegions;

  @override
  void initState() {
    super.initState();
    _settings = SettingsPreferences();
    pokaziBliznje = Toggle(
        title: "Bližnje lokacije",
        description: "Prikaži bližnje postaje in napovedi",
        isSwitched: _settings.getSetting("settings_bliznje_lokacije"),
        id: "settings_bliznje_lokacije");
    pokaziKategorije = Toggle(
        title: "Kategorije",
        description: "Vidnost menuja s kategorijami",
        isSwitched: _settings.getSetting("settings_visible_categories"),
        id: "settings_visible_categories");
    warningRegions = [
      Toggle(title: "osrednja Slovenija"),
      Toggle(title: "jugovzhodna Slovenija"),
    ];
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
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
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
                  height: 10,
                ),
                toggleSettingRow(pokaziKategorije),
                /*SizedBox(
                  height: 10,
                ),
                buttonRow("Postavitev", "Prilagodi postavitev domačega zaslona",
                    () {}), */
                /*  */
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Obvestila",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontSize: 28,
                            fontWeight: FontWeight.w300)),
                    IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),
                        onPressed: _showAlertDialog)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                buttonRow("Upravljajte z obvestili",
                    "Upravljajte z lokacijami, o katerih želite biti obveščeni",
                    () {
                  Navigator.pushNamed(
                      context, "/settings/customization/notifications");
                }),
                SizedBox(
                  height: 25,
                ),
                Text("Vremenska opozorila",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 28,
                        fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 15,
                ),
                buttonRow("Prikaži vremenska opozorila",
                    "Obvestilo, ko ARSO izda opozorilo", () {
                  Navigator.pushNamed(context, '/settings/warnings/regions');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleRowOnChange(Toggle toggle) {
    setState(() {
      toggle.switchToggle(_settings);
      if (toggle.title == "Prikaži vremenska opozorila" && toggle.isSwitched)
        _showAlertDialog();
    });
  }

  GestureDetector toggleSettingRow(Toggle toggle) {
    return GestureDetector(
      onTap: () {
        toggleRowOnChange(toggle);
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
                toggleRowOnChange(toggle);
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

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                "Mobilna opozorila",
                style: TextStyle(fontFamily: "Montserrat"),
              ),
              content: Text(
                "Opozorila se zaradi omejitev sistema izvajajo zgolj, ko naprava ni v načinu varčevanja z energijo",
                style: TextStyle(fontFamily: "Montserrat"),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Zapri",
                    style: TextStyle(fontFamily: "Montserrat"),
                  ),
                )
              ],
            ));
  }

  GestureDetector buttonRow(String title, String description, void onTap()) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
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
    );
  }

  bool isChecked = false;
  Future<void> _displayDialog(List<Toggle> regions) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Izbira pokrajin'),
            content: Column(
              children: <Widget>[
                for (Toggle t in regions)
                  Row(
                    children: <Widget>[
                      Text(t.title),
                      Checkbox(
                        value: t.isSwitched,
                        onChanged: (val) {
                          setState(() {
                            t.switchToggle(null);
                          });
                        },
                      )
                    ],
                  )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Shrani'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
    if (s != null) s.setSetting(id, isSwitched);
  }
}
