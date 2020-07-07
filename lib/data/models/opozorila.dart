import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vreme/style/weather_icons2.dart';

class Warning {
  String title;
  int level;
  String colorString;
  String description;
  IconData icon;
  Color color;
  DateTime onset;
  DateTime expires;

  Warning({
    String event,
    String parameterValue,
    String sOnset,
    String sExpires
  }) {

    //onset = DateTime.parse(sOnset, true);
    onset = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(sOnset, true);
    onset.toLocal();

    List<String> x = event.split(" - ");
    List<String> y = parameterValue.split("; ");
    title = x[0];
    level = int.parse(y[0]);
    colorString = y[1];
    description = x[1];
    
    _setColor();
    icon = _setIcon();
  }

  void _setColor() {
    switch(colorString) {
      case "green":
        color = Colors.green;
        break;
      case "yellow":
        color = Colors.yellow;
        break;
      case "orange":
        color = Colors.orange[400];
        break;
      case "red":
        color = Colors.redAccent[400];
    }
  }

  IconData _setIcon() {
    switch(title.toLowerCase()) {
      case "veter":
        return WeatherIcons2.warning_wind;
      case "dež":
        return WeatherIcons2.warning_rain;
      case "nevihte":
        return WeatherIcons2.warning_thunderstorm;
      case "sneg":
        return WeatherIcons2.warning_snow;
      case "poledica/žled":
        return WeatherIcons2.warning_ice;
      case "visoka temperatura":
        return WeatherIcons2.warning_highTemp;
      case "nizka temperatura":
        return WeatherIcons2.warning_lowTemp;
      case "požarna ogroženost":
        return WeatherIcons2.warning_fire;
      case "snežni plazovi":
        return WeatherIcons2.warning_avalanche;
      case "obalni dogodek":
        return WeatherIcons2.warning_coast;
    }
  }
}

class WarningRegion {
  String id;
  String region;
  List<Warning> warnings;
  String date;

  WarningRegion({
    this.date,
    this.id,
    this.region,
    this.warnings
  }) {
    if(warnings == null)
      warnings = [];
  }

  void addWarning(Warning warning) {

    if(warning.onset.difference(DateTime.now()).inDays != 0)
      return;

    for(Warning w in warnings)
      if(w.title == warning.title)
        if(warning.level > w.level) {
          warnings.remove(w);
          break;
        }
        else
          return;
    
    warnings.add(warning);
  }
}