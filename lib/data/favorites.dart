import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:vreme/data/postaja.dart';

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
          print(temp);
          Postaja p = Postaja(title: temp);
          _favorites.add(p);
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
        }
      }
    }
  }

}