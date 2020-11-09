import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OnelineLoadingScreen extends StatelessWidget {
  final String text;

  OnelineLoadingScreen({this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SpinKitPouringHourglass(
          color: Colors.white,
        ),
        SizedBox(
          width: screenWidth * 0.1,
        ),
        Expanded(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400),
        ))
      ],
    );
  }
}
