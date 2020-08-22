import 'package:vreme/marelaWarningsAPI/dataHolders/warnings_naprava.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MarelaWarningQueries {
  final String BASE_URL = "http://83.212.82.175:8080/api/v1/";

  Future<WarningsNaprava> prijavaUporabe(WarningsNaprava naprava) async {
    var response = await http.post(
      BASE_URL + "naprave/prijava",
      headers: {'Content-type': 'application/json'},
      body: naprava.toJson(),
    );

    return response.statusCode == 200 ? naprava : null;
  }
}
