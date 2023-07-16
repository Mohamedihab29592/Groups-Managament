import 'package:Administration/presenation/pages/charts/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/utils/components/constats.dart';
import '../../../../core/utils/services/initernet connection.dart';
import '../../../../data/model/group.dart';

class ChartCubit extends Cubit<ChartStates> {
  ChartCubit() : super(ChartInitialState());

  static ChartCubit get(context) => BlocProvider.of(context);


  List<GroupTaskData> chartData = [];

  // Fetch data from Firestore and populate chartData
  void fetchDataFromFirestore(BuildContext co) async {
    emit(ChartLoadingState());

    if (await InternetConnection().hasInternet) {
      try{
        final collection = FirebaseFirestore.instance.collection('tasks');
        final snapshot = await collection.get();

        // Process the snapshot data and populate chartData
        final groupData = Map<String, GroupTaskData>();

        snapshot.docs.forEach((doc) {
          final taskData = doc.data();
          final groupName = taskData['group'] as String;
          final completedTasks = taskData['completed'] == 1 ? 1 : 0;
          final incompleteTasks = taskData['completed'] == 0 ? 1 : 0;

          if (groupData.containsKey(groupName)) {
            groupData[groupName]!.completedTasks += completedTasks;
            groupData[groupName]!.incompleteTasks += incompleteTasks;
          } else {
            groupData[groupName] =
                GroupTaskData(groupName, completedTasks, incompleteTasks);
          }
        });

        chartData = groupData.values.toList();
        emit(ChartSuccessState());



      }catch(error)
      {
        GlobalMethods.errorDialog(subtitle: error.toString(), context: co);

        emit(ChartErrorState(error.toString()));

      }


    } else {
      await Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "No Internet Connection!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
    }


  }
}
