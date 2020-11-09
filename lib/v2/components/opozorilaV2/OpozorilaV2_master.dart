import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons2.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/OpozoriloWrapper.dart';
import 'package:vreme/v2/services/OpozorilaServices.dart';

class OpozorilaV2Master extends StatefulWidget {
  @override
  _OpozorilaV2MasterState createState() => _OpozorilaV2MasterState();
}

class _OpozorilaV2MasterState extends State<OpozorilaV2Master> {
  bool _dataLoaded = false;
  bool _errorFetchingData = false;
  OpozorilaWrapper _wrapper;

  double screenWidth;
  double screenHeight;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    _loadData(true);
    _refreshController.refreshCompleted();
  }

  void _loadData(bool showLoading) {
    setState(() {
      print('klicem' + showLoading.toString());
      _dataLoaded = showLoading;
    });
    OpozorilaServices opozorilaServices = OpozorilaServices();
    opozorilaServices.getOpozorila().then((data) {
      setState(() {
        _dataLoaded = true;
        if (data == null) {
          _errorFetchingData = true;
        } else {
          _wrapper = data;
          _errorFetchingData = false;
        }
      });
    });
  }

  @override
  void initState() {
    _loadData(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: !_errorFetchingData
            ? null
            : AppBar(
                title: Text('Izdana opozorila',
                    style: TextStyle(fontFamily: "Montserrat")),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
        body: _dataLoaded
            ? SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: _errorFetchingData ? _errorHandler() : _buildWithData())
            : LoadingData(),
      ),
    );
  }

  Widget _buildWithData() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Izdana opozorila',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: screenHeight * 0.02,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          sliver: SliverList(
              delegate: SliverChildListDelegate(_buildPokrajinaList())),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02,
              screenWidth * 0.05, screenHeight * 0.02),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Prikazana so samo trenutno aktivna opozorila, za prikaz podrobnosti o trajanju in opisu opozoril izberite regijo.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
        SliverPadding(
            padding: EdgeInsets.fromLTRB(
                0, screenHeight * 0.02, 0, screenHeight * 0.02),
            sliver: SliverToBoxAdapter(
              child: FlatButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/help/opozorila/stopnje'),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.help_outline, color: Colors.white,),
                      SizedBox(width: screenWidth * 0.03,),
                      Flexible(
                                              child: Text(
                          'Razlaga barne lestvice izdanih opozoril',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      )
                    ],
                  )),
            ))
      ],
    );
  }

  Widget _errorHandler() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.05),
            child: Text(
              'Prišlo je do napake pri pridobivanju podatkov',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          RaisedButton(
            color: Colors.transparent,
            child: Text(
              'Poskusi znova',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onPressed: () => _loadData(true),
          )
        ],
      ),
    );
  }

  List _buildPokrajinaList() {
    List<Widget> list = [];
    for (Pokrajine p in _wrapper.pokrajine) {
      list.add(GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/v2/opozorila/detail',
              arguments: {'pokrajina': p});
        },
        child: Container(
          decoration: BoxDecoration(
              color: CustomColors.lightGrey,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Text(
                  '${p.pokrajinaIme}',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  for (OpozorilaPoTipih tip in p.opozorilaPoTipih)
                    if(tip.opozorila[0].stopnjaN != 0)
                        Padding(
                            padding: EdgeInsets.only(right: 5, bottom: 5),
                            child: CircleAvatar(
                              backgroundColor:
                                  _setIconColorForTipOpozorila(tip),
                              child: Icon(
                                _setIconForTipOpozorila(tip),
                                color: Colors.white,
                              ),
                            ),
                          )
                ],
              ),
            ],
          ),
        ),
      ));
    }

    return list;
  }

  IconData _setIconForTipOpozorila(OpozorilaPoTipih tip) {
    switch (tip.imeTipa.toLowerCase()) {
      case "veter":
        return WeatherIcons2.warning_wind;
      case "dež":
        return WeatherIcons2.warning_rain;
      case "nevihte":
        return WeatherIcons2.warning_thunderstorm;
      case "sneg":
        return WeatherIcons2.warning_snow;
      case "poledica/žled":
        return WeatherIcons2.warning_ice;
      case "visoka temperatura":
        return WeatherIcons2.warning_highTemp;
      case "nizka temperatura":
        return WeatherIcons2.warning_lowTemp;
      case "požarna ogroženost":
        return WeatherIcons2.warning_fire;
      case "snežni plazovi":
        return WeatherIcons2.warning_avalanche;
      case "obalni dogodek":
        return WeatherIcons2.warning_coast;
      case "toča":
        return WeatherIcons2.warning_hail;
    }
  }

  Color _setIconColorForTipOpozorila(OpozorilaPoTipih tip) {
    if(tip.opozorila[0].stopnjaMax == 2)
      switch (tip.opozorila[0].stopnjaN) {
        case 1:
          return CustomColors.yellow;
        case 2:
          return CustomColors.red;
        default:
          return Colors.transparent;
      }
    else
      switch (tip.opozorila[0].stopnjaN) {
      case 1:
        return CustomColors.yellow;
      case 2:
        return CustomColors.orange;
      case 3:
        return CustomColors.red;
      default:
        return Colors.transparent;
    }
  }
}
