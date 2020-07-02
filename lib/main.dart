import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/background_services/background_services.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/shared_preferences/favorites.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/screens/custom_search.dart';
import 'package:vreme/screens/drawer/about_app.dart';
import 'package:vreme/screens/home/home.dart';
import 'package:vreme/screens/home/loading.dart';
import 'package:vreme/screens/home/reordering_favorites.dart';
import 'package:vreme/screens/maps/map.dart';
import 'package:vreme/screens/opozorila/list_opozorila.dart';
import 'package:vreme/screens/opozorila/opozorilo_detail.dart';
import 'package:vreme/screens/settings/active_notifications_list.dart';
import 'package:vreme/screens/settings/settings.dart';
import 'package:vreme/screens/settings/warning_region_selector.dart';
import 'package:vreme/screens/text_napoved/text_napoved.dart';
import 'package:vreme/screens/vodotoki/list_vodotoki.dart';
import 'package:vreme/screens/vodotoki/vodotok_detail.dart';
import 'package:vreme/screens/vremenska_napoved/list_napoved.dart';
import 'package:vreme/screens/vremenska_napoved/napoved_detail.dart';
import 'package:vreme/screens/vremenske_razmere/list_postaje.dart';
import 'package:vreme/screens/vremenske_razmere/postaja.dart';
import 'package:workmanager/workmanager.dart';
import 'package:vreme/data/notification_services/local_notifications.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputdata) async {
    RestApi r = RestApi();
    BackgroundServices bs;
    int notificationId = int.parse(inputdata["notificationID"]);
    bs = BackgroundServices(notificationId);

    String id = inputdata["id"];
    switch (taskName) {
      case "vodotok":
        await bs.vodotokNotification(id);
        break;
      /*  */
      case "vremenske razmere":
        await bs.postajaNotification(id);
        break;
      /*  */
      case "napoved":
        await bs.napovedNotification(id);
        break;
      /*  */
      case "opozorilo":
        if(inputdata["show"] == "true")
          await bs.opozorilaNotification(id);
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Favorites favorites = Favorites();
  await favorites.setPreferences();

  Workmanager.cancelAll();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

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
        '/settings/customization/notifications': (context) =>
            ActiveNotificationsList(),
      },
      debugShowCheckedModeBanner: false,
    ));
  });
}
