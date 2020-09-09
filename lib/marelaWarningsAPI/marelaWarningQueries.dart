import 'package:vreme/marelaWarningsAPI/dataHolders/warning_prijava.dart';
import 'package:vreme/marelaWarningsAPI/dataHolders/warnings_naprava.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MarelaWarningQueries {
  final String BASE_URL = "http://83.212.82.175:8080/api/v1/";

  static WarningsNaprava naprava;

  Future<WarningsNaprava> prijavaUporabe(WarningsNaprava naprava) async {

    Map<String, String> headers = {'Content-Type':'application/json; charset=utf-8'};

    var response = await http.post(
      BASE_URL + "naprave/prijava",
      headers: headers,
      body: json.encode(naprava.toJson()),
    );

    MarelaWarningQueries.naprava = naprava;
    return response.statusCode == 200 ? naprava : null;
  }

  Future<WarningPrijava> getMarelaWarningsNaroceno() async {
    var response = await http.get(
      BASE_URL + "naprave/info?fcmId=${naprava.fcmId}",
      headers: {'Content-type': 'application/json; charset=utf-8'},
    );

    WarningPrijava prijava =
        //WarningPrijava.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        WarningPrijava.fromJson(json.decode(response.body));

    if (prijava.stopnja != null)
      switch (prijava.stopnja.stopnja) {
        case 1:
          prijava.stopnja.tipStopnje = "rumena";
          break;
        case 2:
          prijava.stopnja.tipStopnje = "oranžna";
          break;
        default:
          prijava.stopnja.tipStopnje = "rdeča";
      }
    else {
      prijava.stopnja = Stopnja(stopnja: 3, tipStopnje: "rdeča");
    }

    if(prijava.pokrajine == null)
      prijava.pokrajine = [];
    if(prijava.tipi == null)
      prijava.tipi = [];

    return prijava;
  }

  Future<bool> setMarelaWarningsNaroceno(WarningPrijava prijava) async {
    prijava.naprava = Naprava(fcmId: naprava.fcmId);

    switch (prijava.stopnja.tipStopnje) {
      case "rumena":
        prijava.stopnja.stopnja = 1;
        break;
      case "oranžna":
        prijava.stopnja.stopnja = 2;
        break;
      default:
        prijava.stopnja.stopnja = 3;
    }

    var b = prijava.toJson();

    var response = await http.put(BASE_URL + "posodobi",
        headers: {'Content-type': 'application/json; charset=utf-8'},
        body: json.encode(prijava.toJson()));

    return response.statusCode == 200 ? true : false;
  }
}
