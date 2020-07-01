import 'dart:collection';
import 'dart:core';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:workmanager/workmanager.dart';

class NotificationManager {
  static HashMap _notifications;
  static SettingsPreferences sp;

  NotificationManager() {
    if(sp == null) sp = SettingsPreferences();
    if (_notifications == null) {
      List<String> p = sp.getStringListSetting("active_notifications");
      _notifications = HashMap<String, int>();
      if(p != null)
        for(String s in p)
          _notifications[s] = computeHash(s);
    }
  }

  bool addNotification(String id, String type, Map<String, dynamic> inputdata, bool periodic, Duration period) {
    int calculatedHash = computeHash(id);
    _notifications[id] = calculatedHash;
    inputdata["notificationID"] = calculatedHash.toString();
    try {
      if(periodic)
      Workmanager.registerPeriodicTask(calculatedHash.toString(), type,
          inputData: inputdata, frequency: period);
      else
        Workmanager.registerOneOffTask(calculatedHash.toString(), type, inputData: inputdata);
      _saveToPreferences();
      return true;
    } catch (_) {
      return false;
    }
  }

  bool removeNotification(String id) {
    int h = _notifications[id];
    Workmanager.cancelByUniqueName(h.toString());
    _notifications.remove(id);
    _saveToPreferences();
    return true;
  }

  bool isEnabled(String id) {
    int h = _notifications[id];
    if(h != null)
      return true;
    else
      return false;
  }

  void _saveToPreferences() {
    List<String> keys = [];
    _notifications.forEach((key, value) {
      keys.add(key);
    });
    sp.setStringListSetting("active_notifications", keys);
  }

  final int hash = 7;
  int computeHash(String id) {
    int cal = hash;
    for (int i = 0; i < id.length; i++) {
      int t = id.codeUnitAt(i);
      cal = cal * 3 + t;
      if(cal > 2000000000)
        cal = (cal / 7).round();
    }
    return cal;
  }
}
