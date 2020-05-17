import 'package:http/http.dart';
import 'package:vreme/data/postaja.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class RestApi {

  static List<Postaja> postaje;

  List<Postaja> getAvtomatskePostaje() {return postaje;}

  Future<bool> fetchPostajeData() async {
    Response resp = await get("http://www.meteo.si/uploads/probase/www/observ/surface/text/sl/observationAms_si_latest.xml");

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    postaje = [];

    for(int i = 0; i < elements.length; i++) {
      var element = elements[i];
      print(parseDouble(""));
      Postaja p = Postaja(
        title: element.findElements("domain_title").first.text,
        titleLong: element.findElements("domain_longTitle").first.text,
        titleShort: element.findElements("domain_shortTitle").first.text,
        /*  */
        geoLat: parseDouble(element.findElements("domain_lat").first.text),
        geoLon: parseDouble(element.findElements("domain_lon").first.text),
        altitude: parseDouble(element.findElements("domain_altitude").first.text),
        /*  */
        sunrise: element.findElements("sunrise").first.text,
        sunset: element.findElements("sunset").first.text,
        updateTime: element.findElements("tsValid_issued").first.text,
        /*  */
        temperature: parseDouble(element.findElements("t").first.text),
        dewpoint: parseDouble(element.findElements("td").first.text),
        averageTemp: parseDouble(element.findElements("tavg").first.text),
        minTemp: parseDouble(element.findElements("tn").first.text),
        maxTemp: parseDouble(element.findElements("tx").first.text),
        /*  */
        humidity: parseDouble(element.findElements("rh").first.text),
        averageHum: parseDouble(element.findElements("rhavg").first.text),
        /*  */
        windAngle: parseDouble(element.findElements("dd_val").first.text),
        windDir: element.findElements("dd_shortText").first.text,
        windSpeed: parseDouble(element.findElements("ff_val_kmh").first.text),
        averageWind: parseDouble(element.findElements("ffavg_val_kmh").first.text),
        /*  */
        preassure: parseDouble(element.findElements("p").first.text),
        /*  */
        snow: parseDouble(element.findElements("snow").first.text),
        rain: parseDouble(element.findElements("tp_12h_acc").first.text),
      );
      
      postaje.add(p);
    }

    return true;
  }

  double parseDouble(String txt) {
    if (txt == null || txt == "")
      return null;
    else
      return double.parse(txt);
  }
}