import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../firebase_options.dart';
import '../../../main.dart';
import '../login/login.dart';

class NoInternetScreen extends StatefulWidget {
   NoInternetScreen({Key? key}) : super(key: key);

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  late StreamSubscription<InternetConnectionStatus> _subscription;
  bool _hasInternet = false;

  @override
  void initState() {
    super.initState();
    // Subscribe to internet connection changes
    _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _hasInternet = status == InternetConnectionStatus.connected;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel subscription when widget is disposed
    _subscription.cancel();
  }
  bool _isloading=false;
  FutureOr<void>_Reload ()
  async {setState(() {
    _isloading=true;
  });
    try{
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final initialScreen = LoginScreen();
      runApp(MyApp(initialScreen: initialScreen));
      setState(() {
        _isloading=false;
      });
    }
        catch(error)
    {
      debugPrint(error.toString());
      setState(() {
        _isloading=false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.signal_wifi_off, size: 100),
              SizedBox(height: 16),
              Text(
                'No internet connection',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isloading?CircularProgressIndicator():
                  ElevatedButton(
                    child: Text('Retry'),
                    onPressed: () async {
                      if (_hasInternet) {
                        // Internet connection is available, run the app
                       await _Reload ();

                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
