import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vreme/data/models/map_marker.dart';

class MapOfSlovenia extends StatefulWidget {
  MapOfSlovenia({Key key}) : super(key: key);

  @override
  _MapOfSloveniaState createState() => _MapOfSloveniaState();
}

class _MapOfSloveniaState extends State<MapOfSlovenia> {
  String _mapStyle;
  Completer<GoogleMapController> _controller = Completer();
  List<MapMarker> dataToShow;
  Map<String, Marker> _mapMarkers = {};

  static const LatLng _center = const LatLng(46.056946, 14.505751);

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(_mapStyle);
    _controller.complete(controller);

    setState(() {
      for (MapMarker m in dataToShow) {
        Marker marker = Marker(
          markerId: MarkerId(m.title),
          position: LatLng(m.lat, m.lon),
          infoWindow:
              InfoWindow(title: m.title, snippet: m.showData, onTap: m.onPress),
        );
        _mapMarkers[marker.markerId.toString()] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    dataToShow = data['markers'];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 9,
            ),
            markers: _mapMarkers.values.toSet(),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                /* Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text("To bo moj naslov", style: TextStyle(fontFamily: "Montserrat", fontSize: 22),),
                            Icon(Icons.arrow_back, color: Colors.transparent,)
                          ],
                        ),
                      )),
                ), */
                //Padding
              ],
            ),
          )
        ],
      ),
    );
  }
}
