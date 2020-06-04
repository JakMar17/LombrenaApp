import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';

class Favorites {

  static List<dynamic> _favorites;
  static SharedPreferences sharedPreferences;

  Future<bool> setPreferences() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  List<Object> getFavorites() {
    if(_favorites == null) {
      //get from shared preferences
      _favorites = [];
      try{
        //_favorites = json.decode(sharedPreferences.getString("favorites"));
        var json = jsonDecode(sharedPreferences.getString("favorites"));
        for (int i = 0; i < json.length; i++) {
          var temp = json[i]["id"];
          var t;
          switch(json[i]["type"]) {
            case "avtomatskaPostaja":
              t = Postaja(title: temp);
              break;
            case "vodotok":
              t = MerilnoMestoVodotok(sifra: temp);
              break;
            default:
              t = Postaja(title: temp);

          }
          print(temp);
          _favorites.add(t);
        }
        
      } catch(Exception) {
        print(Exception);
      }
    }

    return _favorites;
  }

  void addToFavorites(dynamic x) {
    if(_favorites == null)
      getFavorites();

    bool wasDeleted = false;
    for(int i = 0; i < _favorites.length; i++) {
      dynamic t = _favorites[i];
      if(t.id == x.id) {
        _favorites.removeAt(i);
        wasDeleted = true;
        break;
      }
    }

    if(!wasDeleted)
      _favorites.add(x);

    //save to shared preferences
    print(_favorites);
    String json = jsonEncode(_favorites);
    print(json);
    sharedPreferences.setString("favorites", json);
  }


  void setFavorites(List<dynamic> x) {
    if (_favorites == null)
      getFavorites();

    for(int i = 0; i < _favorites.length; i++) {
      var f = _favorites[i];
      for(int j = 0; j < x.length; j++) {
        var t = x[j];
        if(f.id == t.id) {
          t.isFavourite = true;
          _favorites[i] = x[j];
          break;
        }
      }
    }
  }

}