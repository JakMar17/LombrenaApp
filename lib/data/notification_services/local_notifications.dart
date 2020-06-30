import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:workmanager/workmanager.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin notifications;
  int notificationID;

  LocalNotifications(int id) {
    if (notifications == null) _initialization();
    notificationID = id;
  }

  void _initialization() {
    notifications = FlutterLocalNotificationsPlugin();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            (onSelectNotification(payload)));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String payload) async {
    /* await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home())); */
  }

  NotificationDetails get _ongoing {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'marelaApp_id',
      'MarelaApp',
      'MarelaApp',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: false,
    );
    final iOSChannelSpecifics = IOSNotificationDetails();
    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
  }

  Future showNotification({
    @required String title,
    @required String body,
    int id = 0,
  }) {
    _showNotification(notifications,
        title: title, body: body, id: notificationID, type: _ongoing);
  }

  Future _showNotification(
    FlutterLocalNotificationsPlugin notifications, {
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 0,
  }) =>
      notifications.show(id, title, body, type);
}