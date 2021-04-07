import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotifications() {
    initializing();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  void initializing() async {
    AndroidInitializationSettings androidInitializationSettings;
    IOSInitializationSettings iosInitializationSettings;
    InitializationSettings initializationSettings;

    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> cancelNotifications() async {
    return await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> removeNotificationID(int notificationID) async {
    return await flutterLocalNotificationsPlugin.cancel(notificationID);
  }

  Future<void> removeReminder(TimeOfDay time) async {
    return await flutterLocalNotificationsPlugin
        .cancel(time.hour * 60 + time.minute); // change to the ID of the reminder; todo: 
  }

  /*
  Future<void> showAllNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return showDialog<void>(
      //context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
            Text('${pendingNotificationRequests.length} pending notification '
                'requests'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }*/


  void addReminder(DateTime time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      time.hour+time.minute+time.second, 
      "Hello",
      "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}", 
      Time(time.hour, time.minute, time.second), notificationDetails);
  }
}
