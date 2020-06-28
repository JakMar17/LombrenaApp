import 'package:flutter/material.dart';
import 'package:vreme/style/weather_icons.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          //backgroundColor: Colors.black12,
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/icon128.png"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "MarelaApp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 24,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "by MarelaTeam",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 0.6),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  buttonRow(Icons.cloud, "Vremenska napoved", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/napovedi");
                  }),
                  buttonRow(Icons.wb_sunny, "Vremenske razmere", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/postaje");
                  }),
                  buttonRow(Icons.textsms, "Tekstovna napoved", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/napoved/tekst");
                  }),
                  buttonRow(WeatherIcons.water, "Vodotoki", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/vodotoki");
                  }),
                  buttonRow(Icons.warning, "Opozorila", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/warnings");
                  })
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.22),
              Column(
                children: <Widget>[
                  buttonRow(Icons.settings, "Nastavitve", () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/settings", (r) => false);
                    /* Navigator.pop(context);
                    Navigator.pushNamed(context, "/settings"); */
                  }),
                  buttonRow(Icons.library_books, "O aplikaciji", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, ("/about"));
                  }),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget buttonRow(IconData icon, String title, void onPress()) {
    return FlatButton(
      onPressed: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}
