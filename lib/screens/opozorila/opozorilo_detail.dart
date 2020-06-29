import 'package:flutter/material.dart';
import 'package:vreme/data/models/opozorila.dart';
import 'package:vreme/style/custom_icons.dart';

class WarningDetail extends StatefulWidget {
  @override
  _WarningDetailState createState() => _WarningDetailState();
}

class _WarningDetailState extends State<WarningDetail> {
  WarningRegion _warning;

  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    _warning = data["region"];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "IZDANA OPOZORILA",
            style: TextStyle(fontFamily: "Montserrat"),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            _warning.region,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontSize: 32,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              for (Warning w in _warning.warnings)
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      CustomColors.lightGrey,
                      CustomColors.darkGrey
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text("${w.title}", style: TextStyle(color:Colors.white, fontFamily: "Montserrat", fontSize: 24),),
                            SizedBox(height: 5,),
                            Text(w.description, style: TextStyle(color: Colors.white, fontFamily: "Montserrat", fontSize: 20, fontWeight: FontWeight.w200),)
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("${w.level}", style: TextStyle(color: Colors.white,  fontFamily: "Montserrat", fontSize: 48, fontWeight: FontWeight.w300),),
                            Text("/4", style: TextStyle(color: Colors.white,  fontFamily: "Montserrat", fontSize: 24, fontWeight: FontWeight.w200),),
                          ],
                        ),
                      ],
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
