import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons2.dart';

class ListOfNapovedi extends StatefulWidget {
  @override
  _ListOfNapovediState createState() => _ListOfNapovediState();
}

class _ListOfNapovediState extends State<ListOfNapovedi> {
  RestApi restApi = RestApi();

  List<NapovedCategory> napoved5dnevna;
  List<NapovedCategory> napoved3dnevna;
  List<NapovedCategory> napovedPoPokrajinah;

  @override
  void initState() {
    napoved5dnevna = [];
    napoved5dnevna.add(restApi.get5dnevnaNapoved());
    napoved3dnevna = restApi.get3dnevnaNapoved();
    napovedPoPokrajinah = restApi.getPokrajinskaNapoved();
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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              backgroundColor: CustomColors.blue,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Vremenska napoved",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 30),
            ),
            SliverList(delegate: SliverChildListDelegate(
              _buildList("Napoved po pokrajinah", napovedPoPokrajinah)
            ),),
            SliverList(delegate: SliverChildListDelegate(
              _buildList("3 dnevna napoved", napoved3dnevna)
            ),),
            SliverList(
              delegate: SliverChildListDelegate(
                  _buildList("5 dnevna napoved", napoved5dnevna)),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
      ),
    );
  }

  List _buildList(String title, List<NapovedCategory> cat) {
    List<Widget> list = [];

    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Montserrat",
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );

    list.add(SizedBox(
      height: 10,
    ));

    for (int i = 0; i < cat.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/napoved",
                arguments: {"napoved": cat[i]});
          },
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    cat[i].categoryName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 22,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return list;
  }
}
