import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vreme/data/models/map_marker.dart';
import 'package:vreme/style/custom_icons.dart';

class MapOfSlovenia extends StatefulWidget {
  MapOfSlovenia({Key key}) : super(key: key);

  @override
  _MapOfSloveniaState createState() => _MapOfSloveniaState();
}

class _MapOfSloveniaState extends State<MapOfSlovenia> {
  String _mapStyle;
  Completer<GoogleMapController> _controller = Completer();
  List<MapMarker> dataToShow;
  MapMarker selectedPin;
  Map<String, Marker> _mapMarkers = {};

  double pinPillPosition = -100;

  static const LatLng _center = const LatLng(46.056946, 14.505751);

  void _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(_mapStyle);
    _controller.complete(controller);

    setState(() {
      for (MapMarker m in dataToShow) {
        if (m.title == "Miren") print(m.mark);
        Marker marker = Marker(
          markerId: MarkerId(m.title),
          position: LatLng(m.lat, m.lon),
          /* infoWindow:
              InfoWindow(title: m.title, snippet: m.showData, onTap: m.onPress), */
          onTap: () {
            setState(() {
              selectedPin = m;
              pinPillPosition = 0;
            });
          },
          icon: /* BitmapDescriptor.fromAsset(m.mark), */ m.pin.pin,
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

  void setCustomMarkers() {
    for (MapMarker m in dataToShow) {
      CustomMarker c = CustomMarker(asset: m.mark);
      m.pin = c;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    dataToShow = data['markers'];
    setCustomMarkers();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 9,
            ),
            markers: _mapMarkers.values.toSet(),
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -100;
              });
            },
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
          ),
          selectedPin == null ? Container() : customPinView()
        ],
      ),
    );
  }

  Widget customPinView() {
    return AnimatedPositioned(
      bottom: pinPillPosition,
      left: 0,
      right: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: selectedPin.onPress,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
            
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [CustomColors.blue2, CustomColors.blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(50),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 7,
                    child: Row(
                      children: <Widget>[
                        selectedPin.leading == null ? Container(): Flexible(
                          flex: 2,
                          child: selectedPin.leading
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 5,
                          child: selectedPin.subtitle == null
                              ? Text(
                                  selectedPin.title,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 22,
                                      letterSpacing: 0.6,
                                      color: Colors.white),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      selectedPin.title,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 22,
                                          letterSpacing: 0.6,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      selectedPin.subtitle,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 18,
                                          letterSpacing: 0.6,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          selectedPin.mainData,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            selectedPin.mainDataUnit,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomMarker {
  BitmapDescriptor pin;
  String asset;

  CustomMarker({this.asset}) {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), asset)
        .then((onValue) {
      pin = onValue;
    });
  }
}
