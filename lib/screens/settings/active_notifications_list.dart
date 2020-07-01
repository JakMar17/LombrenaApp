import 'package:flutter/material.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/notification_services/notification_manager.dart';
import 'package:vreme/data/shared_preferences/settings_preferences.dart';
import 'package:vreme/style/custom_icons.dart';

class ActiveNotificationsList extends StatefulWidget {
  ActiveNotificationsList({Key key}) : super(key: key);

  @override
  _ActiveNotificationsListState createState() =>
      _ActiveNotificationsListState();
}

class _ActiveNotificationsListState extends State<ActiveNotificationsList> {
  List<_NotificationHelperClass> _notifications = [];
  NotificationManager nm = NotificationManager();

  @override
  void initState() {
    super.initState();
    RestApi r = RestApi();
    List<String> x = nm.getAllNotifications();
    for (String t in x) {
      dynamic x = r.getNapoved(t);
      if (x == null) {
        x = r.getPostaja(t);
        if (x == null) {
          x = r.getVodotok(t);
          if (x == null) {
            nm.removeNotification(x);
          } else {
            _notifications.add(_NotificationHelperClass(
                id: t, title: "${x.merilnoMesto} (${x.reka})"));
          }
        } else {
          _notifications
              .add(_NotificationHelperClass(id: t, title: "${x.titleLong}"));
        }
      } else {
        _notifications
            .add(_NotificationHelperClass(id: t, title: "${x.categoryName}"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Upravljanje z obvestili",
            style: TextStyle(fontFamily: "Montserrat"),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              color: Colors.white,
              onPressed: () => removeAndExit(),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
            child: _notifications.length != 0
                ? ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      if (!_notifications[index].removed)
                        return GestureDetector(
                          onTap: () => addToBeRemoved(_notifications[index]),
                          child: Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 10,
                                    child: Text(
                                      _notifications[index].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          addToBeRemoved(_notifications[index]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                    })
                : Center(
                    child: Text(
                      "Nimate aktivnih opozoril",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: 32,
                          fontWeight: FontWeight.w200),
                    ),
                  )),
      ),
    );
  }

  void addToBeRemoved(_NotificationHelperClass n) {
    setState(() {
      n.removed = true;
    });
  }

  void removeAndExit() {
    for (_NotificationHelperClass n in _notifications)
      if (n.removed) nm.removeNotification(n.id);
    Navigator.pop(context);
  }
}

class _NotificationHelperClass {
  String id;
  String title;
  bool removed;

  _NotificationHelperClass({this.id, this.title}) {
    removed = false;
  }
}
