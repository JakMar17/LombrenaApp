import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/favorites/favorites_database.dart';
import 'package:vreme/data/type_of_data.dart';
import 'package:vreme/style/custom_icons.dart';

class ReorderingFavorites extends StatefulWidget {
  @override
  _ReorderingFavoritesState createState() => _ReorderingFavoritesState();
}

class _ReorderingFavoritesState extends State<ReorderingFavorites> {
  //Favorites _fav = Favorites();
  FavoritesDatabase fd = FavoritesDatabase();
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
    _favorites = FavoritesDatabase.favorites;
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
              IconButton(icon: Icon(Icons.done), onPressed: () async{
                //_fav.setFav(_favorites);
                var x = _favorites;
                for (var f in x) {
                  await fd.addToFavorite(f);
                }
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
                          temp.typeOfData == TypeOfData.vodotok
                              ? "${temp.merilnoMesto.toUpperCase()} (${temp.reka.toUpperCase()})"
                              : temp.typeOfData == TypeOfData.postaja ? temp.titleLong : temp.categoryName,
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
