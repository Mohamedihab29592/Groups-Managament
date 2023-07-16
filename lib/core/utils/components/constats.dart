import 'dart:async';

import 'package:Administration/core/utils/components/textWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
void navigateAndKill(context, widget) => Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);




class Constants {
  static final inputFormat = DateFormat('dd MMM, yyyy');
}




class GlobalMethods{


  static FutureOr<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: const [
              Icon(
                Icons.error,
              ),
              SizedBox(
                width: 8,
              ),
              Text('An Error occurred'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: TextWidget(
                  color: Colors.cyan,
                  title: 'Ok',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  static String getFirebaseAuthErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
          return 'Wrong password';
        default:
          return 'An error occurred while logging in';
      }
    } else {
      return error.toString();
    }
  }


  static FutureOr<void> warningDialog({

    required String title,
    required String subTitle,
    required Function fct,
    required BuildContext context,



  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title:  Text(title),
              content:  Text(subTitle),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    },
                  child: TextWidget(
                    title: "Cancel",
                    color: Colors.cyan,
                    textSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    fct();
                    if(Navigator.canPop(context))
                    {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    title: "ok",
                    color: Colors.cyan,
                    textSize: 20,
                  ),
                )
              ]);
        });
  }




}