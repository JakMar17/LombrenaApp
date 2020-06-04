import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/style/custom_icons.dart';

class CustomSearch extends StatefulWidget {
  @override
  _CustomSearchState createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  TextEditingController _textController = TextEditingController();

  List<SearchCategory> categories = [
    SearchCategory(title: "Vremenska napoved"),
    SearchCategory(title: "Vremenske postaje"),
    SearchCategory(title: "Vodotoki"),
    /* SearchCategory(title: "Kakovost zraka"),
    SearchCategory(title: "Slovenske gore") */
  ];

  RestApi restApi = RestApi();
  List<Postaja> vremenskePostaje;
  List<MerilnoMestoVodotok> vodotoki;
  List<NapovedCategory> napoved5dnevna;
  List<NapovedCategory> napoved3dnevna;
  List<ResultElement> show;

  @override
  void initState() {
    super.initState();
    show = [];
    vremenskePostaje = restApi.getAvtomatskePostaje();
    vodotoki = restApi.getVodotoki();
    napoved3dnevna = restApi.get3dnevnaNapoved();
    List<NapovedCategory> t = [];
    t.add(RestApi.napoved5dnevna);
    napoved5dnevna = t;
  }

  @override
  Widget build(BuildContext context) {
    search(_textController.text);

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [CustomColors.blue, CustomColors.blue2],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CustomColors.lightGrey),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, "/home");
                                },
                              ),
                            ),
                            Flexible(
                              flex: 10,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Išči in najdi",
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                    labelStyle: TextStyle(color: Colors.white),
                                    counterStyle:
                                        TextStyle(color: Colors.white),
                                  ),
                                  controller: _textController,
                                  onChanged: (String value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _textController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          double paddingLeft = 0;
                          if (index == 0) paddingLeft = 10;
                          return Padding(
                            padding: EdgeInsets.only(left: paddingLeft),
                            child: _buildInputChip(categories[index]),
                          );
                        }),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Container(
                        width: double.infinity,
                        child: _buildSearchResultsList(show)),
                  ))
                ],
              ),
            )));
  }

  Widget _buildInputChip(SearchCategory cat) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InputChip(
          backgroundColor: CustomColors.lightGrey,
          avatar: CircleAvatar(
            backgroundColor: CustomColors.blue2,
            child: cat.searchingIn
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : null,
          ),
          label: Text(
            cat.title,
            style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
          ),
          onPressed: () {
            setState(() {
              print(_textController.text);
              cat.searchingIn = !cat.searchingIn;
            });
          }),
    );
  }

  void search(String searchString) {
    show = [];

    if (searchString.length == 0) return;

    searchString = searchString.toUpperCase();

    bool showNapovedi = categories[0].searchingIn;
    bool showPostaje = categories[1].searchingIn;
    bool showVodotoki = categories[2].searchingIn;
    bool first = true;

    if (showNapovedi) {
      for (NapovedCategory c in napoved5dnevna) {
        if (c.napovedi[0].longTitle.toUpperCase().contains(searchString)) {
          if (first) {
            show.add(ResultElement(
                categoryTitle: true, title: "Vremenske napovedi"));
            first = false;
          }
          show.add(ResultElement(
              title: c.napovedi[0].longTitle,
              url: () {
                Navigator.pushNamed(context, "/napoved",
                    arguments: {"napoved": c});
              },
              id: c.categoryName));
        }
      }
      
      for(NapovedCategory c in napoved3dnevna) {
        if (c.napovedi[0].longTitle.toUpperCase().contains(searchString)) {
          if (first) {
            show.add(ResultElement(
                categoryTitle: true, title: "Vremenske napovedi"));
            first = false;
          }
          show.add(ResultElement(
              title: c.napovedi[0].longTitle,
              url: () {
                Navigator.pushNamed(context, "/napoved",
                    arguments: {"napoved": c});
              },
              id: c.categoryName));
        }
      }
    }

    first = true;
    if (showPostaje)
      for (Postaja p in vremenskePostaje) {
        if (p.titleLong.toUpperCase().contains(searchString)) {
          if (first) {
            show.add(
                ResultElement(categoryTitle: true, title: "Vremenske postaje"));
            first = false;
          }

          show.add(ResultElement(
              title: p.titleLong,
              url: () {
                Navigator.pushNamed(context, '/postaja',
                    arguments: {"postaja": p});
              },
              id: p.id));
        }
      }
    first = true;

    if (showVodotoki)
      for (MerilnoMestoVodotok v in vodotoki) {
        if (v.reka.toUpperCase().contains(searchString) ||
            v.merilnoMesto.toUpperCase().contains(searchString)) {
          if (first) {
            show.add(ResultElement(categoryTitle: true, title: "Vodotoki"));
            first = false;
          }

          show.add(ResultElement(
              categoryTitle: false,
              title: "${v.merilnoMesto} - ${v.reka}",
              url: () {
                Navigator.pushNamed(context, '/vodotok',
                    arguments: {"vodotok": v});
              },
              id: v.id));
        }
      }
  }

  Widget _buildSearchResultsList(List<ResultElement> list) {
    print(list.length);

    if (list == null || list.length == 0)
      return Container(
          width: double.infinity,
          child: Center(
              child: Text("Začni z iskanjem, \n vpiši in najdi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 32,
                      fontWeight: FontWeight.w100))));

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          if (list[index].categoryTitle) {
            double paddingTop = 0;
            if (index != 0) paddingTop = 15;

            return Padding(
              padding: EdgeInsets.only(top: paddingTop, bottom: 15),
              child: Text(list[index].title,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 32,
                      fontWeight: FontWeight.w200)),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RaisedButton(
                color: Colors.transparent,
                onPressed: () {
                  list[index].url();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          list[index].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}

class SearchCategory {
  String title;
  bool searchingIn = true;

  SearchCategory({this.title});
}

class ResultElement {
  bool categoryTitle = false;
  String id;
  var url;
  String title;

  ResultElement({this.categoryTitle, this.id, this.url, this.title}) {
    if (categoryTitle == null) categoryTitle = false;
  }
}
