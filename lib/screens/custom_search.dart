import 'package:flutter/material.dart';
import 'package:vreme/style/custom_icons.dart';

class CustomSearch extends StatefulWidget {
  @override
  _CustomSearchState createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  TextEditingController _textController = TextEditingController();

  List<SearchCategory> categories = [
    SearchCategory(title: "Vremenske postaje"),
    SearchCategory(title: "Vodotoki")
  ];

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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: <Widget>[
                    Container(
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
                                  Navigator.pop(context);
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
                                    print(value);
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
                          return _buildInputChip(categories[index]);
                        }),
                    )
                  ],
                ),
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
              cat.searchingIn = !cat.searchingIn;
            });
          }),
    );
  }
}

class SearchCategory {
  String title;
  bool searchingIn = true;

  SearchCategory({this.title});
}
