import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/api/fetching_data.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/models/map_marker.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/screens/loading_data.dart';
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

  List<DataModel> napovedSlo5Dnevna;
  List<DataModel> napovedSlo3Dnevna;
  List<DataModel> napovedSloPokrajine;
  List<DataModel> napovedEvropa;
  List<DataModel> napovedGore;

  List<_Toggle> toggles = [
    _Toggle(
        title: "Pokrajinska napoved", id: "napoved_detail_toggle_pokrajinska"),
    _Toggle(title: "3 dnevna", id: "napoved_detail_toggle_3dnevna"),
    _Toggle(title: "5 dnevna", id: "napoved_detail_toggle_5dnevna"),
    _Toggle(title: "Evropa & Sredozemlje", id: "napoved_detail_toggle_evropa"),
    _Toggle(title: "Napoved gore", id: "napoved_detail_toggle_gore")
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await loadData();
    _refreshController.refreshCompleted();
  }

  bool ready = false;

  void loadData() async {
    napovedSlo5Dnevna =
        await DBProvider.db.getAllDataOfType(TypeOfData.napoved5Dnevna);
    napovedSlo3Dnevna =
        await DBProvider.db.getAllDataOfType(TypeOfData.napoved3Dnevna);
    napovedSloPokrajine =
        await DBProvider.db.getAllDataOfType(TypeOfData.pokrajinskaNapoved);
    napovedEvropa =
        await DBProvider.db.getAllDataOfType(TypeOfData.napovedJadran);
    napovedGore = 
        await DBProvider.db.getAllDataOfType(TypeOfData.napovedGore);
    var t = await DBProvider.db.getAllDataOfType(TypeOfData.napovedEvropa);
    napovedEvropa.addAll(t);

    napovedEvropa.sort((a, b) => a.title.compareTo(b.title));

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
                child: _buildWithData())
            : LoadingData(),
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
              "Vremenska napoved",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 10),
        ),
        SliverToBoxAdapter(
            child: Container(
          width: double.infinity,
          height: 40,
          child: _toggles(),
        )),
        SliverPadding(
          padding: EdgeInsets.only(top: 20),
        ),
        toggles[0].checked
            ? SliverList(
                delegate: SliverChildListDelegate(
                _buildList("Napoved po pokrajinah", napovedSloPokrajine),
              ))
            : SliverToBoxAdapter(),
        toggles[1].checked
            ? SliverList(
                delegate: SliverChildListDelegate(
                    _buildList("3 dnevna napoved", napovedSlo3Dnevna)),
              )
            : SliverToBoxAdapter(),
        toggles[2].checked
            ? SliverList(
                delegate: SliverChildListDelegate(
                    _buildList("5 dnevna napoved", napovedSlo5Dnevna)),
              )
            : SliverToBoxAdapter(),
        toggles[4].checked 
          ? SliverList(
                delegate: SliverChildListDelegate(
                    _buildList("Napoved gore", napovedGore)),
              )
            : SliverToBoxAdapter(),
        toggles[3].checked
            ? SliverList(
                delegate: SliverChildListDelegate(
                    _buildList("Evropa & Sredozemlje", napovedEvropa)),
              )
            : SliverToBoxAdapter(),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 30),
        )
      ],
    );
  }

  ListView _toggles() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: toggles.length,
      itemBuilder: (context, index) {
        return 
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: InputChip(
                backgroundColor: CustomColors.lightGrey,
                avatar: CircleAvatar(
                  backgroundColor: CustomColors.blue2,
                  child: toggles[index].checked
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Container(),
                ),
                label: Text(
                  toggles[index].title,
                  style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
                ),
                onPressed: () {
                  setState(() {
                    toggles[index].toggleSwitch();
                  });
                },
              ),
            );
      },
    );
  }

  List _buildList(String title, List<DataModel> cat) {
    List<Widget> list = [];
    List<MapMarker> markers = [];

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
            Navigator.pushNamed(context, "/napoved",
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

  String setMarker(double temp) {
    String base = "assets/images/temperature/";
    if (temp < -10)
      return "${base}temp001.png";
    else if (temp < 0)
      return "${base}temp002.png";
    else if (temp < 5)
      return "${base}temp003.png";
    else if (temp < 10)
      return "${base}temp004.png";
    else if (temp < 15)
      return "${base}temp005.png";
    else if (temp < 20)
      return "${base}temp006.png";
    else if (temp < 28)
      return "${base}temp007.png";
    else if (temp < 32)
      return "${base}temp008.png";
    else
      return "${base}temp009.png";
  }
}

class _Toggle {
  String title;
  bool checked;
  String id;

  SettingsPreferences _sp = SettingsPreferences();

  _Toggle({this.title, this.id}) {
    bool t = _sp.getSetting(id);
    checked = t == null ? true : t;
  }

  void toggleSwitch() {
    checked = !checked;
    _sp.setSetting(id, checked);
  }
}
