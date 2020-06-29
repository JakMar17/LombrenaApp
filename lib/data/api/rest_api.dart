import 'package:http/http.dart';
import 'package:vreme/data/models/opozorila.dart';
import 'package:vreme/data/shared_preferences/favorites.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/napoved_text.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/screens/vremenska_napoved/list_napoved.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class RestApi {
  static List<Postaja> postaje;
  static List<MerilnoMestoVodotok> vodotoki;
  static NapovedCategory napoved5dnevna;
  static List<NapovedCategory> napoved3dnevna;
  static List<NapovedCategory> napovedPoPokrajinah;
  static TextNapoved textNapoved;
  static List<WarningRegion> opozorilaPoRegijah;

  Favorites f = Favorites();

  List<Postaja> getAvtomatskePostaje() {
    return postaje;
  }

  List<MerilnoMestoVodotok> getVodotoki() {
    if (vodotoki == null) fetchVodotoki();
    return vodotoki;
  }

  NapovedCategory get5dnevnaNapoved() {
    if (napoved5dnevna == null) fetch5DnevnaNapoved();
    return napoved5dnevna;
  }

  List<NapovedCategory> get3dnevnaNapoved() {
    if (napoved3dnevna == null) fetch3DnevnaNapoved();
    return napoved3dnevna;
  }

  List<NapovedCategory> getPokrajinskaNapoved() {
    if (napovedPoPokrajinah == null) fetchPokrajinskaNapoved();
    return napovedPoPokrajinah;
  }

  TextNapoved getTekstovnaNapoved() {
    if(textNapoved == null) fetchTextNapoved();
    return textNapoved;
  }

  Future<bool> fetchPostajeData() async {
    Response resp = null;
    try {
      resp = await get(
          "http://www.meteo.si/uploads/probase/www/observ/surface/text/sl/observationAms_si_latest.xml");
    } on Exception catch (_) {
      return false;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    postaje = [];

    for (int i = 0; i < elements.length; i++) {
      var element = elements[i];
      Postaja p = Postaja(
          title: element.findElements("domain_title").first.text,
          titleLong: element.findElements("domain_longTitle").first.text,
          titleShort: element.findElements("domain_shortTitle").first.text,
          /*  */
          geoLat: parseDouble(element.findElements("domain_lat").first.text),
          geoLon: parseDouble(element.findElements("domain_lon").first.text),
          altitude:
              parseDouble(element.findElements("domain_altitude").first.text),
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
          averageWind:
              parseDouble(element.findElements("ffavg_val_kmh").first.text),
          maxWind:
              parseDouble(element.findElements("ffmax_val_kmh").first.text),
          /*  */
          preassure: parseDouble(element.findElements("p").first.text),
          /*  */
          snow: parseDouble(element.findElements("snow").first.text),
          rain: parseDouble(element.findElements("tp_12h_acc").first.text),
          /*  */
          obsevanje: parseDouble(element.findElements("gSunRad").first.text),
          vidnost: parseDouble(element.findElements("vis_val").first.text));

      postaje.add(p);
    }

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
    for (Postaja p in postaje) if (p.id == id) return p;
    return null;
  }

  Future<bool> fetchVodotoki() async {
    Response resp = null;
    try {
      resp =
          await get("http://www.arso.gov.si/xml/vode/hidro_podatki_zadnji.xml");
    } on Exception catch (_) {
      return false;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("postaja");

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
          reka: element.findElements("reka").isEmpty
              ? null
              : element.findElements("reka").first.text,
          merilnoMesto: element.findElements("merilno_mesto").isEmpty
              ? null
              : element.findElements("merilno_mesto").first.text,
          datum: element.findElements("datum").isEmpty
              ? null
              : element.findElements("datum").first.text,
          vodostaj: element.findElements("vodostaj").isEmpty
              ? null
              : parseDouble(element.findElements("vodostaj").first.text),
          pretok: element.findElements("pretok").isEmpty
              ? null
              : parseDouble(element.findElements("pretok").first.text),
          pretokZnacilni: element.findElements("pretok_znacilni").isEmpty
              ? null
              : element.findElements("pretok_znacilni").first.text,
          vodostajZnacilni: element.findElements("vodostaj_znacilni").isEmpty
              ? null
              : element.findElements("vodostaj_znacilni").first.text,
          tempVode: element.findElements("temp_vode").isEmpty
              ? null
              : parseDouble(element.findElements("temp_vode").first.text),
          prviPretok: element.findElements("prvi_vv_pretok").isEmpty
              ? null
              : parseDouble(element.findElements("prvi_vv_pretok").first.text),
          drugiPretok: element.findElements("drugi_vv_pretok").isEmpty
              ? null
              : parseDouble(element.findElements("drugi_vv_pretok").first.text),
          tretjiPretok: element.findElements("tretji_vv_pretok").isEmpty
              ? null
              : parseDouble(
                  element.findElements("tretji_vv_pretok").first.text),
          prviVodostaj: element.findElements("prvi_vv_vodostaj").isEmpty
              ? null
              : parseDouble(
                  element.findElements("prvi_vv_vodostaj").first.text),
          drugiVodostaj: element.findElements("drugi_vv_vodostaj").isEmpty
              ? null
              : parseDouble(
                  element.findElements("drugi_vv_vodostaj").first.text),
          tretjiVodostaj: element.findElements("tretji_vv_vodostaj").isEmpty
              ? null
              : parseDouble(
                  element.findElements("tretji_vv_vodostaj").first.text),
          znacilnaVisina: element.findElements("znacilna_visina_valov").isEmpty
              ? null
              : parseDouble(
                  element.findElements("znacilna_visina_valov").first.text),
          smerValovanja: element.findElements("smer_valovanja").isEmpty
              ? null
              : element.findElements("smer_valovanja").first.text);

      vodotoki.add(vodotok);
    }

    Comparator<MerilnoMestoVodotok> byMerilnoMesto =
        (a, b) => a.merilnoMesto.compareTo(b.merilnoMesto);
    Comparator<MerilnoMestoVodotok> byVodotok =
        (a, b) => a.reka.compareTo(b.reka);

    vodotoki.sort(byMerilnoMesto);
    vodotoki.sort(byVodotok);

    f.setFavorites(vodotoki);
    return true;
  }

  Future<bool> fetchAllData() async {
    bool postaje = await fetchPostajeData();
    bool vodotoki = await fetchVodotoki();
    if (postaje && vodotoki) return true;
  }

  MerilnoMestoVodotok getVodotok(String id) {
    for (MerilnoMestoVodotok v in vodotoki) if (v.id == id) return v;
    return null;
  }

  Future<bool> fetch5DnevnaNapoved() async {
    Response resp = null;
    try {
      resp = await get(
          "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/fcast_SLOVENIA_latest.xml");
    } on Exception catch (_) {
      return false;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    List<Napoved> l = [];

    for (int i = 0; i < elements.length; i++) {
      var element = elements[i];
      Napoved n = Napoved(
          id: element.findElements("domain_id").isEmpty
              ? null
              : element.findElements("domain_id").first.text,
          title: element.findElements("domain_title").isEmpty
              ? null
              : element.findElements("domain_title").first.text,
          shortTitle: element.findElements("domain_shortTitle").isEmpty
              ? null
              : element.findElements("domain_shortTitle").first.text,
          longTitle: element.findElements("domain_longTitle").isEmpty
              ? null
              : element.findElements("domain_longTitle").first.text,
          geoLat: element.findElements("domain_lat").isEmpty
              ? null
              : parseDouble(element.findElements("domain_lat").first.text),
          geoLon: element.findElements("domain_lon").isEmpty
              ? null
              : parseDouble(
                  element.findElements("domain_lon").first.text,
                ),
          altitude: element.findElements("domain_lon").isEmpty
              ? null
              : parseDouble(
                  element.findElements("domain_altitude").first.text,
                ),
          sunrise: element.findElements("sunrise").isEmpty
              ? null
              : element.findElements("sunrise").first.text,
          sunset: element.findElements("sunrise").isEmpty
              ? null
              : element.findElements("sunset").first.text,
          date: element.findElements("tsValid_issued").isEmpty
              ? null
              : element.findElements("tsValid_issued").first.text,
          validDate: element.findElements("valid").isEmpty
              ? null
              : element.findElements("valid").first.text,
          validDay: element.findElements("valid_day").isEmpty
              ? null
              : element.findElements("valid_day").first.text,
          tempMin: element.findElements("tn").isEmpty
              ? null
              : parseDouble(
                  element.findElements("tn").first.text,
                ),
          tempMax: element.findElements("tx").isEmpty
              ? null
              : parseDouble(
                  element.findElements("tx").first.text,
                ),
          minWind: element.findElements("ff_minimum_kmh").isEmpty
              ? null
              : parseDouble(
                  element.findElements("ff_minimum_kmh").first.text,
                ),
          maxWind: element.findElements("ff_maximum_kmh").isEmpty
              ? null
              : parseDouble(
                  element.findElements("ff_maximum_kmh").first.text,
                ),
          wind: element.findElements("dd_shortText").isEmpty
              ? null
              : element.findElements("dd_shortText").first.text,
          weatherID: element.findElements("wwsyn_icon").isEmpty
              ? null
              : element.findElements("wwsyn_icon").first.text,
          cloudiness: element.findElements("nn_shortText").isEmpty
              ? null
              : element.findElements("nn_shortText").first.text,
          thunderstorm: element.findElements("ts_icon").isEmpty
              ? null
              : element.findElements("ts_icon").first.text);

      l.add(n);
    }

    napoved5dnevna = NapovedCategory(categoryName: "Slovenija", napovedi: l);

    List<NapovedCategory> t = [];
    t.add(napoved5dnevna);
    f.setFavorites(t);
    return true;
  }

  Future<bool> fetch3DnevnaNapoved() async {
    Response resp = null;
    String baseUrl =
        "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/";

    List<String> urls = [
      "fcast_SLOVENIA_SOUTH-EAST_latest.xml",
      "fcast_SLOVENIA_SOUTH-WEST_latest.xml",
      "fcast_SLOVENIA_MIDDLE_latest.xml",
      "fcast_SLOVENIA_NORTH-EAST_latest.xml",
      "fcast_SLOVENIA_NORTH-WEST_latest.xml",
    ];

    napoved3dnevna = [];

    for (int i = 0; i < urls.length; i++) {
      try {
        resp = await get("${baseUrl}${urls[i]}");
      } on Exception catch (_) {
        return false;
      }

      dynamic rawData = utf8.decode(resp.bodyBytes);
      rawData = xml.parse(rawData);
      rawData = rawData.findAllElements("metData");

      var elements = rawData.toList();

      List<Napoved> l = [];

      for (int i = 0; i < elements.length; i++) {
        var element = elements[i];
        Napoved n = Napoved(
            id: element.findElements("domain_id").isEmpty
                ? null
                : element.findElements("domain_id").first.text,
            title: element.findElements("domain_title").isEmpty
                ? null
                : element.findElements("domain_title").first.text,
            shortTitle: element.findElements("domain_shortTitle").isEmpty
                ? null
                : element.findElements("domain_shortTitle").first.text,
            longTitle: element.findElements("domain_longTitle").isEmpty
                ? null
                : element.findElements("domain_longTitle").first.text,
            geoLat: element.findElements("domain_lat").isEmpty
                ? null
                : parseDouble(element.findElements("domain_lat").first.text),
            geoLon: element.findElements("domain_lon").isEmpty
                ? null
                : parseDouble(
                    element.findElements("domain_lon").first.text,
                  ),
            altitude: element.findElements("domain_lon").isEmpty
                ? null
                : parseDouble(
                    element.findElements("domain_altitude").first.text,
                  ),
            sunrise: element.findElements("sunrise").isEmpty
                ? null
                : element.findElements("sunrise").first.text,
            sunset: element.findElements("sunrise").isEmpty
                ? null
                : element.findElements("sunset").first.text,
            date: element.findElements("tsValid_issued").isEmpty
                ? null
                : element.findElements("tsValid_issued").first.text,
            validDate: element.findElements("valid").isEmpty
                ? null
                : element.findElements("valid").first.text,
            validDay: element.findElements("valid_day").isEmpty
                ? null
                : element.findElements("valid_day").first.text,
            tempMin: element.findElements("tn").isEmpty
                ? null
                : parseDouble(
                    element.findElements("tn").first.text,
                  ),
            tempMax: element.findElements("tx").isEmpty
                ? null
                : parseDouble(
                    element.findElements("tx").first.text,
                  ),
            minWind: element.findElements("ff_minimum_kmh").isEmpty
                ? null
                : parseDouble(
                    element.findElements("ff_minimum_kmh").first.text,
                  ),
            maxWind: element.findElements("ff_maximum_kmh").isEmpty
                ? null
                : parseDouble(
                    element.findElements("ff_maximum_kmh").first.text,
                  ),
            wind: element.findElements("dd_shortText").isEmpty
                ? null
                : element.findElements("dd_shortText").first.text,
            weatherID: element.findElements("wwsyn_icon").isEmpty
                ? null
                : element.findElements("wwsyn_icon").first.text,
            cloudiness: element.findElements("nn_shortText").isEmpty
                ? null
                : element.findElements("nn_shortText").first.text,
            thunderstorm: element.findElements("ts_icon").isEmpty
                ? null
                : element.findElements("ts_icon").first.text);

        l.add(n);
      }
      napoved3dnevna
          .add(NapovedCategory(categoryName: l[0].longTitle, napovedi: l));
    }

    f.setFavorites(napoved3dnevna);
    return true;
  }

  Future<bool> fetchPokrajinskaNapoved() async {
    Response resp = null;
    String baseUrl =
        "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/";

    List<String> urls = [
      "fcast_SI_BELOKRANJSKA_latest.xml",
      "fcast_SI_BOVSKA_latest.xml",
      "fcast_SI_DOLENJSKA_latest.xml",
      "fcast_SI_GORENJSKA_latest.xml",
      "fcast_SI_GORISKA_latest.xml",
      "fcast_SI_KOCEVSKA_latest.xml",
      "fcast_SI_KOROSKA_latest.xml",
      "fcast_SI_OSREDNJESLOVENSKA_latest.xml",
      "fcast_SI_NOTRANJSKO-KRASKA_latest.xml",
      "fcast_SI_OBALNO-KRASKA_latest.xml",
      "fcast_SI_PODRAVSKA_latest.xml",
      "fcast_SI_POMURSKA_latest.xml",
      "fcast_SI_SAVINJSKA_latest.xml",
      "fcast_SI_SPODNJEPOSAVSKA_latest.xml",
      "fcast_SI_ZGORNJESAVSKA_latest.xml"
    ];

    napovedPoPokrajinah = [];

    for (int i = 0; i < urls.length; i++) {
      try {
        resp = await get("${baseUrl}${urls[i]}");
      } on Exception catch (_) {
        return false;
      }

      dynamic rawData = utf8.decode(resp.bodyBytes);
      rawData = xml.parse(rawData);
      rawData = rawData.findAllElements("metData");

      var elements = rawData.toList();

      List<Napoved> l = [];

      for (int i = 0; i < elements.length; i++) {
        var element = elements[i];
        Napoved n = Napoved(
          id: element.findElements("domain_id").isEmpty
              ? null
              : element.findElements("domain_id").first.text,
          title: element.findElements("domain_title").isEmpty
              ? null
              : element.findElements("domain_title").first.text,
          shortTitle: element.findElements("domain_shortTitle").isEmpty
              ? null
              : element.findElements("domain_shortTitle").first.text,
          longTitle: element.findElements("domain_longTitle").isEmpty
              ? null
              : element.findElements("domain_longTitle").first.text,
          geoLat: element.findElements("domain_lat").isEmpty
              ? null
              : parseDouble(element.findElements("domain_lat").first.text),
          geoLon: element.findElements("domain_lon").isEmpty
              ? null
              : parseDouble(
                  element.findElements("domain_lon").first.text,
                ),
          altitude: element.findElements("domain_lon").isEmpty
              ? null
              : parseDouble(
                  element.findElements("domain_altitude").first.text,
                ),
          sunrise: element.findElements("sunrise").isEmpty
              ? null
              : element.findElements("sunrise").first.text,
          sunset: element.findElements("sunrise").isEmpty
              ? null
              : element.findElements("sunset").first.text,
          date: element.findElements("tsValid_issued").isEmpty
              ? null
              : element.findElements("tsValid_issued").first.text,
          validDate: element.findElements("valid").isEmpty
              ? null
              : element.findElements("valid").first.text,
          validDay: element.findElements("valid_day").isEmpty
              ? null
              : element.findElements("valid_day").first.text,
          tempMin: element.findElements("tn").isEmpty
              ? null
              : parseDouble(
                  element.findElements("tn").first.text,
                ),
          tempMax: element.findElements("tx").isEmpty
              ? null
              : parseDouble(
                  element.findElements("tx").first.text,
                ),
          minWind: element.findElements("ff_minimum_kmh").isEmpty
              ? null
              : parseDouble(
                  element.findElements("ff_minimum_kmh").first.text,
                ),
          maxWind: element.findElements("ff_maximum_kmh").isEmpty
              ? null
              : parseDouble(
                  element.findElements("ff_maximum_kmh").first.text,
                ),
          wind: element.findElements("dd_shortText").isEmpty
              ? null
              : element.findElements("dd_shortText").first.text,
          weatherID: element.findElements("wwsyn_icon").isEmpty
              ? null
              : element.findElements("wwsyn_icon").first.text,
          cloudiness: element.findElements("nn_shortText").isEmpty
              ? null
              : element.findElements("nn_shortText").first.text,
          thunderstorm: element.findElements("ts_icon").isEmpty
              ? null
              : element.findElements("ts_icon").first.text,
          temperature: element.findElements("t").isEmpty
              ? null
              : parseDouble(element.findElements("t").first.text),
          validDayPart: element.findElements("valid_daypart").isEmpty
              ? null
              : element.findElements("valid_daypart").first.text,
        );

        l.add(n);
      }
      napovedPoPokrajinah
          .add(NapovedCategory(categoryName: l[0].longTitle, napovedi: l));
    }

    f.setFavorites(napovedPoPokrajinah);
    return true;
  }

  Future<bool> fetchTextNapoved() async {
    Response resp = null;

    try {
      resp = await get(
          "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/fcast_si_text.xml");
    } on Exception catch (_) {
      return false;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("section");

    var elements = rawData.toList();
    List<String> arguments = [];
    List<String> text = [];

    for (var x in elements) {
      String t = x.attributes[0].toString();
      var tt = t.split("'");
      arguments.add(tt[1]);
      text.add(x.findElements("para").isEmpty
          ? ""
          : x.findElements("para").first.text);
    }

    textNapoved = TextNapoved();

    for (int i = 0; i < arguments.length; i++) {
      switch (arguments[i]) {
        case "fcast_SLOVENIA_d1":
          textNapoved.napovedSlo1 = text[i];
          break;
        case "fcast_SLOVENIA_d2":
          textNapoved.napovedSlo2 = text[i];
          break;
        case "fcast_SI_NEIGHBOURS_d1":
          textNapoved.napovedSos1 = text[i];
          break;
        case "fcast_SI_NEIGHBOURS_d2":
          textNapoved.napovedSos2 = text[i];
          break;
        case "fcast_EUROPE_d1":
          textNapoved.slikaEu1 = text[i];
          break;
        case "fcast_EUROPE_d2":
          textNapoved.slikaEu2 = text[i];
          break;
        case "fcast_SLOVENIA_d3-d5":
          textNapoved.obeti = text[i];
          break;
        case "warning_SLOVENIA":
          textNapoved.opozorilo = text[i];
          break;
        case "fcast_summary_SLOVENIA_d1-d2":
          textNapoved.povzetek = text[i];
          break;
      }
    }

    return true;
  }

  List<WarningRegion> getWarnings() {
    if(opozorilaPoRegijah == null) fecthWarnings();
    return opozorilaPoRegijah;
  }

  Future<bool> fecthWarnings() async {
    Response resp = null;
    String baseUrl =
        "https://meteo.arso.gov.si/uploads/probase/www/warning/text/sl/";

    List<String> urls = [
      "warning_SLOVENIA_SOUTH-EAST_latest_CAP.xml",
      "warning_SLOVENIA_SOUTH-WEST_latest_CAP.xml",
      "warning_SLOVENIA_MIDDLE_latest_CAP.xml",
      "warning_SLOVENIA_NORTH-EAST_latest_CAP.xml",
      "warning_SLOVENIA_NORTH-WEST_latest_CAP.xml",
    ];

    List<String> names = [
      "jugovzhodna Slovenija",
      "jugozahodna Slovenija",
      "osrednja Slovenija",
      "severovzhodna Slovenija",
      "severozahodna Slovenija"
    ];

    opozorilaPoRegijah = [];

    for (int i = 0; i < urls.length; i++) {
      try {
        resp = await get("${baseUrl}${urls[i]}");
      } on Exception catch (_) {
        return false;
      }

      dynamic rawData = utf8.decode(resp.bodyBytes);
      rawData = xml.parse(rawData);
      rawData = rawData.findAllElements("info");

      var elements = rawData.toList();

      WarningRegion wr = WarningRegion(
        region: names[i]
      );

      for(int j = 0; j < elements.length; j++) {
        var element = elements[j];
        if(element.findElements("language").first.text != "sl")
          continue;
        Warning w = Warning(
          event: element.findElements("event").first.text,
          parameterValue: element.findElements("parameter").first.findElements("value").first.text,
          sOnset: element.findElements("onset").first.text,
          sExpires: element.findElements("expires").first.text
        );
        wr.addWarning(w);
      }

      opozorilaPoRegijah.add(wr);
    }

    return true;
  }
}
