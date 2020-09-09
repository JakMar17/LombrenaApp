import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/marelaWarningsAPI/dataHolders/warnings_naprava.dart';
import 'package:vreme/marelaWarningsAPI/marelaWarningQueries.dart';

class PushNotificationManager {
  MarelaWarningQueries _marelaWarningQueries;

  PushNotificationManager._();
  factory PushNotificationManager() => _instance;
  static final PushNotificationManager _instance = PushNotificationManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (_marelaWarningQueries == null)
      _marelaWarningQueries = MarelaWarningQueries();
    if (!_initialized) {
      //iOS specific
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      String token = await _firebaseMessaging.getToken();
      print(token);

      SettingsPreferences _sp = SettingsPreferences();
      String tokenOld = _sp.getStringSetting(_sp.fcmToken);
      if (tokenOld == null || tokenOld.length == 0) tokenOld = null;

      String osIme = "";
      String osVerzija = "";
      String osSdk;
      String appVerzija = "";
      String napravaProizvajalec;
      String napravaModel;

      /*
      ! tukaj nadaljuj
      */

      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var release = androidInfo.version.release;
        osIme = "Android";
        osVerzija = release;
        var sdkInt = androidInfo.version.sdkInt;
        osSdk = sdkInt.toString();
        var manufacturer = androidInfo.manufacturer;
        napravaProizvajalec = manufacturer;
        var model = androidInfo.model;
        napravaModel = model;
        print('Android $release (SDK $sdkInt), $manufacturer $model');
      }

      if (Platform.isIOS) {
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        var systemName = iosInfo.systemName;
        osIme = systemName;
        var version = iosInfo.systemVersion;
        osVerzija = version;
        var name = iosInfo.name;
        napravaProizvajalec = name;
        var model = iosInfo.model;
        napravaModel = model;
        print('$systemName $version, $name $model');
      }

      PackageInfo pi = await PackageInfo.fromPlatform();
      appVerzija = pi.version;

      WarningsNaprava naprava = WarningsNaprava(
          fcmId: token,
          fcmIdOld: tokenOld,
          osIme: osIme, osVerzija: osVerzija, appVerzija: appVerzija, napravaModel: napravaModel, napravaProizvajalec: napravaProizvajalec, osSdk: osSdk);

      _marelaWarningQueries
          .prijavaUporabe(naprava)
          .then((WarningsNaprava naprava) {
        _sp.setStringSetting(_sp.fcmToken, naprava.fcmId);
        _marelaWarningQueries.getMarelaWarningsNaroceno();
      });

      _initialized = true;
    }
  }
}
