import 'package:flutter/widgets.dart';

class DetailCard {
  String title;
  var mainMeasure;
  String unit;

  var secondData;
  var thirdData;

  IconData icon;

  DetailCard(
      {this.title,
      this.mainMeasure,
      this.unit,
      this.secondData,
      this.thirdData,
      this.icon
      });
}