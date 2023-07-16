import 'dart:async';

import 'package:Administration/presenation/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../core/utils/components/constats.dart';
import '../../core/utils/services/initernet connection.dart';
import '../../data/model/task_model.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskCubitInitialState());

  static TaskCubit get(context) => BlocProvider.of(context);


  int isCritical = 0;
  void setCritical(index) {
    if(index == false)
      {
        isCritical = 0;
      }
    if(index == true)
      isCritical = 1;


    emit(CriticalChange());
  }



  List<TaskModel> allTasks = [];

  int selectedColor = 0;
  List<MaterialColor> taskColors = [
    Colors.blue,
    Colors.orange,
    Colors.red,
  ];




  void changeColor(index) {
    selectedColor = index;
    emit(TaskColorChanged());
  }

  var titleController = TextEditingController();
  var decController = TextEditingController();
  var actionController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  int ID() {
    var uuid = Uuid().v4().substring(0, 8); // Use only first 8 characters
    var id = int.parse(uuid, radix: 16) & 0x7FFFFFFF; // Parse as hex integer
    return id;
  }

  FutureOr<void> insertDatabase(BuildContext cxt) async {
    emit(AppLoadingInsertDataBaseState());
    if (await InternetConnection().hasInternet) {
      late int id = ID();
      String title = titleController.text;
      String time = timeController.text;
      String action = actionController.text;
      String dec = decController.text;
      String date = dateController.text;
      int criticalValue = isCritical ;
      DateTime dateTime =
          DateFormat('dd MMM, yyyy hh:mm a').parse('$date $time');
      Timestamp timestamp =
          Timestamp.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? group = prefs.getString('group');

      if (dateTime.isBefore(DateTime.now())) {
        GlobalMethods.errorDialog(
            subtitle: "Task date/time cannot be in the past", context: cxt);

        emit(InsertDateBaseError());
        return ;
      }
      try {
        // Retrieve the user's name from Firestore
        User? currentUser = FirebaseAuth.instance.currentUser;
        String? name;

        if (currentUser != null) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          if (userSnapshot.exists) {
            name = userSnapshot.get('name');
          }
        }
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(id.toString())
            .set({
          'id': id,
          'title': title,
          'description': dec,
          'date': date,
          'time': time,
          'action taken': action,
          'color': selectedColor,
          'critical': criticalValue,
          'completed': 0,
          'user': name,
          'timeStamp': timestamp,
          'group': group,
        });

        await getTasksData(cxt);
        await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Task has been added Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        emit(AppInsertDateBaseDone());
      } catch (error) {
        GlobalMethods.errorDialog(
            subtitle: 'contact the Developer !!', context: cxt);
        emit(InsertDateBaseError());
      }
    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(InsertDateBaseError());
    }
  }

  FutureOr<void> updateTask(
      {required int id,
      required String title,
      required String date,
      required String time,
      required String action,
      required String dec,
      required int color,
      required BuildContext cxt}) async {
    emit(UpdateDatabaseLoading());
    if (await InternetConnection().hasInternet) {
      DateTime dateTime =
          DateFormat('dd MMM, yyyy hh:mm a').parse('$date $time');
      Timestamp timestamp =
          Timestamp.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);

      if (dateTime.isBefore(DateTime.now())) {
        GlobalMethods.errorDialog(
            subtitle: "Task date/time cannot be in the past", context: cxt);
        emit(UpdateDatabaseError());
        return ;
      }
      try {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(id.toString())
            .update({
          'title': title,
          'description': dec,
          'date': date,
          'time': time,
          'action taken': action,
          'color': selectedColor,
          'critical': 0,
          'completed': 0,
          'timeStamp': timestamp,
        });
        await getTasksData(cxt);
        await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Task has been added Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        emit(UpdateDatabaseDone());
      } catch (error) {
        emit(UpdateDatabaseError());

        GlobalMethods.errorDialog(
            subtitle: 'contact the Developer !!', context: cxt);
        debugPrint(error.toString());
      }
    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(UpdateDatabaseError());
    }
  }

  void selectTaskToUpdate({
    required TaskModel task,
  }) {
    titleController.text = task.title;
    dateController.text = task.date;
    timeController.text = task.time;
    decController.text = task.description;
    actionController.text = task.action;
    selectedColor = task.colorPriority;

    emit(AppSelectTask());
  }

  Future<void> updateCompleteTask(int taskId, BuildContext co) async {
    emit(AppLoadingState());

    try {
      int completed =
          allTasks.firstWhere((element) => element.id == taskId).completed == 1
              ? 0
              : 1;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId.toString())
          .update({
        'completed': completed,
      }).then((value) async {
        await getTasksData(co);
        await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Task Data Updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      });
      emit(CompleteTasksState());
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: co);
      emit(CompleteErrorState());
    }
  }

  Future<void> updateCriticalTask(int taskId, BuildContext co) async {
    emit(AppLoadingState());

    try {
      int critical =
          allTasks.firstWhere((element) => element.id == taskId).critical == 1
              ? 0
              : 1;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId.toString())
          .update({
        'critical': critical,
      }).then((value) async {
        await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Task Data Updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        await getTasksData(co);
        emit(criticalTasksState());
      });
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: co);
      emit(criticalErrorState());
    }
  }

  FutureOr<void> deleteData({required int id, required BuildContext co}) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(id.toString())
        .delete()
        .then((value) async {
      emit(AppLoadingState());

      await getTasksData(co);
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "Task Data Deleted",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(AppDeleteDataBase());
    });
  }

  Future<void> getTasksData(BuildContext co) async {
    emit(AppLoadingState());
    if (await InternetConnection().hasInternet) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userGroup = prefs.getString('group');
        Query tasksQuery = FirebaseFirestore.instance.collection('tasks');

        if (userGroup != "MANAGER") {
          tasksQuery = tasksQuery.where('group', isEqualTo: userGroup);
        }

        await tasksQuery.get().then((QuerySnapshot tasksSnapshot) {
          allTasks.clear();
          if (tasksSnapshot.docs.isEmpty) {
            emit(AppNoDataTasks());
          } else {
            for (var element in tasksSnapshot.docs) {
              allTasks.insert(
                0,
                TaskModel(
                  id: element.get('id'),
                  title: element.get('title'),
                  date: element.get('date'),
                  time: element.get('time'),
                  description: element.get('description'),
                  action: element.get('action taken'),
                  colorPriority: element.get('color'),
                  user: element.get('user'),
                  completed: element.get('completed'),
                  critical: element.get('critical'),
                  timeStamp: element.get('timeStamp'),
                  group: element.get('group'),
                ),
              );
            }
            emit(AppDataBaseTasks());
          }
        });
      } catch (error) {
        GlobalMethods.errorDialog(
            subtitle: "contact the Developer !!", context: co);
        debugPrint(error.toString());
        emit(AppErrorTasks());
      }
    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      emit(AppErrorTasks());
    }
  }
}
