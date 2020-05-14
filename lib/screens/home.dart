import 'package:flutter/material.dart';
import '../style/custom_icons.dart';
import '../data/dummyData.dart';
import 'dart:math';
import '../data/menu_data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage_postaje = avtomatskePostaje.length - 1.0;
  var currentPage_burja = burja.length - 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.blue,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text("Vreme"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ))
            ],
          ),
          drawer: Drawer(
            child: Container(
              color: CustomColors.darkBlue,
              child: SafeArea(
                child: Text("drawer"),
              ),
            ),
          ),

          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                    color: Colors.transparent,
                    child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Priljubljeno',
                                    style: TextStyle(
                                        fontSize: 36,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                        fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        CustomIcons.option,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemCount: 15,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        FavCard(),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ))),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.transparent,
                  child: /* 
                    Kategorije
                  */
                      Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Kategorije",
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CustomIcons.option,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                      child: FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  categoryMenu[index].menuName,
                                  style:
                                      TextStyle(
                                        color: Colors.white, 
                                        fontSize: 20,
                                        letterSpacing: 0.6,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: categoryMenu.length,
                ),
              )
            ],
          )),
    );
  }
}

class FavCard extends StatelessWidget {
  var data;

  //FavCard({this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        width: 250,

        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/postaja");
          },
                  child: Container(
            color: CustomColors.darkBlue,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "24",
                            style: TextStyle(
                              color: Colors.white, fontSize: 84,
                              fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "°C",
                              style: TextStyle(
                                color: Colors.white, fontSize: 28,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.compare_arrows,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "1,4 m/s",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 0.5,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "60 %",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 0.5,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      )
                    ],
                  ),
                  Text(
                    "Letališče Jožeta Pučnika Ljubljana",
                    style: TextStyle(color: Colors.white, fontSize: 28,
                    fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
