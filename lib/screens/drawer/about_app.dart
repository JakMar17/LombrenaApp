import 'package:flutter/material.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.darkBlue, CustomColors.darkBlue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "O aplikaciji",
            style: TextStyle(fontFamily: "Montserrat"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.library_books,
                color: Colors.white,
              ),
              color: Colors.white,
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.mail_outline),
              onPressed: () async {
                const mail = "mailto:marela.app@outlook.com";
                if (await canLaunch(mail)) {
                  await launch(mail);
                } else {
                  throw 'Could not launch $mail';
                }
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/icon128.png"),
                  radius: 60,
                )),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "MarelaApp",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 38,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "1.0.0",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Container(),
            SizedBox(
              height: 50,
            ),
            Column(
              children: <Widget>[
                Text(
                  "2020",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w200),
                ),
                Text(
                  "Vse pravice pridržane",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "MarelaTeam",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 28,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
