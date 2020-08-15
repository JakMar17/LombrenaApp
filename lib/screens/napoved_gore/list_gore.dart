import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/models/napoved_text.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';

class NapovedGoreList extends StatefulWidget {
  @override
  _NapovedGoreListState createState() => _NapovedGoreListState();
}

class _NapovedGoreListState extends State<NapovedGoreList> {
  List<DataModel> napovedGore;
  TextNapoved textNapoved;
  bool ready = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void loadData() async {
    RestApi r = RestApi();
    textNapoved = r.getTekstovnaNapoved();
    if (textNapoved == null) {
      await r.fetchTextNapoved();
      textNapoved = r.getTekstovnaNapoved();
    }
    napovedGore = await DBProvider.db.getAllDataOfType(TypeOfData.napovedGore);
    setState(() {
      ready = true;
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
          body: ready
              ? SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: _buildWithData(),
                )
              : LoadingData()),
    );
  }

  CustomScrollView _buildWithData() {
    final textDevider =
        Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 300,
          backgroundColor: CustomColors.blue,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Razmere v gorah",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        _textNapoved(textDevider),
        SliverPadding(
          padding: EdgeInsets.only(top: 10),
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          _buildList("Modelske napovedi", napovedGore),
        )),
        SliverPadding(
          padding: EdgeInsets.only(top: 10),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
          ),
        )
      ],
    );
  }

  SliverToBoxAdapter _textNapoved(ThemeData textDevider) {
    return SliverToBoxAdapter(
        child: Theme(
          data: textDevider,
          child: ExpansionTile(
            trailing: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              "Napoved za gorski svet",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: "Montserrat"),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                child: Text(
                  textNapoved.gore1,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                child: Text(
                  textNapoved.gore2,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 15),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 24,
              fontFamily: "Montserrat",
              color: Colors.white,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.8),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 10, right: 10),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  List _buildList(String title, List<DataModel> cat) {
    List<Widget> list = [];

    list.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 10,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
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
            Navigator.pushNamed(context, "/napoved/gore",
                arguments: {"data_model": cat[i]});
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
                    cat[i].title,
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
