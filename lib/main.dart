import 'package:flutter/material.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/screens/custom_search.dart';
import 'package:vreme/screens/home/home.dart';
import 'package:vreme/screens/home/loading.dart';
import 'package:vreme/screens/vodotoki/list_vodotoki.dart';
import 'package:vreme/screens/vodotoki/vodotok_detail.dart';
import 'package:vreme/screens/vremenske_razmere/list_postaje.dart';
import 'package:vreme/screens/vremenske_razmere/postaja.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Favorites favorites = Favorites();
  print(await favorites.setPreferences());

  runApp(MaterialApp(
    initialRoute: "/loading",
    routes: {
      '/': (context) => Home(),
      '/postaja': (context) => PostajaDetail(),
      '/loading': (context) => Loading(),
      '/postaje': (context) => ListOfPostaje(),
      '/vodotoki': (context) => ListOfVodotoki(),
      '/vodotok': (context) => VodotokDetail(),
      '/search': (context) => CustomSearch()
    },
    debugShowCheckedModeBanner: false,
  ));
}
