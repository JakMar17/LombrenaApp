import 'package:http/http.dart';
import 'package:vreme/v2/application_properties/constants.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/MarelaWarningsRegisterWrapper.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/StopnjaOpozorilaWrapper.dart';

import '../components/opozorilaV2/wrappers/OpozoriloWrapper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpozorilaServices {
  static final _BASE_URL =  Constants.API_BASE_URL + 'opozorila/';
  static final Map<String, String> _headers = {'Content-Type':'application/json; charset=utf-8'};

  Future<OpozorilaWrapper> getOpozorila() async {
    var resp;
    try {
      resp = await get(
        _BASE_URL + 'aktivna',
        headers: _headers
      );

      if(resp.statusCode == 200) {
        var y = json.decode(resp.body);
        var x = OpozorilaWrapper.fromJson(y);
        return x;
      }
        /* return OpozorilaWrapper.fromJson(json.decode(resp.body)); */
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getPokrajineOpozoril() async {
    var resp;
    try {
      resp = await get(
        Constants.API_BASE_URL + 'pokrajine/',
        headers: _headers
      );

      if(resp.statusCode == 200) {
        var y = json.decode(resp.body).map((data) => Pokrajine.fromJson(data)).toList(); 
        return y;

      }
      else
        return null;
    } catch(e) {
      return null;
    }
  }

  static Future<dynamic> getStopnjeOpozoril() async {
    var resp;
    try {
      resp = await get(
        _BASE_URL + 'stopnje',
        headers: _headers
      );

      if(resp.statusCode == 200) {
        var y = json.decode(resp.body).map((data) => StopnjaOpozorilaWrapper.fromJson(data)).toList(); 
        return y;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  static Future<dynamic> getTipiOpozoril() async {
    var resp;
    try {
      resp = await get(
        _BASE_URL + 'tipi',
        headers: _headers
      );

      if(resp.statusCode == 200) {
        var y = json.decode(resp.body).map((data) => OpozorilaPoTipih.fromJson(data)).toList(); 
        return y;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  static Future<int> saveMarelaWarningsToServer(MarelaWarningsRegisterWrapper wrapper) async {
    await null;
    return 200;
  }
}