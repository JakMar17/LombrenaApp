import 'package:firebase_messaging/firebase_messaging.dart';
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
      if (tokenOld == null || tokenOld.length == 0) 
        tokenOld = null;

      WarningsNaprava naprava =
          WarningsNaprava(fcmId: token, fcmIdOld: tokenOld);
      
      _marelaWarningQueries.prijavaUporabe(naprava).then((WarningsNaprava naprava) {
        _sp.setStringSetting(_sp.fcmToken, naprava.fcmId);
        _marelaWarningQueries.getMarelaWarningsNaroceno();
      });

      _initialized = true;
    }
  }
}
