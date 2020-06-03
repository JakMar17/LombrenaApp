import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/style/weather_icons2.dart';

class ListOfNapovedi extends StatefulWidget {
  @override
  _ListOfNapovediState createState() => _ListOfNapovediState();
}

class _ListOfNapovediState extends State<ListOfNapovedi> {
  @override
  Widget build(BuildContext context) {
    RestApi r = RestApi();
    List<Napoved> napoved = r.get5dnevnaNapoved();
    return Scaffold(
      body: ListView.builder(
        itemCount: napoved.length,
        itemBuilder: (context, index) {
          print(napoved[index].thunderstorm);
          return Card(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Icon(napoved[index].weatherIcon),
              Icon(napoved[index].thunderstorm == "" ? null : WeatherIcons2.thunderstorm),
              Text(napoved[index].validDay)
            ],),
          ),);
        },
      ),
    );
  }
}
