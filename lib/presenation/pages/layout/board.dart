import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/components/PublicButton.dart';
import '../../../core/utils/components/constats.dart';
import '../../../core/utils/components/divider.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../Schedule.dart';
import '../add_TaskScreen.dart';
import '../all_Tasks.dart';
import '../charts/charts.dart';
import '../complted_Tasks.dart';
import '../critical.dart';
import '../login/RegisterManger.dart';
import '../login/cubit/cubit.dart';
import '../unCompleted.dart';

class Board extends StatefulWidget {
  final String? groupTitle;

  Board({Key? key, required this.groupTitle}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool _isAllGroup = false;

  @override
  void initState() {

    if (widget.groupTitle == 'MANAGER') {
      setState(() {
        _isAllGroup = true;
      });
    }

    TaskCubit.get(context).getTasksData(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var cubit = TaskCubit.get(context);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              title:  Text(_isAllGroup ?
                "Manager Account":widget.groupTitle! + " Tasks",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                _isAllGroup? IconButton(
                  onPressed: () async {
                    navigateTo(context, RegisterScreen());
                  },
                  icon: const Icon(Icons.add_rounded),
                ):Icon(null),
                IconButton(
                  onPressed: () async {
                    await TaskCubit.get(context).getTasksData(context);
                  },
                  icon: state is AppLoadingState
                      ? CircularProgressIndicator()
                      : Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    navigateTo(context, Schedule(taskId: cubit.allTasks[0].id));
                  },
                  icon: const Icon(Icons.calendar_today),
                ),

                IconButton(
                  onPressed: () async {
                    await LoginCubit.get(context).signOut(context);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Column(
              children: [
                const MyDivider(),
                const TabBar(
                  labelPadding: EdgeInsets.all(6),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'All Tasks'),
                    Tab(text: 'unCompleted'),
                    Tab(text: 'Critical'),
                    Tab(text: 'Completed'),
                  ],
                ),
                const MyDivider(),
                Expanded(
                  child: TabBarView(
                    children: [
                      AllTasks(),
                      UnCompleted(),
                      Critical(),
                      CompletedTasks(),
                    ],
                  ),
                ),
                if (_isAllGroup == false)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: PublicButton(
                        backgroundColor: Colors.blue,
                        function: () {
                          cubit.timeController.clear();
                          cubit.titleController.clear();
                          cubit.decController.clear();
                          cubit.actionController.clear();
                          cubit.dateController.clear();
                          cubit.timeController.clear();
                          cubit.selectedColor = 0;
                          cubit.isCritical =0;
                          navigateTo(context, const AddTask());
                        },
                        text: 'Add Task',
                      ),
                    ),
                  ),
                if (_isAllGroup == true)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: PublicButton(
                        backgroundColor: Colors.blue,
                        function: () {
                          navigateTo(context, TasksChart());
                        },
                        text: 'Charts',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
