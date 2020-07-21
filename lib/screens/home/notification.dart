import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vreme/screens/home/home.dart';
import '../../data/notification_services/local_notification_helper.dart';

class NotificationTest extends StatefulWidget {
  NotificationTest({Key key}) : super(key: key);

  @override
  _NotificationTestState createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));
    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String payload) async {
    /* await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home())); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            showOngoingNotification(notifications,
                title: "Title", body: "Body");
          },
          child: Text("Press for magic"),
        ),
      ),
    );
  }
}
