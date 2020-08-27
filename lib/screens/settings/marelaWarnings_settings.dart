import 'package:flutter/material.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/marelaWarningsAPI/dataHolders/warning_prijava.dart';
import 'package:vreme/marelaWarningsAPI/marelaWarningQueries.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';

class MarelaWarningsSettings extends StatefulWidget {
  @override
  _MarelaWarningsSettingsState createState() => _MarelaWarningsSettingsState();
}

class _MarelaWarningsSettingsState extends State<MarelaWarningsSettings> {
  SettingsPreferences _settings;
  WarningPrijava _prijava;
  bool dataLoaded = false;

  _Toggle enableWarnings;
  _List typesOfWarnings = _List(id: "", title: "Vrste opozoril");
  _List regionsOfWarnings = _List(title: "Regije opozoril");
  _List minLevelWarning = _List(title: "Najmanjša stopnja opozorila");

  Future<bool> sendDataToServer() async {
    WarningPrijava p = null;
    if (enableWarnings.isSwitched) {
      p = WarningPrijava();
      List<Pokrajine> pokrajine = [];
      for (_ListElement e in regionsOfWarnings.elements)
        if (e.isChecked)
          pokrajine.add(Pokrajine(
              imePokrajine: e.value, drzava: Drzava(imeDrzave: "Slovenija")));

      List<Tipi> tipi = [];
      for (_ListElement e in typesOfWarnings.elements)
        if (e.isChecked) tipi.add(Tipi(imeTipa: e.value));

      String stopnja;
      for (_ListElement e in minLevelWarning.elements)
        if (e.isChecked) stopnja = e.value;

      p.pokrajine = pokrajine;
      p.tipi = tipi;
      p.stopnja = Stopnja(tipStopnje: stopnja);

      MarelaWarningQueries q = MarelaWarningQueries();
      return await q.setMarelaWarningsNaroceno(p);
    }
  }

  Future<void> setDataFromServer() async {
    _settings = SettingsPreferences();

    bool enabled = _settings.getSetting(_settings.marelaWarningsEnabled);
    enabled = enabled == null ? true : enabled;

    if (enabled) {
      MarelaWarningQueries q = MarelaWarningQueries();
      _prijava = await q.getMarelaWarningsNaroceno();
    }

    enableWarnings = _Toggle(
        id: _settings.marelaWarningsEnabled,
        title: "Vremenska opozorila",
        description: "Bodite opozoreni o vremenskih opozorilih",
        isSwitched: enabled == null ? false : enabled);

    List<String> typesREST = [];
    if (_prijava != null)
      for (var tip in _prijava.tipi) typesREST.add(tip.imeTipa);

    typesOfWarnings.elements = [
      _ListElement(
          title: "Dež", value: "dež", isChecked: typesREST.contains("dež")),
      _ListElement(
          title: "Nevihte",
          value: "nevihte",
          isChecked: typesREST.contains("nevihte")),
      _ListElement(
          title: "Veter",
          value: "veter",
          isChecked: typesREST.contains("veter")),
      _ListElement(
          title: "Poledica in žled",
          value: "poledica/žled",
          isChecked: typesREST.contains("poledica/žled")),
      _ListElement(
          title: "Nizke temperature",
          value: "nizka temperatura",
          isChecked: typesREST.contains("nizka temperatura")),
      _ListElement(
          title: "Visoke temperature",
          value: "visoka temperatura",
          isChecked: typesREST.contains("visoka temperatura")),
      _ListElement(
          title: "Sneg", value: "sneg", isChecked: typesREST.contains("sneg")),
      _ListElement(
          title: "Snežni plazovi",
          value: "snežni plazovi",
          isChecked: typesREST.contains("snežni plazovi")),
      _ListElement(
          title: "Požarna ogroženost",
          value: "požarna ogroženost",
          isChecked: typesREST.contains("požarna ogroženost")),
      _ListElement(
          title: "Obalni dogodki",
          value: "obalni dogodek",
          isChecked: typesREST.contains("obalni dogodek")),
    ];

    List<String> regionsREST = [];
    if (_prijava != null)
      for (var region in _prijava.pokrajine)
        regionsREST.add(region.imePokrajine);

    regionsOfWarnings.elements = [
      _ListElement(
          title: "Osrednja Slovenija",
          value: "osrednja",
          isChecked: regionsREST.contains("osrednja")),
      _ListElement(
          title: "Severozahodna Slovenija",
          value: "severozahodna",
          isChecked: regionsREST.contains("severozahodna")),
      _ListElement(
          title: "Severovzhodna Slovenija",
          value: "severovzhodna",
          isChecked: regionsREST.contains("severovzhodna")),
      _ListElement(
          title: "Jugozahodna Slovenija",
          value: "jugozahod",
          isChecked: regionsREST.contains("jugozahod")),
      _ListElement(
          title: "Jugovzhodna Slovenija",
          value: "jugovzhod",
          isChecked: regionsREST.contains("jugovzhod")),
    ];

    String minLevel = _prijava != null ? _prijava.stopnja.tipStopnje : "";
    minLevelWarning.elements = [
      _ListElement(
          title: "Rumena opozorila (1. stopnja)",
          value: "rumena",
          isChecked: minLevel == "rumena"),
      _ListElement(
          title: "Oranžna opozorila (2. stopnja)",
          value: "oranžna",
          isChecked: minLevel == "oranžna"),
      _ListElement(
          title: "Rdeča opozorila (3. stopnja)",
          value: "rdeča",
          isChecked: minLevel == "rdeča"),
    ];

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    setDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [CustomColors.blue2, CustomColors.blue2],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Vremenska opozorila",
            style: TextStyle(fontFamily: "Montserrat"),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                onPressed: () {

                  setState(() {
                    dataLoaded = false;
                  });

                  sendDataToServer().then((value) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(value ? "Podatki so uspešno shranjeni na strežnik" : "Prišlo je do napake, poskusite ponovno", style: TextStyle(fontFamily: "Montserrat"),)
                        ],
                      ),
                    ));

                    Navigator.of(context).pop();
                  });
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: dataLoaded ? _buildWithData() : LoadingData(),
      ),
    );
  }

  Padding _buildWithData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(
        slivers: <Widget>[
          toggleSettingRow(enableWarnings),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          _title("Najnižja stopnja opozorila",
              "za katerega želite biti opozorjeni"),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          listView(minLevelWarning, true),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          _title("Tipi opozoril", "za katere želite biti opozorjeni"),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          listView(typesOfWarnings, false),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          _title("Regije opozoril", "za katere želite biti opozorjeni"),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          listView(regionsOfWarnings, false),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _title(String title, String description) {
    if (!enableWarnings.isSwitched) return SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            description,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter toggleSettingRow(_Toggle toggle) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          setState(() {
            toggle.switchToggle();
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    toggle.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    toggle.description,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Switch(
                onChanged: (value) {
                  setState(() {
                    toggle.switchToggle();
                  });
                },
                value: toggle.isSwitched,
                activeTrackColor: CustomColors.lightGrey,
                activeColor: CustomColors.darkGrey,
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverList listView(_List list, bool onlyOneSelected) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (!enableWarnings.isSwitched) return Container();
          return RaisedButton(
            onPressed: () {
              setState(() {
                if (onlyOneSelected) list.clearChecked();
                list.elements[index].isChecked =
                    !list.elements[index].isChecked;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check,
                    color: list.elements[index].isChecked
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      list.elements[index].title,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
            color: Colors.transparent,
          );
        },
        childCount: list.elements.length,
      ),
    );
  }

  GestureDetector buttonRow(String title, String description, void onTap()) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Toggle {
  String title;
  String description;
  String id;
  bool isSwitched = false;

  _Toggle({this.title, this.description, this.id, this.isSwitched}) {
    isSwitched = isSwitched == null ? false : isSwitched;
  }

  void switchToggle() {
    isSwitched = !isSwitched;
  }

  void saveToPreferences(SettingsPreferences s) {
    if (s != null) s.setSetting(id, isSwitched);
  }
}

class _List {
  List<_ListElement> elements;
  String id;
  String title;

  _List({this.id, this.title, this.elements}) {
    elements = [];
  }

  void saveToPreferences(SettingsPreferences s) {
    if (s != null) s.setStringListSetting(id, getStringValues());
  }

  List<String> getStringValues() {
    List<String> stringValues = [];
    for (_ListElement e in elements) stringValues.add(e.value);
    return stringValues;
  }

  void clearChecked() {
    for (_ListElement e in elements) e.isChecked = false;
  }
}

class _ListElement {
  String title;
  String value;
  bool isChecked;

  _ListElement({this.isChecked, this.title, this.value});
}
