import 'package:flutter/material.dart';
import 'package:vreme/data/notification_services/notification_manager.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/style/custom_icons.dart';
import './settings.dart';

class WarningRegionSelector extends StatefulWidget {
  WarningRegionSelector({Key key}) : super(key: key);

  @override
  _WarningRegionSelectorState createState() => _WarningRegionSelectorState();
}

class _WarningRegionSelectorState extends State<WarningRegionSelector> {
  List<String> regionNames = [
    "jugovzhodna Slovenija",
    "jugozahodna Slovenija",
    "osrednja Slovenija",
    "severovzhodna Slovenija",
    "severozahodna Slovenija"
  ];

  List<String> typeNames = [
    "Veter",
    "Dež",
    "Nevihte",
    "Sneg",
    "Poledica/žled",
    "Visoka temperatura",
    "Nizka temperatura",
    "Požarna ogroženost",
    "Snežni plazovi",
    "Obalni dogodek"
  ];

  List<bool> notifyRegions = [];
  List<bool> notifyType = [];
  bool warningNotifications;
  SettingsPreferences _settings;
  Toggle toggle;
  NotificationManager nm = NotificationManager();

  @override
  void initState() {
    _settings = SettingsPreferences();
    List<String> x = _settings
        .getStringListSetting("settings_warnings_notifyRegions_regions");
    for (String n in regionNames) {
      if (x != null && x.contains(n))
        notifyRegions.add(true);
      else
        notifyRegions.add(false);
    }
    x = _settings.getStringListSetting(_settings.notifyWarningType);
    for (String n in typeNames) {
      if (x != null && x.contains(n))
        notifyType.add(true);
      else
        notifyType.add(false);
    }
    super.initState();
    toggle = Toggle(
        title: "Vremenska opozorila",
        description: "Prikaži vremenska opozorila",
        id: "opozorila",
        isSwitched: _settings.getSetting("settings_warnings_notify"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue2, CustomColors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Vremenska opozorila"),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _settings.setSetting("settings_warnings_notify", toggle.isSwitched);
                  var oldRegions = _settings.getStringListSetting(_settings.notifyWarningRegions);
                  var oldTypes = _settings.getStringListSetting(_settings.notifyWarningType);

                  if(oldRegions != null && oldTypes != null)
                  for(String i in oldRegions)
                    for(String j in oldTypes)
                      nm.removeNotification("$i$j");

                  List<String> x = [];
                  for (int i = 0; i < notifyRegions.length; i++)
                    if (notifyRegions[i]) x.add(regionNames[i]);

                  _settings.setStringListSetting(
                      "settings_warnings_notifyRegions_regions", x);

                  List<String> y = [];
                  for(int i = 0; i < notifyType.length; i++)
                    if(notifyType[i]) y.add(typeNames[i]);

                  _settings.setStringListSetting(_settings.notifyWarningType, y);
                  //_settings.setSetting("settings_warnings_notify", toggle.isSwitched);

                  for(String i in x)
                    for(String j in y) {
                      var inputData = {"id": "$i $j", "show": toggle.isSwitched ? "true" : "false"};
                      nm.addNotification("$i$j", "opozorilo", inputData, true, Duration(minutes: 15));
                    }

                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      toggle.isSwitched = !toggle.isSwitched;
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
                              "Vremenska opozorila",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Prikaži vremenska opozorila",
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
                              toggle.isSwitched = !toggle.isSwitched;
                            });
                          },
                          value: toggle.isSwitched,
                          activeTrackColor: CustomColors.lightGrey,
                          activeColor: CustomColors.darkGrey,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Opozorila se zaradi omejitev sistema izvajajo zgolj, ko naprava ni v načinu varčevanja z energijo",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                ),
                SizedBox(
                  height: 20,
                ),
                toggle.isSwitched
                    ? GestureDetector(
                        onTap: () => _warningLevelDialog(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Najnižja stopnja opozorila",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Montserrat",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    minLevelWarning(),
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
                    : Container(),
                SizedBox(
                  height: 25,
                ),
                toggle.isSwitched
                    ? Text(
                        "Prikaži obvestila za pokrajine",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      )
                    : Container(),
                for (int index = 0; index < regionNames.length; index++)
                  toggle.isSwitched
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: RaisedButton(
                            color: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                notifyRegions[index] = !notifyRegions[index];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: notifyRegions[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                    size: 28,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      regionNames[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      : Container(),
                SizedBox(
                  height: 25,
                ),
                toggle.isSwitched
                    ? Text(
                        "Vrste opozoril za prikaz",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      )
                    : Container(),
                for (int index = 0; index < typeNames.length; index++)
                  toggle.isSwitched
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: RaisedButton(
                            color: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                notifyType[index] = !notifyType[index];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: notifyType[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                    size: 28,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      typeNames[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      : Container(),
                      SizedBox(height: 50,),
              ],
            ),
          ),
        ));
  }

  Future<void> _warningLevelDialog() async {
    switch (await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Najnižja stopnja opozorila"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _settings.setStringSetting(
                    "settings_warnings_notifyRegions_level", "red");
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text("Rdeče opozorilo - ukrepajte"),
            ),
            SimpleDialogOption(
              onPressed: () {
                _settings.setStringSetting(
                    "settings_warnings_notifyRegions_level", "orange");
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text("Oranžno opozorilo - bodite pripravljeni"),
            ),
            SimpleDialogOption(
              onPressed: () {
                _settings.setStringSetting(
                    "settings_warnings_notifyRegions_level", "yellow");
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text("Rumeno opozorilo - bodite pozorni"),
            )
          ],
        );
      },
    )) {
    }
  }

  String minLevelWarning() {
    String level =
        _settings.getStringSetting("settings_warnings_notifyRegions_level");
    switch (level) {
      case "yellow":
        return "Izbrano: rumeno opozorilo";
      case "orange":
        return "Izbrano: oranžno opozorilo";
      default:
        return "Izbrano: rdeče opozorilo";
    }
  }
}
