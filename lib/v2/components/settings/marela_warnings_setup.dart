import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/screens/loading_data.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:vreme/v2/components/loaders/OnelineLoadingScreen.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/MarelaWarningsRegisterWrapper.dart';
import 'package:vreme/v2/components/opozorilaV2/wrappers/OpozoriloWrapper.dart';
import 'package:vreme/v2/services/MarelaWarningsService.dart';
import 'package:vreme/v2/services/OpozorilaServices.dart';

class MarelaWarningsSetup extends StatefulWidget {
  MarelaWarningsSetup({Key key}) : super(key: key);

  @override
  _MarelaWarningsSetupState createState() => _MarelaWarningsSetupState();
}

class _MarelaWarningsSetupState extends State<MarelaWarningsSetup> {
  int _currentStep = 0;
  bool _completed = false;

  var pokrajineOpozorila = [];
  List<bool> izbranePokrajine = [];
  bool pokrajineNalozene = false;

  var stopnjeOpozorila = [];
  int izbranaStopnja = -1;
  bool stopnjeNalozene = false;

  var tipiOpozorila = [];
  List<bool> izbraniTipi = [];
  bool tipiNalozeni = false;

  double _screenHeight = 0;
  double _screenWidth = 0;
  BuildContext _context;

  bool savedToServer = false;
  bool errorSavingToServer = false;

  void _nextStep() {
    savedToServer = false;
    errorSavingToServer = false;
    if (_currentStep == 1) {
      //mora biti izbrana stopnja
      if (izbranaStopnja == -1) {
        _showSnackbar("Stopnja mora biti izbrana");
        return;
      }
    } else if (_currentStep == 2) {
      bool anyTrue = false;
      for (bool x in izbraniTipi) if (x) anyTrue = true;

      if (!anyTrue) {
        _showSnackbar("Izbran mora biti vsaj en tip");
        return;
      }
    } else if (_currentStep == 3) {
      bool anyTrue = false;
      for (bool x in izbranePokrajine) if (x) anyTrue = true;

      if (!anyTrue) {
        _showSnackbar("Izbrana mora biti vsaj ena pokrajina");
        return;
      }
    } else if (_currentStep == 4) {
      Navigator.pop(context);
    }

    if (_currentStep < 4) _currentStep++;

    if (_currentStep == 4)
      setState(() {
        _submitForm();
      });
    else
      setState(() {});
  }

  void _submitForm() {
    SettingsPreferences sharedPreferences = SettingsPreferences();
    Naprava naprava = new Naprava(
        fcmId: sharedPreferences.getStringSetting(sharedPreferences.fcmToken));
    List<Pokrajine> pokrajine = [];
    List<Tipi> tipi = [];

    for (int i = 0; i < pokrajineOpozorila.length; i++)
      if (izbranePokrajine[i])
        pokrajine.add(Pokrajine(
            pokrajinaIme: pokrajineOpozorila[i].pokrajinaIme,
            drzavaIme: pokrajineOpozorila[i].drzavaIme));

    for (int i = 0; i < tipiOpozorila.length; i++)
      if (izbraniTipi[i]) tipi.add(Tipi(imeTipa: tipiOpozorila[i].imeTipa));

    Stopnja stopnja =
        Stopnja(stopnja: stopnjeOpozorila[izbranaStopnja].stopnja);

    MarelaWarningsServices.saveMarelaWarningsToServer(
            MarelaWarningsRegisterWrapper(
                naprava: naprava,
                pokrajine: pokrajine,
                stopnja: stopnja,
                tipi: tipi))
        .then((data) {
      if (data == 200)
        setState(() {
          savedToServer = true;
        });
      else
        setState(() {
          errorSavingToServer = true;
        });
    });
  }

  void _goToStep(int step) {
    if (step <= _currentStep)
      setState(() {
        _currentStep = step;
      });
  }

  @override
  void initState() {
    super.initState();
    OpozorilaServices.getPokrajineOpozoril().then((data) {
      print(data);
      data = data;
      pokrajineOpozorila = data;
      for (var p in pokrajineOpozorila) {
        p.drzavaIme = "Slovenija";
        izbranePokrajine.add(false);
      }
      setState(() {
        pokrajineNalozene = true;
      });
    });
    OpozorilaServices.getStopnjeOpozoril().then((data) {
      stopnjeOpozorila = data;
      setState(() {
        stopnjeNalozene = true;
      });
    });
    OpozorilaServices.getTipiOpozoril().then((data) {
      tipiOpozorila = data;
      for (var t in tipiOpozorila) izbraniTipi.add(false);
      setState(() {
        tipiNalozeni = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    if (_steps.length == 0) _steps = _setSteps(context);
    _setSteps(context);
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [CustomColors.blue, CustomColors.blue2],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "MarelaWarnings",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
          ),
          body: Builder(builder: (context) {
            _context = context;
            return Column(
              children: <Widget>[
                Expanded(
                  child: Theme(
                    data: ThemeData(primaryColor: CustomColors.darkGrey),
                    child: Stepper(
                      steps: _setSteps(context),
                      currentStep: _currentStep,
                      onStepTapped: (step) => _goToStep(step),
                      controlsBuilder: (context,
                          {onStepCancel, onStepContinue}) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (_currentStep != 4 ||
                                (_currentStep == 4 && savedToServer) ||
                                (_currentStep == 4 && errorSavingToServer))
                              RaisedButton(
                                onPressed: _nextStep,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _currentStep == 4 ? "Zaključi" : "Naprej",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                    ),
                                    Icon(
                                      _currentStep == 4
                                          ? Icons.check
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 32,
                                    )
                                  ],
                                ),
                                color: CustomColors.lightGrey,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }

  List<Step> _steps = [];

  List<Step> _setSteps(BuildContext context) {
    return [
      Step(
        title: Text(
          "Uvod",
          style: Theme.of(context).textTheme.headline1,
        ),
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            Text(
              "MarelaWarnings vas opozarja v primeru razglašenih izrednih vremenskih pojavov ali možnosti trenutnega pojavljanja toče.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "V naslednjih korakih boste lahko nastavili za katere tipe opozoril in za katere pokrajine želite prejmati obvestila.",
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
      Step(
        title: Text(
          "Stopnja",
          style: Theme.of(context).textTheme.headline1,
        ),
        state: StepState.indexed,
        content: Column(
          children: _createStopnjeList(),
        ),
      ),
      Step(
        title: Text(
          "Tipi",
          style: Theme.of(context).textTheme.headline1,
        ),
        isActive: false,
        state: StepState.indexed,
        content: Column(
          children: _createTipiList(),
        ),
      ),
      Step(
        title: Container(
          child: Flexible(
            child: Text(
              "Pokrajine",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ),
        state: StepState.indexed,
        content: Padding(
          padding: EdgeInsets.only(bottom: _screenHeight * 0.025),
          child: Column(
            children: _createPokrajinaList(),
          ),
        ),
      ),
      Step(
        title: Container(
          child: Flexible(
            child: Text(
              "Zaključek",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ),
        state: StepState.indexed,
        content: Padding(
          padding: EdgeInsets.only(bottom: _screenHeight * 0.025),
          child: Column(
            children: <Widget>[
              if (!savedToServer && !errorSavingToServer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OnelineLoadingScreen(
                      text: "Pošiljanje podatkov na strežnik"),
                )
              else if (errorSavingToServer)
                Container(
                  child: Text(
                    "Prišlo je do napake pri shranjevanju na strežnik. Poskusite ponovno kasneje",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              else if (savedToServer)
                Container(
                  child: Text(
                    "Shranjevanje uspešno zaključeno",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              else
                Container()
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _createPokrajinaList() {
    print(izbranePokrajine);
    List<Widget> list = [];
    list.add(
      Padding(
        padding: EdgeInsets.only(bottom: _screenHeight * 0.025),
        child: Text(
          "Izberite za katere pokrajine želite prejemati obvestila",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );

    for (int i = 0; i < pokrajineOpozorila.length; i++) {
      var pokrajina = pokrajineOpozorila[i];
      list.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                bool temp = izbranePokrajine[i];
                print(temp);
                izbranePokrajine[i] = !temp;
                print(izbranePokrajine[i]);
              });
            },
            child: Row(
              children: <Widget>[
                izbranePokrajine[i]
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.check,
                        color: Colors.transparent,
                      ),
                SizedBox(
                  width: _screenWidth * 0.05,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        pokrajina.pokrajinaIme,
                        style: Theme.of(context).textTheme.headline3,
                      )),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _createStopnjeList() {
    print(izbranePokrajine);
    List<Widget> list = [];
    list.add(
      Padding(
        padding: EdgeInsets.only(bottom: _screenHeight * 0.025),
        child: Text(
          "Izberite najnižjo želeno stopnjo obvestil. Vedno boste bili opozorjeni za izbrano stopnjo in vse stopnje nad izbrano",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );

    for (int i = 1; i < stopnjeOpozorila.length; i++) {
      var stopnja = stopnjeOpozorila[i];
      list.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                izbranaStopnja = i;
              });
            },
            child: Row(
              children: <Widget>[
                izbranaStopnja == i
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.check,
                        color: Colors.transparent,
                      ),
                SizedBox(
                  width: _screenWidth * 0.05,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _switchForStopnjeOpozoril(stopnja.stopnja)[0],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          _switchForStopnjeOpozoril(stopnja.stopnja)[1],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _createTipiList() {
    print(izbranePokrajine);
    List<Widget> list = [];
    list.add(
      Padding(
        padding: EdgeInsets.only(bottom: _screenHeight * 0.025),
        child: Text(
          "Izberite za katere tipe opozoril želite prejemati obvestila",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );

    for (int i = 0; i < tipiOpozorila.length; i++) {
      var tip = tipiOpozorila[i];
      list.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                bool temp = izbraniTipi[i];
                izbraniTipi[i] = !temp;
              });
            },
            child: Row(
              children: <Widget>[
                izbraniTipi[i]
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.check,
                        color: Colors.transparent,
                      ),
                SizedBox(
                  width: _screenWidth * 0.05,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        tip.imeTipa,
                        style: Theme.of(context).textTheme.headline3,
                      )),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return list;
  }

  List<String> _switchForStopnjeOpozoril(int stopnja) {
    switch (stopnja) {
      case 1:
        return ["Rumeno opozorilo", "opozorilo 1. stopnje)"];
      case 2:
        return ["Oranžno opozorilo", "(opozorilo 2. stopnje)"];
      case 3:
        return ["Rdeče opozorilo", "(opozorilo 3. stopnje)"];
    }
    return null;
  }

  void _showSnackbar(String message) {
    Scaffold.of(_context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    ));
  }
}
