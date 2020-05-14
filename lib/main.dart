import 'package:flutter/material.dart';
import 'package:vreme/screens/postaja.dart';
import './screens/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    routes: {
      //'/': (context) => Home(),
      '/postaja': (context) => PostajaDetail()
    },
    debugShowCheckedModeBanner: false,
  ));
}
