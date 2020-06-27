import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/shared_preferences/favorites.dart';
import 'package:vreme/style/custom_icons.dart';

class ReorderingFavorites extends StatefulWidget {
  @override
  _ReorderingFavoritesState createState() => _ReorderingFavoritesState();
}

class _ReorderingFavoritesState extends State<ReorderingFavorites> {
  Favorites _fav = Favorites();
  List<dynamic> _favorites;

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        var item = _favorites.removeAt(oldIndex);
        _favorites.insert(newIndex, item);
      },

    );
  }

  @override
  void initState() {
    _favorites = _fav.getFavorites();
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Urejanje priljubljenih",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.done), onPressed: (){
                _fav.setFav(_favorites);
                Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
              },
              color: Colors.white,)
            ],
          ),
          body: ReorderableListView(
              onReorder: _onReorder,
              scrollDirection: Axis.vertical,
              children: List.generate(_favorites.length, (index) {
                var temp = _favorites[index];
                return Container(
                  key: ValueKey(temp),
                  color: Colors.transparent,
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  child: Container(
                    color: CustomColors.darkBlue,
                    padding:
                        EdgeInsets.only(left: 10, right: 5, top: 15, bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          temp.type == "vodotok"
                              ? "${temp.merilnoMesto.toUpperCase()} (${temp.reka.toUpperCase()})"
                              : "${temp.id.toUpperCase()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontSize: 22),
                        )
                      ],
                    ),
                  ),
                );
              })),
        ));
  }
}
