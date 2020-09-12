import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/opozorila.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'dart:math' as math;

class ListOfWarnings extends StatefulWidget {
  ListOfWarnings({Key key}) : super(key: key);

  @override
  _ListOfWarningsState createState() => _ListOfWarningsState();
}

class _ListOfWarningsState extends State<ListOfWarnings> {
  RestApi _restApi = RestApi();
  List<WarningRegion> regions;
  bool loadedData = false;
  bool niIzdanihOpozoril = true;

  void loadData() async {
    regions = _restApi.getWarnings();
    if (regions == null || regions.length == 0) {
      await _restApi.fecthWarnings();
      regions = _restApi.getWarnings();
    }

    for (WarningRegion r in regions)
      for (Warning w in r.warnings) if (w.level != 1) niIzdanihOpozoril = false;

    setState(() {
      loadedData = true;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

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
        body: loadedData ? _buildWithData() : LoadingData(),
      ),
    );
  }

  CustomScrollView _buildWithData() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 300,
          backgroundColor: CustomColors.blue,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Izdana vremenska opozorila",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 20),
        ),
        SliverToBoxAdapter(
          child: niIzdanihOpozoril
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: CustomColors.lightGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Text(
                              "Trenutno ni aktivnih izdanih opozoril",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Transform.rotate(angle: -30 * math.pi / 180,child: Icon(Icons.notifications, color: Colors.white60, size: 40,)),
                      )
                    ],
                  ),
                )
              : Container(),
        ),
        SliverList(
          delegate: SliverChildListDelegate(_buildList()),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 30),
        )
      ],
    );
  }

  List _buildList() {
    List<Widget> list = [];

    for (int i = 0; i < regions.length; i++) {
      list.add(Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/warning",
                  arguments: {"region": regions[i]});
            },
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        regions[i].region,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontSize: 24,
                            fontWeight: FontWeight.w300),
                      ),
                      //_setImage(vodotokiPoRekah[i].vodotoki[j])
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      for (Warning w in regions[i].warnings)
                        w.colorString != "green"
                            ? Container(
                                padding: EdgeInsets.only(left: 5),
                                child: CircleAvatar(
                                  child: Icon(
                                    w.icon,
                                    color: w.color,
                                  ),
                                  backgroundColor: CustomColors.lightGrey,
                                ))
                            : Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return list;
  }
}
