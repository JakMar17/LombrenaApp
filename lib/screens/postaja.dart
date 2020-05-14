import 'package:flutter/material.dart';
import 'package:vreme/style/custom_icons.dart';

class PostajaDetail extends StatefulWidget {
  @override
  _PostajaDetailState createState() => _PostajaDetailState();
}

class _PostajaDetailState extends State<PostajaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blue,
      appBar: AppBar(
        elevation: 0,
        title: Text("Letališče Jožeta Pučnika Ljubljana"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.star_border),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top:40, left: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("24",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 128,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w200,
                            letterSpacing: 2
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("°C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w100,
                              letterSpacing: 2
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("16°C",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2
                        )
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text("32°C",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2
                        )
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}