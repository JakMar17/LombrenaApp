import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vreme/data/shared_preferences/shared_preferences.dart';
import 'package:vreme/firebase_cloud_messaging/push_notifications_manager.dart';
import 'package:vreme/screens/custom_search.dart';
import 'package:vreme/screens/drawer/about_app.dart';
import 'package:vreme/screens/home/home.dart';
import 'package:vreme/screens/home/loading.dart';
import 'package:vreme/screens/home/reordering_favorites.dart';
import 'package:vreme/screens/maps/map.dart';
import 'package:vreme/screens/napoved_gore/gore_detail.dart';
import 'package:vreme/screens/napoved_gore/list_gore.dart';
import 'package:vreme/screens/opozorila/list_opozorila.dart';
import 'package:vreme/screens/opozorila/opozorilo_detail.dart';
import 'package:vreme/screens/settings/marelaWarnings_settings.dart';
import 'package:vreme/screens/settings/settings.dart';
import 'package:vreme/screens/settings/warning_region_selector.dart';
import 'package:vreme/screens/text_napoved/text_napoved.dart';
import 'package:vreme/screens/vodotoki/list_vodotoki.dart';
import 'package:vreme/screens/vodotoki/vodotok_detail.dart';
import 'package:vreme/screens/vremenska_napoved/list_napoved.dart';
import 'package:vreme/screens/vremenska_napoved/napoved_detail.dart';
import 'package:vreme/screens/vremenske_razmere/list_postaje.dart';
import 'package:vreme/screens/vremenske_razmere/postaja.dart';
import 'package:vreme/helpers/marelaWarnings_intro.dart';
import 'package:vreme/v2/components/opozorilaV2/OpozorilaV2_detail.dart';
import 'package:vreme/v2/components/opozorilaV2/OpozorilaV2_master.dart';
import 'package:vreme/v2/components/opozorilaV2/help_pages/opozorila_barve.dart';
import 'package:vreme/v2/components/settings/marela_warnings_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Preferences p = Preferences();
  await p.setInstance();

  PushNotificationManager pnm = PushNotificationManager();
  pnm.init();


  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MaterialApp(
      initialRoute: "/loading",
      routes: {
        '/': (context) => Home(),
        '/postaja': (context) => PostajaDetail(),
        '/loading': (context) => Loading(),
        '/postaje': (context) => ListOfPostaje(),
        '/vodotoki': (context) => ListOfVodotoki(),
        '/vodotok': (context) => VodotokDetail(),
        '/search': (context) => CustomSearch(),
        '/napovedi': (context) => ListOfNapovedi(),
        '/napoved': (context) => NapovedDetail(),
        '/napoved/tekst': (context) => TekstovnaNapoved(),
        '/map': (context) => MapOfSlovenia(),
        '/about': (context) => AboutApp(),
        '/reorder/favorites': (context) => ReorderingFavorites(),
        '/settings': (context) => SettingsScreen(),
        '/warnings': (context) => ListOfWarnings(),
        '/warning': (context) => WarningDetail(),
        '/settings/warnings/regions': (context) => WarningRegionSelector(),
        '/settings/marelaWarnings': (context) => MarelaWarningsSettings(),
        '/napovedi/gore': (context) => NapovedGoreList(),
        '/napoved/gore': (context) => GoreDetail(),
        '/intro/marela-warnings': (context) => MarelaWarningIntro(),
        /* v2 */
        '/v2/opozorila/master': (context) => OpozorilaV2Master(),
        '/v2/opozorila/detail': (context) => OpozorilaV2Detail(),
        '/v2/settings/marela-warnings/setup': (context) => MarelaWarningsSetup(),
        /* helping pages */
        '/help/opozorila/stopnje': (context) => InforOpozorilaBarvnaLestvica()
      },
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(child: child, data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),);

      },
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24, fontFamily: "Montserrat", fontWeight: FontWeight.w500, color: Colors.white),
          headline2: TextStyle(fontSize: 20, fontFamily: "Montserrat", color: Colors.white, fontWeight: FontWeight.w300,),
          headline3: TextStyle(fontSize: 24, fontFamily: "Montserrat", fontWeight: FontWeight.w300, color: Colors.white),
          subtitle1: TextStyle(fontSize: 22, fontFamily: "Montserrat", fontWeight: FontWeight.w200, color: Colors.white),
          subtitle2: TextStyle(fontSize: 22, fontFamily: "Montserrat", fontWeight: FontWeight.w300, color: Colors.white),
          bodyText1: TextStyle(fontSize: 18, fontFamily: "Montserrat", color: Colors.white, fontWeight: FontWeight.w300,),
          bodyText2: TextStyle(fontSize: 16, fontFamily: "Montserrat", color: Colors.white, fontWeight: FontWeight.w200,)
        )
      ),
    ));
  });
}
