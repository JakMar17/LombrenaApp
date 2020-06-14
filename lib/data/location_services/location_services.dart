import 'package:location/location.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/postaja.dart';
import 'dart:math';

class LocationServices {
  static Location location = new Location();
  static RestApi _restApi = RestApi();

  static bool _serviceEnabled;
  static PermissionStatus _permissionStatus;
  static LocationData _locationData;

  Future<LocationData> getLocation() async {
    if (_serviceEnabled == null)
      _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return null;
    }

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) return null;
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  List<dynamic> getClosestData() {
    if (_locationData == null) getLocation();

    List<dynamic> list = [];

    list.add(closestElement(_restApi.getAvtomatskePostaje()));
    list.add(closestElement(_restApi.getPokrajinskaNapoved()));
    list.add(closestElement(_restApi.get3dnevnaNapoved()));
    list.add(closestElement(_restApi.getVodotoki()));
    
    return list;
  }

  dynamic closestElement(List<dynamic> list) {
    var closest;
    double rad;

    for (var l in list) {
      if (closest == null) {
        closest = l;
        rad = sqrt(pow((l.geoLat - _locationData.latitude), 2) +
            pow(l.geoLon - _locationData.longitude, 2));
      } else {
        var x = sqrt(pow((l.geoLat - _locationData.latitude), 2) +
            pow(l.geoLon - _locationData.longitude, 2));
        if (rad > x) {
          closest = l;
          rad = x;
        }
      }
    }

    return closest;
  }
}
