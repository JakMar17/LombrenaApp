import 'package:flutter/material.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/style/custom_icons.dart';
import './settings.dart';

class WarningRegionSelector extends StatefulWidget {
  WarningRegionSelector({Key key}) : super(key: key);

  @override
  _WarningRegionSelectorState createState() => _WarningRegionSelectorState();
}

class _WarningRegionSelectorState extends State<WarningRegionSelector> {
  List<String> names = [
    "jugovzhodna Slovenija",
    "jugozahodna Slovenija",
    "osrednja Slovenija",
    "severovzhodna Slovenija",
    "severozahodna Slovenija"
  ];

  List<bool> notify = [];

  SettingsPreferences _settings;

  @override
  void initState() {
    _settings = SettingsPreferences();
    List<String> x =
        _settings.getStringListSetting("settings_warnings_notify_regions");
    for (String n in names) {
      if (x != null && x.contains(n))
        notify.add(true);
      else
        notify.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Map data
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
          title: Text("Izbira pokrajin"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                List<String> x = [];
                for(int i = 0; i < notify.length; i++)
                  if(notify[i])
                    x.add(names[i]);
                
                _settings.setStringListSetting("settings_warnings_notify_regions", x);

                Navigator.pop(context);
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: RaisedButton(
                color: Colors.transparent,
                onPressed: () {
                  setState(() {
                    notify[index] = !notify[index];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color:
                            notify[index] ? Colors.white : Colors.transparent,
                        size: 28,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                                                  child: Text(
                          names[index],
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
              ),
            );
          },
        ),
      ),
    );
  }
}
