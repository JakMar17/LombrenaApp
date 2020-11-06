import 'dart:convert';

import 'package:http/http.dart';
import 'package:vreme/v2/application_properties/constants.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/MarelaWarningsRegisterWrapper.dart';

class MarelaWarningsServices {
  static const String _BASE_URL = Constants.API_BASE_URL + 'warnings/';
  static final Map<String, String> _headers = {'Content-Type':'application/json; charset=utf-8'};

  static Future<int> saveMarelaWarningsToServer(MarelaWarningsRegisterWrapper wrapper) async {
    var resp;
    try {
      var body = wrapper.toJson();
      resp = await post(_BASE_URL + 'prijava', body: jsonEncode(body), headers: _headers);
      return resp.statusCode;
    } catch(e) {
      return null;
    }
  }
}