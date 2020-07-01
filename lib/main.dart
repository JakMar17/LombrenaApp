import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/shared_preferences/favorites.dart';
import 'package:vreme/screens/custom_search.dart';
import 'package:vreme/screens/drawer/about_app.dart';
import 'package:vreme/screens/home/home.dart';
import 'package:vreme/screens/home/loading.dart';
import 'package:vreme/screens/home/reordering_favorites.dart';
import 'package:vreme/screens/maps/map.dart';
import 'package:vreme/screens/opozorila/list_opozorila.dart';
import 'package:vreme/screens/opozorila/opozorilo_detail.dart';
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
import './screens/home/notification.dart';
import 'package:vreme/data/notification_services/local_notifications.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputdata) async {
    RestApi r = RestApi();
    int notificationId = int.parse(inputdata["notificationID"]);
    LocalNotifications _ln = LocalNotifications(notificationId);
    String id = inputdata["id"];
    switch (taskName) {
      case "vodotok":
        await r.fetchVodotoki();
        MerilnoMestoVodotok m = r.getVodotok(id);
        String body = "";

        if (m.pretokZnacilni != null)
          body += m.pretokZnacilni + " (${m.pretok} m3/s)";
        else if (m.vodostajZnacilni != null)
          body += m.vodostajZnacilni + " (${m.vodostaj} cm)";

        if (m.tempVode != null) body += "\nTemperatura vode: ${m.tempVode} °C";
        _ln.showNotification(
            title: "${m.merilnoMesto} (${m.reka})", body: body);
        break;
      /*  */
      case "vremenske razmere":
        await r.fetchPostajeData();
        Postaja p = r.getPostaja(id);
        String body = "";
        if(p.temperature !=  null) body += "${p.temperature}°C ";
        if(p.windSpeed != null) body += "${p.windSpeed}km/h ";
        if(p.rain != null && p.rain != 0)
          if(p.snow != null && p.snow != 0)
            body += "${p.rain}mm (${p.snow} cm)";
        _ln.showNotification(title: "${p.titleLong}", body: body);
        break;
      /*  */
      case "napoved":
        await r.fetch3DnevnaNapoved();
        await r.fetch5DnevnaNapoved();
        await r.fetchPokrajinskaNapoved();
        NapovedCategory n = r.getNapoved(id);
        String body = "";
        if(n.napovedi[0].temperature != null) body += "${n.napovedi[0].temperature}°C ";
        else if(n.napovedi[0].tempMin != null) body += "${n.napovedi[0].tempMin} - ${n.napovedi[0].tempMax}°C ";
        if(n.napovedi[0].minWind != null) 
          if(n.napovedi[0].minWind == 0 && n.napovedi[0].maxWind == 0)
            body += "0 km/h";
          else
            body += "${n.napovedi[0].minWind} - ${n.napovedi[0].maxWind}km/h";
        _ln.showNotification(title: "${n.categoryName}", body: body);
        break;
      
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Favorites favorites = Favorites();
  await favorites.setPreferences();

  Workmanager.initialize(callbackDispatcher, isInDebugMode: false);

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
        '/test/notifications': (context) => NotificationTest(),
      },
      debugShowCheckedModeBanner: false,
    ));
  });
}
