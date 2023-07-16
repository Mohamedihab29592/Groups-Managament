/*
import 'dart:async';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../main.dart';
import '../../../../presenation/pages/Schedule.dart';
import 'FCMNotification.dart';

class NotifyHelper {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  FutureOr<void> initializeNotification() async {



    tz.initializeTimeZones();
    configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
      iOS: iosInitializationSettings,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
  const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    icon: '@mipmap/ic_launcher',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    colorized: true,
    playSound: true,
  );
  final DarwinNotificationDetails _iOSNotificationDetails =
  const DarwinNotificationDetails();

  FutureOr<void> scheduledNotification({
    required String title,
    required DateTime taskDateTime,
    required int taskId,
  }) async {
    if (taskDateTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        taskId,
        'Follow Up',
        '$title at ${taskDateTime.hour}:${taskDateTime.minute}',
        convertTime(taskDateTime),
        NotificationDetails(
          android: _androidNotificationDetails,
          iOS: _iOSNotificationDetails,
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode({
          "notificationSource": "local"
        }), // Add this line to include notificationSource field

      );



    }
  }

  tz.TZDateTime convertTime(DateTime dateTime) {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    return scheduledDate;
  }

  FutureOr<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  FutureOr<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  FutureOr<void> selectNotification(String? payload, int id) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    } else {
      debugPrint("Notification Done");
    }
    await Navigator.push(
        MyApp.navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => Schedule(
              taskId: id,
            )));
  }
}

late BuildContext context;

FutureOr<void> onDidReceiveLocalNotification(
  int? id,
  String? title,
  String? body,
  String? payload,
) async {


  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {
            //  Navigator.of(context, rootNavigator: true).pop();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Schedule(
                  taskId: id!,
                ),
              ),
            );
          },
        )
      ],
    ),
  );
}
*/
