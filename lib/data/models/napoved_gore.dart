import 'package:flutter/material.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/style/weather_icons2.dart';

class NapovedGore {
  String domainID;
  String id;
  String title;
  String longTitle;
  String url;
  double geoLat;
  double geoLon;
  bool isFavourite = false;

  double altitude;
  double altitudeMin;
  double altitudeMax;

  List<NapovedGoreDan> napovedi;
  String typeOfData = TypeOfData.napovedGore;

  NapovedGore(
      {this.altitude,
      this.altitudeMax,
      this.altitudeMin,
      this.domainID,
      this.geoLat,
      this.geoLon,
      this.napovedi,
      this.url,
      this.title}) {
    id = domainID;
    longTitle = title;
  }
}

class NapovedGoreDan {
  String validDate;
  String validDay;
  String cloudiness2500;
  String cloudiness1500;
  String typeOfData = TypeOfData.napovedGore;

  IconData weather2500;
  String weatherID2500;

  IconData weather1500;
  String weatherID1500;

  double snowingPoint;

  List<NapovedGoreDanVisina> napovediPoVisinah = [];

  NapovedGoreDan(
      {this.validDate,
      this.weather2500,
      this.weatherID2500,
      this.weather1500,
      this.weatherID1500,
      this.validDay,
      this.snowingPoint,
      this.cloudiness1500,
      this.cloudiness2500}) {
    weather1500 = _setWeather(cloudiness1500, weatherID1500);
    weather2500 = _setWeather(cloudiness2500, weatherID2500);
  }

  NapovedGoreDanVisina getNapovedNaVisini(int visina) {
    for(NapovedGoreDanVisina n in napovediPoVisinah)
      if(n.visina == visina)
        return n;
    return napovediPoVisinah[1];
  }

  IconData _setWeather(String cloudiness, String weather) {
    if (weather == null || weather.length == 0)
      switch (cloudiness) {
        case "clear":
          return WeatherIcons2.daySunny;
        case "mostClear":
          return WeatherIcons2.daySunny;
        case "slightCloudy":
          return WeatherIcons2.dayOvercast;
        case "partCloudy":
          return WeatherIcons2.dayOvercast;
        case "modCloudy":
          return WeatherIcons2.dayOvercast;
        case "prevCloudy":
          return WeatherIcons2.cloud;
        case "overcast":
          return WeatherIcons2.cloudy;
        case "FG":
          return WeatherIcons2.fog;
      }
    else if (cloudiness == "clear" ||
        cloudiness == "mostClear" ||
        cloudiness == "slightCloudy" ||
        cloudiness == "partCloudy")
      switch (weather) {
        case "FG":
          return WeatherIcons2.fog;
        case "DZ":
          return WeatherIcons2.dayLightRain;
        case "FZDZ":
          return WeatherIcons2.dayLightRain;
        case "RA":
          return WeatherIcons2.dayShowers;
        case "FZRA":
          return WeatherIcons2.dayShowers;
        case "RASN":
          return WeatherIcons2.dayMixed;
        case "SN":
          return WeatherIcons2.daySnow;
        case "SHRA":
          return WeatherIcons2.dayStrongRain;
        case "SHRASN":
          return WeatherIcons2.dayStrongSnow;
        case "SHSN":
          return WeatherIcons2.dayStrongSnow;
        case "SHGR":
          return WeatherIcons2.dayStrongSnow;
        case "TS":
          return WeatherIcons2.dayThunderstorm;
        case "TSRA":
          return WeatherIcons2.dayThunderstormRain;
        case "TSRASN":
          return WeatherIcons2.dayThunderstormRainSnow;
        case "TSSN":
          return WeatherIcons2.dayThunderstormSnow;
        case "TS":
          return WeatherIcons2.dayThunderstormSnow;
      }
    else
      switch (weather) {
        case "FG":
          return WeatherIcons2.fog;
        case "DZ":
          return WeatherIcons2.lightRain;
        case "FZDZ":
          return WeatherIcons2.lightRain;
        case "RA":
          return WeatherIcons2.showers;
        case "FZRA":
          return WeatherIcons2.showers;
        case "RASN":
          return WeatherIcons2.mixed;
        case "SN":
          return WeatherIcons2.snow;
        case "SHRA":
          return WeatherIcons2.strongRain;
        case "SHRASN":
          return WeatherIcons2.strongSnow;
        case "SHSN":
          return WeatherIcons2.strongSnow;
        case "SHGR":
          return WeatherIcons2.strongSnow;
        case "TS":
          return WeatherIcons2.thunderstorm;
        case "TSRA":
          return WeatherIcons2.thunderstormRain;
        case "TSRASN":
          return WeatherIcons2.thunderstormRainSnow;
        case "TSSN":
          return WeatherIcons2.thunderstormSnow;
        case "TS":
          return WeatherIcons2.thunderstormSnow;
      }
  }
}

class NapovedGoreDanVisina {
  double visina;
  double temp;
  double windSpeed;
  double windAngle;
  String windDir;
  double humidity;

  NapovedGoreDanVisina(
      {this.humidity,
      this.temp,
      this.visina,
      this.windAngle,
      this.windDir,
      this.windSpeed});
}
