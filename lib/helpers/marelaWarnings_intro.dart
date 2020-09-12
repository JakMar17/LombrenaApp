import 'package:flutter/material.dart';
import 'package:vreme/style/custom_icons.dart';

class MarelaWarningIntro extends StatelessWidget {
  const MarelaWarningIntro({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/icon128.png"),
                          radius: 65,
                        ),
                        Icon(
                          Icons.notifications,
                          color: Colors.white70,
                          size: 45,
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "MarelaWarnings",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontSize: 28,
                              fontWeight: FontWeight.w300),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "BETA",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Column(children: <Widget>[
                    paragraph("MarelaWarnings je nov sistem obveščanja pred nevarnimi vremenskimi pojavi v vaši okolici.", FontStyle.normal),
                    paragraph("Prilagajate lahko stopnjo, tip in pokrajino obvestila.", FontStyle.normal),
                    SizedBox(height: 20,),
                    paragraph("Nastavitve obveščanja lahko vedno spremenite v nastavitvah, pod zavihkom MarelaWarnings", FontStyle.italic),
                  ],),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.transparent,
                      child: Text(
                        "Mogoče kasneje",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300),
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(context, "/"),
                    ),
                    RaisedButton(
                      color: Colors.transparent,
                      child: Text(
                        "Nastavi opozorila",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300),
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(context, "/settings/marelaWarnings"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding paragraph(String text, FontStyle fontStyle) {
    return Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontStyle: fontStyle,
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w300),
                ),
              );
  }
}
