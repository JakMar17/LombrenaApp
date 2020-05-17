import 'package:flutter/material.dart';
import 'package:vreme/data/rest_api.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  RestApi restApi = new RestApi();

  void goToHome() async {
    bool done = await restApi.fetchPostajeData();
    if(done)
      Navigator.pushReplacementNamed(context, "/");
  }

  @override
  void initState() {
    goToHome();
    super.initState();
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