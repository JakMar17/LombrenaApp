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

  /* preassure */
  double preassure;

  /* snow */
  double snow;

  /* rain */
  double rain;

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
    /*  */
    this.preassure,
    /*  */
    this.snow,
    this.rain
  });

  
}