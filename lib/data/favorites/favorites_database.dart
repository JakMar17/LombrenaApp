import 'package:flutter/foundation.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/type_of_data.dart';

class FavoritesDatabase {
  static dynamic favorites;
  RestApi r = RestApi();

  getFavoritesFromDB() async {
    favorites = await DBProvider.db.getFavorites();
    var x = await DBProvider.db.getAllData();
    List<dynamic> temp = [];

    for (dynamic x in favorites) {
      if (x.typeOfData == TypeOfData.postaja) {
        Postaja p = await r.fetchPostaja(x.url);
        p.isFavourite = true;
        temp.add(p);
      } else if (x.typeOfData.toLowerCase().contains("napoved")) {
        var t = await r.fetchNapoved(x.url, x.typeOfData);
        if (t != null) {
          t.isFavourite = true;
          temp.add(t);
        }
      } /* else if (x.typeOfData == TypeOfData.napoved3Dnevna) {
        var t = await r.fetchNapoved3(x.url);
        if (t != null) {
          t.isFavourite = true;
          temp.add(t);
        }
      } else if (x.typeOfData == TypeOfData.pokrajinskaNapoved) {
        var t = await r.fetchNapovedPokrajina(x.url);
        if (t != null) {
          t.isFavourite = true;
          temp.add(t);
        }
      }  */else if (x.typeOfData == TypeOfData.vodotok) {
        MerilnoMestoVodotok m = r.getVodotok(x.id);
        if (m == null) {
          await r.fetchVodotoki();
          m = r.getVodotok(x.id);
        }
        m.isFavourite = true;
        temp.add(m);
      }
    }

    if(temp.length != 0)
      favorites = temp;
    else
      favorites = null;
    
    return favorites;
  }

  getFavorites() async {
    if (favorites == null) await getFavoritesFromDB();
    return favorites;
  }

  addToFavorite(var x) async {
    if (x.typeOfData == TypeOfData.postaja) {
      DataModel d = DataModel(
          id: x.id,
          title: x.titleLong,
          url: x.url,
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.postaja,
          favorite: true);
      await DBProvider.db.updateData(d);
    } else if (x.typeOfData == TypeOfData.vodotok) {
      DataModel d = DataModel(
          id: x.id,
          title: x.reka,
          url: "",
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.vodotok,
          favorite: true);
      await DBProvider.db.updateData(d);
    } else if (x.typeOfData.toLowerCase().contains("napoved")){
      DataModel d = DataModel(
          id: x.id,
          title: x.categoryName,
          url: x.napovedi[0].url,
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: x.typeOfData,
          favorite: true);
          await DBProvider.db.updateData(d);
    }

    if(favorites == null)
      favorites = [];
    FavoritesDatabase.favorites.add(x);
  }

  removeFromFavorite(var x) async {
    if (x.typeOfData == TypeOfData.postaja) {
      DataModel d = DataModel(
          id: x.id,
          title: x.titleLong,
          url: x.url,
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.postaja,
          favorite: false);
      await DBProvider.db.insert(d);
    } else if (x.typeOfData == TypeOfData.napoved5Dnevna) {
      DataModel d = DataModel(
          id: x.id,
          title: x.categoryName,
          url: x.napovedi[0].url,
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.napoved5Dnevna,
          favorite: false);
      await DBProvider.db.insert(d);
    } else if (x.typeOfData == TypeOfData.napoved3Dnevna) {
      DataModel d = DataModel(
          id: x.id,
          title: x.categoryName,
          url: x.napovedi[0].url,
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.napoved3Dnevna,
          favorite: false);
      await DBProvider.db.insert(d);
    } else if (x.typeOfData == TypeOfData.pokrajinskaNapoved) {
      DataModel d = DataModel(
          id: x.id,
          title: x.categoryName,
          url: x.napovedi[0].url,
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.pokrajinskaNapoved,
          favorite: false);
      await DBProvider.db.insert(d);
    } else if (x.typeOfData == TypeOfData.vodotok) {
      DataModel d = DataModel(
          id: x.id,
          title: x.reka,
          url: "",
          geoLat: x.geoLat.toString(),
          geoLon: x.geoLon.toString(),
          typeOfData: TypeOfData.vodotok,
          favorite: false);
      await DBProvider.db.insert(d);
    }
    favorites.remove(x);
  }
}
