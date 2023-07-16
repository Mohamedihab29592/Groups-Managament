import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnection
{
  Future<bool> hasInternet =  InternetConnectionChecker().hasConnection;

}