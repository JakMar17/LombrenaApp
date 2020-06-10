import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOfSlovenia extends StatefulWidget {
  MapOfSlovenia({Key key}) : super(key: key);

  @override
  _MapOfSloveniaState createState() => _MapOfSloveniaState();
}

class _MapOfSloveniaState extends State<MapOfSlovenia> {
  
   Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(46.056946, 14.505751);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 9,
          ),
      );
  }
}