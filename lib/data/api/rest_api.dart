import 'package:http/http.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class RestApi {

  static List<Postaja> postaje;
  static List<MerilnoMestoVodotok> vodotoki;

  List<Postaja> getAvtomatskePostaje() {return postaje;}
  List<MerilnoMestoVodotok> getVodotoki() {
    if(vodotoki == null)
      fetchVodotoki();
    return vodotoki;
  }

  Future<bool> fetchPostajeData() async {
    Response resp = null;
    try {
      resp = await get("http://www.meteo.si/uploads/probase/www/observ/surface/text/sl/observationAms_si_latest.xml");
    } on Exception catch (_) {
      return null;
    }

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
        maxWind: parseDouble(element.findElements("ffmax_val_kmh").first.text),
        /*  */
        preassure: parseDouble(element.findElements("p").first.text),
        /*  */
        snow: parseDouble(element.findElements("snow").first.text),
        rain: parseDouble(element.findElements("tp_12h_acc").first.text),
        /*  */
        obsevanje: parseDouble(element.findElements("gSunRad").first.text),
        vidnost: parseDouble(element.findElements("vis_val").first.text)
      );
      
      postaje.add(p);
    }

    Favorites f = Favorites();
    f.setFavorites(postaje);
    return true;
  }

  double parseDouble(String txt) {
    if (txt == null || txt == "")
      return null;
    else
      return double.parse(txt);
  }

  Postaja getPostaja(String id) {
    for (Postaja p in postaje)
      if(p.id == id)
        return p;
    return null;
  }

  Future<bool> fetchVodotoki () async {
    Response resp = null;
    try {
      resp = await get("http://www.arso.gov.si/xml/vode/hidro_podatki_zadnji.xml");
    } on Exception catch(_) {
      return null;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("postaja");

    print(rawData);

    var elements = rawData.toList();

    vodotoki = [];

    for (int i = 0; i < elements.length; i++) {
      var element = elements[i];

      /* getting  sifra from xml argument */
      var s = element.attributes[0].toString().split("=");
      s = s[1].split('"');
      String sifra = s[1];

      /* getting geoLat and geoLon from xml argument */
      s = element.attributes[1].toString().split("=");
      s = s[1].split('"');
      double geoLon = parseDouble(s[1]);
      s = element.attributes[2].toString().split("=");
      s = s[1].split('"');
      double geoLat = parseDouble(s[1]);
      
      MerilnoMestoVodotok vodotok = MerilnoMestoVodotok(
        sifra: sifra,
        geoLat: geoLat,
        geoLon: geoLon,
        reka: element.findElements("reka").isEmpty ? null : element.findElements("reka").first.text,
        merilnoMesto: element.findElements("merilno_mesto").isEmpty ? null : element.findElements("merilno_mesto").first.text,
        datum: element.findElements("datum").isEmpty ? null : element.findElements("datum").first.text,
        vodostaj: element.findElements("vodostaj").isEmpty ? null : parseDouble(element.findElements("vodostaj").first.text),
        pretok: element.findElements("pretok").isEmpty ? null : parseDouble(element.findElements("pretok").first.text),
        pretokZnacilni: element.findElements("pretok_znacilni").isEmpty ? null : element.findElements("pretok_znacilni").first.text,
        vodostajZnacilni: element.findElements("vodostaj_znacilni").isEmpty ? null : element.findElements("vodostaj_znacilni").first.text,
        tempVode: element.findElements("temp_vode").isEmpty ? null : parseDouble(element.findElements("temp_vode").first.text),
        prviPretok: element.findElements("prvi_vv_pretok").isEmpty ? null : parseDouble(element.findElements("prvi_vv_pretok").first.text),
        drugiPretok: element.findElements("drugi_vv_pretok").isEmpty ? null : parseDouble(element.findElements("drugi_vv_pretok").first.text),
        tretjiPretok: element.findElements("tretji_vv_pretok").isEmpty ? null : parseDouble(element.findElements("tretji_vv_pretok").first.text),
        prviVodostaj: element.findElements("prvi_vv_vodostaj").isEmpty ? null : parseDouble(element.findElements("prvi_vv_vodostaj").first.text),
        drugiVodostaj: element.findElements("drugi_vv_vodostaj").isEmpty ? null : parseDouble(element.findElements("drugi_vv_vodostaj").first.text),
        tretjiVodostaj: element.findElements("tretji_vv_vodostaj").isEmpty ? null : parseDouble(element.findElements("tretji_vv_vodostaj").first.text),
        znacilnaVisina: element.findElements("znacilna_visina_valov").isEmpty ? null : parseDouble(element.findElements("znacilna_visina_valov").first.text),
        smerValovanja: element.findElements("smer_valovanja").isEmpty ? null : element.findElements("smer_valovanja").first.text
      );

      vodotoki.add(vodotok);
    }

    Comparator<MerilnoMestoVodotok> byMerilnoMesto = (a, b) => a.merilnoMesto.compareTo(b.merilnoMesto);
    Comparator<MerilnoMestoVodotok> byVodotok = (a, b) => a.reka.compareTo(b.reka);

    vodotoki.sort(byMerilnoMesto);
    vodotoki.sort(byVodotok);

    Favorites f = Favorites();
    f.setFavorites(vodotoki);
    return true;
  }

  Future<bool> fetchAllData() async {
    bool postaje = await fetchPostajeData();
    bool vodotoki = await fetchVodotoki();
    if (postaje && vodotoki)
      return true;
  }

}