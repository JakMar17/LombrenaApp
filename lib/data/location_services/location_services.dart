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

  Future<List<dynamic>> getClosestData() async {
    if (_locationData == null) return null;

    List<dynamic> list = [];

    var postaje = _restApi.getAvtomatskePostaje();
    if(postaje == null) {
      await _restApi.fetchPostajeData();
      postaje = _restApi.getAvtomatskePostaje();
    }

    var pNapoved = _restApi.getPokrajinskaNapoved();
    if(pNapoved == null) {
      await _restApi.fetchPokrajinskaNapoved();
      pNapoved = _restApi.getPokrajinskaNapoved();
    }

    var napoved3 = _restApi.get3dnevnaNapoved();
    if(napoved3 == null) {
      await _restApi.fetch3DnevnaNapoved();
      napoved3 = _restApi.get3dnevnaNapoved();
    }

    var vodotoki = _restApi.getVodotoki();
    if(vodotoki == null) {
      await _restApi.fetchVodotoki();
      vodotoki = _restApi.getVodotoki();
    }

    list.add(closestElement(postaje));
    list.add(closestElement(pNapoved));
    list.add(closestElement(napoved3));
    list.add(closestElement(vodotoki));
    
    return list;
  }

  dynamic closestElement(List<dynamic> list) {

    if(list == null)
      return;

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
