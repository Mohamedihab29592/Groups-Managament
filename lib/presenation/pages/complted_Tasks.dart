
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/primary_task_item.dart';

class CompletedTasks extends StatefulWidget {
  const CompletedTasks({Key? key}) : super(key: key);

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {

  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: ConditionalBuilder(
            condition:cubit
                .allTasks
                .where((element) => element.completed == 1)
                .toList().isNotEmpty ,
            builder: (context) =>  ListView.builder(
               itemBuilder: (context, index) =>
                   PrimaryTaskItem(
                     task: cubit
                         .allTasks.where((element) => element.completed == 1)
                         .toList()[index],
                   ),
               itemCount: cubit
                   .allTasks.where((element) => element.completed == 1)
                   .toList()
                   .length,
             ),
            fallback: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.check_box_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
                Text('No Completed Tasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    )),
              ],
            ),
          ) ,

        );
      },
    );
  }
}
