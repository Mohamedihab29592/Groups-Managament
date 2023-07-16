import 'dart:async';


import 'package:Administration/presenation/cubit/cubit.dart';
import 'package:Administration/presenation/pages/charts/cubit/cubit.dart';
import 'package:Administration/presenation/pages/layout/board.dart';
import 'package:Administration/presenation/pages/layout/no%20Internet.dart';
import 'package:Administration/presenation/pages/login/RegisterManger.dart';
import 'package:Administration/presenation/pages/login/cubit/cubit.dart';
import 'package:Administration/presenation/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/services/initernet connection.dart';
import 'core/utils/services/notification_handler/FCMNotification.dart';
import 'firebase_options.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future<bool> hasInternet = InternetConnection().hasInternet;
  if (await hasInternet) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Check if the user is already logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? group = prefs.getString('group');

    Widget initialScreen;
    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to the BoardScreen
      initialScreen = Board(
        groupTitle: group,
      );
    } else {
      // User is not logged in, navigate to the LoginScreen
      initialScreen =
      LoginScreen();
    }

    runApp(MyApp(
      initialScreen: initialScreen,
    ));
  } else {
    // Handle case where there is no internet connection
    runApp(NoInternetScreen());
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({
    Key? key,
    required this.initialScreen,
  }) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NotificationService().requestPermission(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit()..getTasksData(context),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<ChartCubit>(
          create: (context) => ChartCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        home:initialScreen,
      ),
    );
  }
}
