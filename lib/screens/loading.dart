import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vreme/data/favorites.dart';
import 'package:vreme/data/rest_api.dart';
import 'package:vreme/data/static_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  RestApi restApi = new RestApi();
  Favorites favorites = Favorites();

  void goToHome() async {
    //bool fav = await favorites.setPreferences();
    bool postaje = await restApi.fetchPostajeData();
    if(postaje != null)
      Navigator.pushReplacementNamed(context, "/");
    else {
      String errorMessage;
      //check for internet connection
      try {
        final result = await InternetAddress.lookup(StaticData.BASE_URL);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
          //internet is availbale, unknown error
          errorMessage = "Neznana napaka, poskusite resetirati aplikacijo";
      } on SocketException catch(_) {
        //internet is not available, network error
        errorMessage = "Preverite povezavo z internetom in poskusite znova";
      }
      showErrorDialog(errorMessage);
    }
  }

  @override
  void initState() {
    goToHome();
    super.initState();
  }

  Future<void> showErrorDialog(String error) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Napaka pri pridobivanju podatkov'),
        content: SingleChildScrollView(
          child: Text(error)
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Poskusi ponovno'),
            onPressed: () {
              setState(() {
                goToHome();
              });
            },
          ),
          FlatButton(
            child: Text("Zapri aplikacijo"),
            onPressed: () {
              SystemNavigator.pop();
            },
          )
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColors.blue2, CustomColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,  
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(height: 28),
                  Text("Nalaganje",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w300
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text("2020 Jakob Marušič",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w300
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}