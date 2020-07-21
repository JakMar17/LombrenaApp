import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {
  const LoadingData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Nalaganje podatkov",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w300,
                  fontSize: 24),
            )
          ],
        ),
    );
  }
}