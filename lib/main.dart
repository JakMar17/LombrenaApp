import 'package:flutter/material.dart';
import 'package:vreme/screens/loading.dart';
import 'package:vreme/screens/postaja.dart';
import './screens/home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/loading",
    routes: {
      '/': (context) => Home(),
      '/postaja': (context) => PostajaDetail(),
      '/loading': (context) => Loading()
    },
    debugShowCheckedModeBanner: false,
  ));
}
