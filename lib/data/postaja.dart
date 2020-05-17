import 'package:intl/intl.dart';

class Postaja {

  String title;
  String titleLong;
  String titleShort;

  /* geolocation */
  double geoLat;
  double geoLon;

  /* altitude */
  double altitude;

  /* sunrise, sunset */
  String sunrise;
  String sunset;
  String dayLength;

  /* time of update */
  String updateTime;

  /* temperatures */
  double temperature;
  double dewpoint; //temp rosisca
  double averageTemp;
  double minTemp;
  double maxTemp;

  /* humidity */
  double humidity;
  double averageHum;

  /* wind */
  double windAngle;
  String windDir;
  double windSpeed;
  double averageWind;
  double maxWind;

  /* preassure */
  double preassure;

  /* snow */
  double snow;

  /* rain */
  double rain;

  /* soncno obsevanje */
  double obsevanje;

  /*  */
  double vidnost;

  Postaja({
    this.title,
    this.titleLong,
    this.titleShort,
    /*  */
    this.geoLat,
    this.geoLon,
    this.altitude,
    /*  */
    this.sunrise,
    this.sunset,
    this.updateTime,
    /*  */
    this.temperature,
    this.dewpoint,
    this.averageTemp,
    this.minTemp,
    this.maxTemp,
    /*  */
    this.humidity,
    this.averageHum,
    /*  */
    this.windAngle,
    this.windDir,
    this.windSpeed,
    this.averageWind,
    this.maxWind,
    /*  */
    this.preassure,
    /*  */
    this.snow,
    this.rain,
    /*  */
    this.obsevanje,
    this.vidnost,
  }) {
    sunrise = getTimeString(sunrise);
    sunset = getTimeString(sunset);
    dayLength = getTimeLengthString();
  }

  String getTimeString(String date) {
    var t = date.split(" ");
    return t[1];
  }

  String getTimeLengthString() {
    DateTime srise = DateFormat("HH:mm").parse(sunrise).toUtc();
    DateTime sset = DateFormat("HH:mm").parse(sunset).toUtc();

    var l = sset.difference(srise);
    print(l.toString());
    var t = l.toString().split(":");
    var tt = t[1] .split(":");
    return "${t[0]}:${tt[0]}";
  }

  
}