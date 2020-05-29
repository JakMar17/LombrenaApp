import 'package:flutter/material.dart';
import 'package:vreme/data/postaja.dart';
import 'package:vreme/data/rest_api.dart';

class Search extends SearchDelegate {
  RestApi restApi = RestApi();
  List<Postaja> postaje;

  @override
  String get searchFieldLabel => "Iskanje";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text("neki neki");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Začnite iskati tako, da vpišete iskalni niz",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Montserrat",
                letterSpacing: 1.2,
                fontSize: 24,
                fontWeight: FontWeight.w200),
          ),
        ),
      );
    }

    if (postaje == null) postaje = restApi.getAvtomatskePostaje();

    List<Postaja> trenutni = [];

    for (Postaja p in postaje) {
      if (p.title.toUpperCase().contains(query.toUpperCase()) ||
          p.titleLong.toUpperCase().contains(query.toUpperCase()))
        trenutni.add(p);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: ListView.builder(
        itemCount: trenutni.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/postaja",
                  arguments: {"postaja": postaje[index]});
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Text(
                  trenutni[index].titleLong,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          );
        },
      ),
    );

    return ListView.builder(
      itemCount: trenutni.length,
      itemBuilder: (context, index) {
        return Card(
          child: Text(trenutni[index].title),
        );
      },
    );
  }
}
