import 'package:flutter/cupertino.dart';
import 'package:vreme/screens/vremenska_napoved/list_napoved.dart';
import 'package:vreme/style/weather_icons2.dart';

class Napoved {
  String id;
  String title;
  String shortTitle;
  String longTitle;

  /* geo lat and lon */
  double geoLat;
  double geoLon;
  double altitude;
  /* sunrise & sunset */
  String sunrise;
  String sunset;
  /* date */
  String date;
  /* valid date and day */
  String validDate;
  String validDay;
  String validDayPart;
  /* temperature */
  double tempMin;
  double tempMax;
  double temperature;
  /* wind */
  double minWind;
  double maxWind;
  String wind;

  /* vremenski pojav */
  String weather;
  String weatherID;
  String cloudiness;
  String thunderstorm;

  IconData weatherIcon;

  Napoved(
      {this.id,
      this.temperature,
      this.title,
      this.shortTitle,
      this.longTitle,
      this.geoLat,
      this.geoLon,
      this.altitude,
      this.sunrise,
      this.sunset,
      this.date,
      this.validDate,
      this.validDay,
      this.validDayPart,
      this.tempMin,
      this.tempMax,
      this.minWind,
      this.maxWind,
      this.wind,
      this.weatherID,
      this.cloudiness,
      this.thunderstorm}) {
    weather = _setWeather(weatherID);
    weatherIcon = _setWeatherIcon();
  }

  String _setWeather(String x) {
    if (x == null) return null;
    switch (x) {
      case "FG":
        return "megla";
      case "DZ":
        return "rosenje";
      case "FZDZ":
        return "rosenje, ki zmrzuje";
      case "RA":
        return "dež";
      case "FZRA":
        return "dež, ki zmrzuje";
      case "RASN":
        return "dež s snegom";
      case "SN":
        return "sneg";
      case "SHRA":
        return "ploha dežja";
      case "SHRASN":
        return "ploha dežja s snegom";
      case "SHSN":
        return "snežna ploha";
      case "SHGR":
        return "ploha sodre";
      case "TS":
        return "nevihta";
      case "TSRA":
        return "nevihta z dežjem";
      case "TSRASN":
        return "nevihta z dežjem in snegom";
      case "TSSN":
        return "nevihta s sneženjem";
      case "TS":
        return "nevihta s točo";
    }
  }

  IconData _setWeatherIcon() {
    bool day = cloudiness == "jasno" ||
        cloudiness == "pretežno jasno" ||
        cloudiness == "rahlo oblačno" ||
        cloudiness == "delno oblačno";

    bool phenomen = weatherID != null && weatherID != "";

    bool thunder = thunderstorm != null && thunderstorm != "";

    /* if(thunder) {
      if(!phenomen)
        return WeatherIcons2.thunderstorm;
      else {
        
      }
    } */

    if (!phenomen) {
      switch (cloudiness) {
        case "jasno":
          return WeatherIcons2.daySunny;
        case "pretežno jasno":
          return WeatherIcons2.dayOvercast;
        case "rahlo oblačno":
          return WeatherIcons2.dayOvercast;
        case "delno oblačno":
          return WeatherIcons2.dayCloudy;
        case "zmerno oblačno":
          return WeatherIcons2.dayCloudy;
        case "pretežno oblačno":
          return WeatherIcons2.cloud;
        case "oblačno":
          return WeatherIcons2.cloudy;
        case "megla":
          return WeatherIcons2.fog;
      }
    }

    if (day) {
      switch (weatherID) {
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
    } else {
      switch (weatherID) {
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
    return null;
  }
}

class NapovedCategory {
  String categoryName;
  List<Napoved> napovedi;
  bool isFavourite = false;
  final String type = "napoved";
  String id;

  NapovedCategory({
    this.categoryName,
    this.napovedi
  }){
    id = categoryName;
  }

  Map<String, dynamic> toJson() => {
    'id': id
  };
}