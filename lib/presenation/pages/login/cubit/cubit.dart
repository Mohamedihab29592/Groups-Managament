import 'dart:async';

import 'package:Administration/presenation/pages/login/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/components/constats.dart';
import '../../../../core/utils/services/initernet connection.dart';
import '../login.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> userLogin({
    required String email,
    required String password,
    required BuildContext co,
  }) async {
    emit(LoginLoadingState());
    if (await InternetConnection().hasInternet) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Retrieve user information from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        // Check if user exists in Firestore
        if (userSnapshot.exists) {
          String group = userSnapshot.get('group');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('group', group);

          await saveToken();
          await subscribeToTopic(group: group);

          emit(LoginSuccessState(userCredential.user!.uid, group));
          return group;
        } else {
          emit(LoginErrorState('User not found.'));
          return '';
        }
      } catch (error) {
        String errorMessage = GlobalMethods.getFirebaseAuthErrorMessage(error);
        emit(LoginErrorState(errorMessage));
        GlobalMethods.errorDialog(subtitle: errorMessage, context: co);
        return '';
      }
    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(LoginErrorState('User not found.'));

      return '';
    }
  }

  Future<void> addUser({
    required String email,
    required String name,
    required String password,
    required String Group,
    required BuildContext co,
  }) async {
    emit(RegisterLoadingState());
    if (await InternetConnection().hasInternet) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,

        );

        // Create a new document in Firestore with the user's information
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'password': password,
          'group': Group,
        });
        emit(RegisterSuccessState());
        await Fluttertoast.showToast(
          backgroundColor: Colors.blue,
          msg: "User Added Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          GlobalMethods.errorDialog(subtitle: "The password provided is too weak.", context: co);
          emit(RegisterErrorState());

        } else if (e.code == 'email-already-in-use') {
          GlobalMethods.errorDialog(subtitle: "The account already exists for that email.", context: co);
          emit(RegisterErrorState());

        }
      } catch (error) {
        String errorMessage = GlobalMethods.getFirebaseAuthErrorMessage(error);
        emit(RegisterErrorState());
        GlobalMethods.errorDialog(subtitle: errorMessage, context: co);

      }
    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(RegisterErrorState());


    }
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SeePassState());
  }

  Future<void> signOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? group = prefs.getString('group');

      await FirebaseAuth.instance.signOut();

      navigateAndKill(context, LoginScreen());
      prefs.remove('token');
      prefs.remove('group');
      await _firebaseMessaging.unsubscribeFromTopic(group!);
    } catch (e) {
      // Handle sign-out errors
      debugPrint(e.toString());
    }
  }

  Future<void> saveToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String token = await user.getIdToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }
  }

  Future<String> subscribeToTopic({required String group}) async {
    if (group == 'SOC') {
      await _firebaseMessaging.subscribeToTopic('SOC');
      debugPrint("SOC");
    } else if (group == 'BTS') {
      await _firebaseMessaging.subscribeToTopic('BTS');
      debugPrint("BTS");
    } else if (group == 'PS') {
      await _firebaseMessaging.subscribeToTopic('PS');
      debugPrint("PS");
    } else if (group == 'All') {
      await _firebaseMessaging.subscribeToTopic('All');
      debugPrint("All");
    }
    return group;
  }


  Future<void> changePassword({
    required String email,
    required String OldPass,
    required String NewPass,
    required BuildContext co,
  }) async {
    emit(LoadingPasswordState());
    if (await InternetConnection().hasInternet) {
      try {
        // Reauthenticate the user with their old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: OldPass,
        );
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Update the user's password with the new password
        User? user = userCredential.user;
        await user!.updatePassword(NewPass);

        // Update Firestore data with new password
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'password': NewPass});

        emit(ChangePasswordState());

        // Password changed successfully, display a success message or navigate to a different screen
      } catch (error) {
        // Handle any errors that occur during the password change process
        String errorMessage = GlobalMethods.getFirebaseAuthErrorMessage(error);
        GlobalMethods.errorDialog(subtitle: errorMessage, context: co);
        debugPrint(errorMessage);
        emit(ErrorPasswordState(errorMessage));
      }
    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(ErrorPasswordState("No Internet"));
    }
  }

}