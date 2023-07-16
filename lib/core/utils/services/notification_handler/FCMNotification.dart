import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';


class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;



  void openAppNotificationSettings() {
    OpenSettings.openAppNotificationSetting();
  }


  FutureOr<void> requestPermission( BuildContext context) async {



    final status = await _firebaseMessaging.requestPermission();
    debugPrint("requestPermission");


    if (status == PermissionStatus.granted) {
      debugPrint("access granted");
    } else if (status == PermissionStatus.denied) {
      debugPrint("access denied");


      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Notification Permissions Required'),
            content: Text('Please grant notification permissions to receive updates.'),
            actions: [
              TextButton(
                onPressed: openAppNotificationSettings,
                child: Text('Open Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else if (status == PermissionStatus.permanentlyDenied) {
      debugPrint("access permanentlyDenied");

      // Show a dialog directing the user to the settings page to enable notifications
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notification Permissions Required'),
            content: Text('Please enable notifications for this app in the device settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }




  /*final HttpsCallable scheduleNotificationCallable =
  FirebaseFunctions.instance.httpsCallable('scheduleNotification');

  Future<void> scheduleNotification(
      {required String title,required String dec,required DateTime dateTime}) async {
    try {
      final result = await scheduleNotificationCallable.call({
        'title': title,
        'body': dec,
        'dateTime': dateTime.toUtc().toIso8601String(),
        'topic': "all_users",
      });
      print(result.data);
    } on FirebaseFunctionsException catch (e) {
      print('Error calling scheduleNotification: ${e.message}');
    } catch (e) {
      print('Error calling scheduleNotification: $e');
    }
  }*/


}
