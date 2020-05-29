import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vreme/data/rest_api.dart';
import 'package:vreme/data/vodotok_postaja.dart';
import 'package:vreme/style/custom_icons.dart';

class VodotokDetail extends StatefulWidget {
  @override
  _VodotokDetailState createState() => _VodotokDetailState();
}

class _VodotokDetailState extends State<VodotokDetail> {
  
  MerilnoMestoVodotok vodotok;
  RestApi restApi = RestApi();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await restApi.fetchPostajeData();
    //vodotok = restApi.getPostaja(postaja.id);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context).settings.arguments;
    vodotok = data['vodotok'];
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          title: Text(vodotok.merilnoMesto.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              onPressed: () {
              
              },
              icon: Icon(null == null ? Icons.star : Icons.star_border),
            )
          ],
        ),
        body: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 50 - 120,
                            child: Text(vodotok.reka,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                                color: Colors.white
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(vodotok.pretokZnacilni != null ? vodotok.pretokZnacilni :
                            vodotok.vodostajZnacilni != null ? vodotok.vodostajZnacilni : "",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 24,
                              fontWeight: FontWeight.w200,
                              color: Colors.white
                            ),  
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: _setImage(vodotok),
                      )
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

  Widget _setImage(MerilnoMestoVodotok vodotok) {
    String url = "assets/images/vodotoki/";

    if(vodotok.pretokZnacilni != null) {
      switch(vodotok.pretokZnacilni) {
        case "mali pretok":
          url += "small128.png";
          break;
        case "srednji pretok":
          url += "medium128.png";
          break;
        case "velik pretok":
          url += "big128.png";
          break;
        case "prvi visokovodni pretok":
          url += "big1128.png";
          break;
        case "drugi visokovodni pretok":
          url += "big2128.png";
          break;
        case "tretji visokovodni pretok":
          url += "big3128.png";
          break;
        default:
          url = null;
      }
    } else if(vodotok.vodostajZnacilni != null){
      switch(vodotok.vodostajZnacilni) {
        case "nizek vodostaj":
          url += "small128.png";
          break;
        case "srednji vodostaj":
          url += "medium128.png";
          break;
        case "visok vodostaj":
          url += "big128.png";
          break;
        case "prvi visokovodni vodostaj":
          url += "big1128.png";
          break;
        case "drugi visokovodni vodostaj":
          url += "big2128.png";
          break;
        case "tretji visokovodni vodostaj":
          url += "big3128.png";
          break;
        default:
          url = null;
      }
    } else {
      url = null;
    }

    if (url != null)
      return Image.asset(url, height: 100,);
    else
      return Container();
  }
}