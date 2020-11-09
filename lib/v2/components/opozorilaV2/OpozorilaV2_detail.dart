import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/style/weather_icons2.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/OpozoriloWrapper.dart';

class OpozorilaV2Detail extends StatefulWidget {
  OpozorilaV2Detail({Key key}) : super(key: key);

  @override
  _OpozorilaV2DetailState createState() => _OpozorilaV2DetailState();
}

class _OpozorilaV2DetailState extends State<OpozorilaV2Detail> {
  bool _dataLoaded = false;
  Pokrajine _pokrajina;

  double screenWidth;
  double screenHeight;

  void _loadData(Map data) {
    _pokrajina = data['pokrajina'];
    if (_pokrajina == null) Navigator.pop(context);

    setState(() {
      print(_pokrajina.pokrajinaIme);
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataLoaded) _loadData(ModalRoute.of(context).settings.arguments);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${_pokrajina.pokrajinaIme}',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _dataLoaded ? _buildWithData() : LoadingData(),
      ),
    );
  }

  Widget _buildWithData() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(_buildPokrajineList()),
        )
      ],
    );
  }

  List _buildPokrajineList() {
    List<Widget> list = [];
    for (OpozorilaPoTipih tip in _pokrajina.opozorilaPoTipih)
      list.add(_wrapperForTipiOpozoril(tip));
    return list;
  }

  Widget _wrapperForTipiOpozoril(OpozorilaPoTipih tip) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.005, horizontal: screenWidth * 0.02),
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.005, horizontal: screenWidth * 0.02),
      decoration: BoxDecoration(
          color: CustomColors.lightGrey,
          borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: theme,
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: _setIconColorForTipOpozorila(tip),
            child: Icon(
              _setIconForTipOpozorila(tip),
              color: Colors.white,
            ),
          ),
          trailing: Text(
            '${_maxStopnjaOpozorila(tip) + 1} / ${_maxStopnjaTipa(tip) +1}',
            style: Theme.of(context).textTheme.headline1,
          ),
          title: Text(
            tip.imeTipa,
            style: Theme.of(context).textTheme.headline2,
          ),
          children: _buildOpozorilaListForTip(tip),
        ),
      ),
    );
  }

  List _buildOpozorilaListForTip(OpozorilaPoTipih tip) {
    List<Widget> list = [];
    for (Opozorila opozorilo in tip.opozorila)
      list.add(_buildOpozoriloContainer(opozorilo));
    return list;
  }

  Widget _buildOpozoriloContainer(Opozorila opozorilo) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(opozorilo.stopnja,
                  style: Theme.of(context).textTheme.headline2),
              Text(
                '${opozorilo.stopnjaN + 1} / ${opozorilo.stopnjaMax +1}',
                style: Theme.of(context).textTheme.headline2,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _constructDate(opozorilo.veljavnoOd.toLocal()),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(width: screenWidth * 0.01),
              Icon(
                Icons.hourglass_full,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(
                Icons.hourglass_empty,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                _constructDate(opozorilo.veljavnoDo.toLocal()),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          if (opozorilo.stopnjaN != 0)
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: <Widget>[
                  if (opozorilo.opis != null && opozorilo.opis.length != 0)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Flexible(
                            child: Text(
                                opozorilo.opis != null ? opozorilo.opis : ""))
                      ],
                    ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  if (opozorilo.navodila != null &&
                      opozorilo.navodila.length != 0)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.book,
                          color: Colors.white,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Flexible(
                            child: Text(opozorilo.navodila != null
                                ? opozorilo.navodila
                                : ""))
                      ],
                    ),
                ],
              ),
            )
          else
            Container(),
          Divider(
            color: Colors.white30,
            height: screenHeight * 0.02,
          )
        ],
      ),
    );
  }

  String _constructDate(DateTime time) {
    String day = time.day.toString();
    String month = time.month.toString();
    String hour = time.hour.toString().length == 1
        ? '0' + time.hour.toString()
        : time.hour.toString();
    String minute = time.minute.toString().length == 1
        ? '0' + time.minute.toString()
        : time.minute.toString();
    return "${day}.${month} ${hour}:${minute}";
  }

  int _maxStopnjaOpozorila(OpozorilaPoTipih tip) {
    int max = 0;
    for(Opozorila o in tip.opozorila)
      if(max < o.stopnjaN)
        max = o.stopnjaN;
    return max;
  }

  int _maxStopnjaTipa(OpozorilaPoTipih tip) {
    return tip.opozorila[0].stopnjaMax;
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
      case "toča":
        return WeatherIcons2.warning_hail;
      default:
        return WeatherIcons2.warning_coast;
    }
  }

  Color _setIconColorForTipOpozorila(OpozorilaPoTipih tip) {
    if(tip.opozorila[0].stopnjaMax == 2)
      switch (_maxStopnjaOpozorila(tip)) {
        case 1:
          return CustomColors.yellow;
        case 2:
          return CustomColors.red;
        default:
          return Colors.transparent;
      }
    else
      switch (_maxStopnjaOpozorila(tip)) {
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
