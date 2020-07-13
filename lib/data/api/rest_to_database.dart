import 'dart:convert';

import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart' as xml;

class RestToDatabase {
  Future<void> savingNapovediToDatabase() async {
    Response resp = null;

    List<String> urls = [
      "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/fcast_si-region_latest.xml",
      "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/fcast_si-subregion_latest.xml",
      "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/forecast_adria_latest.xml",
      "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/forecast_eu-capital_latest.xml",
      "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/forecast_eu_latest.xml"
    ];

    List<String> types = [
      TypeOfData.napoved3Dnevna,
      TypeOfData.pokrajinskaNapoved,
      TypeOfData.napovedJadran,
      TypeOfData.napovedEvropa,
      TypeOfData.napovedEvropa
    ];

    //saving 5 dnevna napoved za Slovenijo
    DataModel d = DataModel(
        id: "SLOVENIA_",
        title: "Slovenija",
        url:
            "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/fcast_SLOVENIA_latest.xml",
        typeOfData: TypeOfData.napoved5Dnevna,
        favorite: false);
    DBProvider.db.insert(d);

    for (int i = 0; i < urls.length; i++) {
      //get responde for url
      Response resp;
      try {
        resp = await get(urls[i]);
      } on Exception catch (_) {
        continue;
      }

      //set detail url
      String detailURL;
      if (types[i] == TypeOfData.napovedEvropa || types[i] == TypeOfData.napovedJadran)
        detailURL =
            "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/forecast_";
      else
        detailURL =
            "https://meteo.arso.gov.si/uploads/probase/www/fproduct/text/sl/fcast_";

      dynamic rawData = utf8.decode(resp.bodyBytes);
      rawData = xml.parse(rawData);
      rawData = rawData.findAllElements("metData");

      var elements = rawData.toList();

      List<String> exists = [];

      for (var e in elements) {
        var id = e.findElements("domain_meteosiId").first.text;
        d = DataModel(
            id: id,
            typeOfData: types[i],
            title: e.findElements("domain_longTitle").first.text,
            geoLat: e.findElements("domain_lat").first.text,
            geoLon: e.findElements("domain_lon").first.text,
            favorite: false,
            url: "$detailURL${id}latest.xml");
        if (!exists.contains(d.id)) {
          exists.add(d.id);
          await DBProvider.db.insert(d);
        }
      }
    }
  }
}
