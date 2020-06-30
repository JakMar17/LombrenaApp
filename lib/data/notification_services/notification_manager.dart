import 'dart:collection';
import 'dart:core';

import 'package:workmanager/workmanager.dart';

class NotificationManager {
  static HashMap _notifications;

  NotificationManager() {
    if (_notifications == null) _notifications = HashMap<String, int>();
  }

  bool addNotification(String id, String type, Map<String, dynamic> inputdata, bool periodic) {
    int calculatedHash = computeHash(id);
    _notifications[id] = calculatedHash;
    inputdata["notificationID"] = calculatedHash.toString();
    try {
      if(periodic)
      Workmanager.registerPeriodicTask(calculatedHash.toString(), type,
          inputData: inputdata);
      return true;
    } catch (_) {
      return false;
    }
  }

  final int hash = 7;
  int computeHash(String id) {
    int cal = 0;
    for (int i = 0; i < id.length; i++) {
      int t = id.codeUnitAt(i);
      cal = cal * 3 + t;
    }
    return cal;
  }
}
