import 'package:flutter/material.dart';

class MapMarker {
  String title;
  String subtitle;
  String mainData;
  String mainDataUnit;
  double lat;
  double lon;
  var mark;
  Widget leading;
  var closing;
  String url;
  var onPress;
  var object;

  MapMarker({
    this.title,
    this.subtitle,
    this.closing,
    this.leading,
    this.mark,
    this.object,
    this.onPress,
    this.url,
    this.mainData,
    this.mainDataUnit,
    this.lat,
    this.lon
  });

}