import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved.dart';
import 'package:vreme/data/models/opozorila.dart';
import 'package:vreme/data/models/postaja.dart';
import 'package:vreme/data/models/vodotok_postaja.dart';
import 'package:vreme/data/notification_services/local_notifications.dart';
import 'package:vreme/data/notification_services/notification_manager.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';

class BackgroundServices {
  static RestApi r;
  LocalNotifications _ln;
  static SettingsPreferences sp;

  BackgroundServices(int notificationID) {
    if (r == null) r = RestApi();
    if (_ln == null && notificationID != null) _ln = LocalNotifications(notificationID);
    if (sp == null) sp = SettingsPreferences();
  }

  Future<void> vodotokNotification(String id) async {
    await r.fetchVodotoki();
    MerilnoMestoVodotok m = r.getVodotok(id);
    String body = "";

    if (m.pretokZnacilni != null)
      body += m.pretokZnacilni + " (${m.pretok} m3/s)";
    else if (m.vodostajZnacilni != null)
      body += m.vodostajZnacilni + " (${m.vodostaj} cm)";

    if (m.tempVode != null) body += "\nTemperatura vode: ${m.tempVode} °C";
    _ln.showNotification(title: "${m.merilnoMesto} (${m.reka})", body: body);
    return true;
  }

  Future<void> postajaNotification(String id) async {
    await r.fetchPostajeData();
    Postaja p = r.getPostaja(id);
    String body = "";
    if (p.temperature != null) body += "${p.temperature}°C ";
    if (p.windSpeed != null) body += "${p.windSpeed}km/h ";
    if (p.rain != null && p.rain != 0) if (p.snow != null && p.snow != 0)
      body += "${p.rain}mm (${p.snow} cm)";
    _ln.showNotification(title: "${p.titleLong}", body: body);
  }

  Future<void> napovedNotification(String id) async {
    await r.fetch3DnevnaNapoved();
    await r.fetch5DnevnaNapoved();
    await r.fetchPokrajinskaNapoved();
    NapovedCategory n = r.getNapoved(id);
    String body = "";
    if (n.napovedi[0].temperature != null)
      body += "${n.napovedi[0].temperature}°C ";
    else if (n.napovedi[0].tempMin != null)
      body += "${n.napovedi[0].tempMin} - ${n.napovedi[0].tempMax}°C ";
    if (n.napovedi[0].minWind != null) if (n.napovedi[0].minWind == 0 &&
        n.napovedi[0].maxWind == 0)
      body += "0 km/h";
    else
      body += "${n.napovedi[0].minWind} - ${n.napovedi[0].maxWind}km/h";
    _ln.showNotification(title: "${n.categoryName}", body: body);
  }

  Future<void> opozorilaNotification(String id) async {

    _ln.showNotification(title: id, body: id);

    /* print(id);
    NotificationManager m = NotificationManager();
    await r.fecthWarnings();
    List<WarningRegion> regions = r.getWarnings();
    List<String> regionsToBeNotified = sp.getStringListSetting("settings_warnings_notify_regions");
    int levelToBeNotified;
    switch(sp.getStringSetting("settings_warnings_notify_level")) {
      case "yellow":
        levelToBeNotified = 2;
        break;
      case "orange":
        levelToBeNotified = 3;
        break;
      case "red":
        levelToBeNotified = 4;
    }

    for(WarningRegion region in regions) {
      if(regionsToBeNotified.contains(region.region)) {
        for(Warning w in region.warnings) {
          if(DateTime.now().difference(w.onset).inSeconds >= 0 && DateTime.now().difference(w.expires).inSeconds <= 0) {
            if(w.level >= levelToBeNotified) {
              String title = "";
              if(w.level == 2)
                title += "Rumeno ";
              else if (w.level == 3)
                title += "Oranžno ";
              else
                title += "Rdeče ";
              
              title += "opozorilo za ${w.title} (${region.region})";
              String body = w.description;

              LocalNotifications ln = LocalNotifications(m.computeHash("${region.region}${w.title}"));
              ln.showNotification(title: title, body: body);
            }
          }
        }
    }  } */
    
  }
}
