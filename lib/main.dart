import 'package:flutter/material.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/screens/list_postaje.dart';
import 'package:vreme/screens/list_vodotoki.dart';
import 'package:vreme/screens/loading.dart';
import 'package:vreme/screens/postaja.dart';
import './screens/home.dart';
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
      '/vodotoki': (context) => ListOfVodotoki()
    },
    debugShowCheckedModeBanner: false,
  ));
}
