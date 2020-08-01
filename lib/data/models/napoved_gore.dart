import 'package:flutter/material.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/style/weather_icons2.dart';

class NapovedGore {
  String domainID;
  String title;
  String url;
  double geoLat;
  double geoLon;

  double altitude;
  double altitudeMin;
  double altitudeMax;

  List<NapovedGoreDan> napovedi;

  NapovedGore(
      {this.altitude,
      this.altitudeMax,
      this.altitudeMin,
      this.domainID,
      this.geoLat,
      this.geoLon,
      this.napovedi,
      this.url,
      this.title});
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

  /* temperature na različnih nadmorskih višinah */
  double temp500;
  double temp1000;
  double temp1500;
  double temp2000;
  double temp2500;
  double temp3000;
  double temp5500;

  /* hitrost (m/s) in smer vetra na različnih nadmorskih višinah */
  double windSpeed500;
  double windSpeed1000;
  double windSpeed1500;
  double windSpeed2000;
  double windSpeed2500;
  double windSpeed3000;
  double windSpeed5500;

  double windAngle500;
  double windAngle1000;
  double windAngle1500;
  double windAngle2000;
  double windAngle2500;
  double windAngle3000;
  double windAngle5500;

  String windDir500;
  String windDir1000;
  String windDir1500;
  String windDir2000;
  String windDir2500;
  String windDir3000;
  String windDir5500;

  /* vlažnost zraka na različnih nadmorskih višinah */
  double humidity500;
  double humidity1000;
  double humidity1500;
  double humidity2000;
  double humidity2500;
  double humidity3000;
  double humidity5500;

  NapovedGoreDan(
      {this.validDate,
      this.weather2500,
      this.weatherID2500,
      this.weather1500,
      this.weatherID1500,
      this.temp500,
      this.temp1000,
      this.temp1500,
      this.temp2000,
      this.temp2500,
      this.temp3000,
      this.temp5500,
      this.windSpeed500,
      this.windSpeed1000,
      this.windSpeed1500,
      this.windSpeed2000,
      this.windSpeed2500,
      this.windSpeed3000,
      this.windSpeed5500,
      this.windAngle500,
      this.windAngle1000,
      this.windAngle1500,
      this.windAngle2000,
      this.windAngle2500,
      this.windAngle3000,
      this.windAngle5500,
      this.windDir500,
      this.windDir1000,
      this.windDir1500,
      this.windDir2000,
      this.windDir2500,
      this.windDir3000,
      this.windDir5500,
      this.humidity500,
      this.humidity1000,
      this.humidity1500,
      this.humidity2000,
      this.humidity2500,
      this.humidity3000,
      this.humidity5500,
      this.validDay,
      this.snowingPoint,
      this.cloudiness1500,
      this.cloudiness2500}) {
        weather1500 = _setWeather(cloudiness1500, weatherID1500);
        weather2500 = _setWeather(cloudiness2500, weatherID2500);
      }

  IconData _setWeather(String cloudiness, String weather) {
    if (weather == null)
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
