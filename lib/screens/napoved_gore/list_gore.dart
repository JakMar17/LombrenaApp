import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/database/database.dart';
import 'package:vreme/data/database/models/data_model.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';

class NapovedGoreList extends StatefulWidget {
  @override
  _NapovedGoreListState createState() => _NapovedGoreListState();
}

class _NapovedGoreListState extends State<NapovedGoreList> {
  
  List<DataModel> napovedGore;
  bool ready = false;


  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void loadData() async {
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 300,
          backgroundColor: CustomColors.blue,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Razmere v gorah", style: TextStyle(fontFamily: "Montserrat", color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ), SliverPadding(padding: EdgeInsets.only(top: 10),), //SliverToBoxAdapter
      ],
    );
  }
}
