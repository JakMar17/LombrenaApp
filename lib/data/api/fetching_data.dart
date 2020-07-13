import 'package:http/http.dart';

import 'package:http/http.dart';
import 'package:vreme/data/api/fetching_data.dart';
import 'package:vreme/data/models/opozorila.dart';
import 'package:vreme/data/shared_preferences/favorites.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/napoved_text.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/screens/vremenska_napoved/list_napoved.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class FetchingData {
  double parseDouble(String txt) {
    if (txt == null || txt == "")
      return null;
    else
      return double.parse(txt);
  }

  Future<Postaja> fetchPostaja(String url) async {
    Response resp = null;
    try {
      resp = await get(url);
    } on Exception catch (_) {
      return null;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    var element = elements[0];
    Postaja p = Postaja(
        id: element.findElements("domain_meteosiId").first.text,
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
        maxWind: parseDouble(element.findElements("ffmax_val_kmh").first.text),
        /*  */
        preassure: parseDouble(element.findElements("p").first.text),
        /*  */
        snow: parseDouble(element.findElements("snow").first.text),
        rain: parseDouble(element.findElements("tp_12h_acc").first.text),
        /*  */
        obsevanje: parseDouble(element.findElements("gSunRad").first.text),
        vidnost: parseDouble(element.findElements("vis_val").first.text));

    return p;
  }

  Future<NapovedCategory> fetchNapoved3(String url) async {
    Response resp = null;
    try {
      resp = await get(url);
    } on Exception catch (_) {
      return null;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    List<Napoved> l = [];

    for (int i = 0; i < elements.length; i++) {
      var element = elements[i];
      Napoved n = Napoved(
          typeOfData: TypeOfData.napoved3Dnevna,
          url: url,
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

    return NapovedCategory(
        id: l[0].id,
        categoryName: l[0].longTitle,
        napovedi: l,
        typeOfData: TypeOfData.napoved3Dnevna);
  }

  Future<NapovedCategory> fetchNapovedPokrajina(String url) async {
    Response resp = null;
    try {
      resp = await get(url);
    } on Exception catch (_) {
      return null;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    List<Napoved> l = [];

    for (int i = 0; i < elements.length; i++) {
      var element = elements[i];
      Napoved n = Napoved(
        typeOfData: TypeOfData.pokrajinskaNapoved,
        url: url,
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

    return NapovedCategory(
        id: l[0].id,
        categoryName: l[0].longTitle,
        napovedi: l,
        typeOfData: TypeOfData.pokrajinskaNapoved);
  }

  Future<NapovedCategory> fetchNapoved(String url, String typeOfData) async {
    Response resp = null;
    try {
      resp = await get(url);
    } on Exception catch (_) {
      return null;
    }

    dynamic rawData = utf8.decode(resp.bodyBytes);
    rawData = xml.parse(rawData);
    rawData = rawData.findAllElements("metData");

    var elements = rawData.toList();

    List<Napoved> l = [];

    for (int i = 0; i < elements.length; i++) {
      var element = elements[i];
      Napoved n = Napoved(
          typeOfData: TypeOfData.napoved3Dnevna,
          url: url,
          id: element.findElements("domain_meteosiId").isEmpty
              ? null
              : element.findElements("domain_meteosiId").first.text,
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
          temperature: element.findElements("t").isEmpty
              ? null
              : parseDouble(
                  element.findElements("t").first.text,
                ),
          windSpeed: element.findElements("ff_val").isEmpty
              ? null
              : parseDouble(
                  element.findElements("ff_val").first.text,
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

    return NapovedCategory(
        id: l[0].id,
        categoryName: l[0].longTitle,
        napovedi: l,
        typeOfData: typeOfData);
  }
}
