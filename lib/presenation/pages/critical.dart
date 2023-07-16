import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/primary_task_item.dart';

class Critical extends StatefulWidget {
  const Critical({Key? key}) : super(key: key);

  @override
  State<Critical> createState() => _CriticalState();
}

class _CriticalState extends State<Critical> {
  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.all(15),
            child: ConditionalBuilder(
              condition: cubit.allTasks
                  .where((element) => element.critical == 1)
                  .toList()
                  .isNotEmpty,
              builder: (BuildContext context) => ListView.builder(
                itemBuilder: (context, index) => PrimaryTaskItem(
                  task: TaskCubit.get(context)
                      .allTasks
                      .where((element) => element.critical == 1)
                      .toList()[index],
                ),
                itemCount: TaskCubit.get(context)
                    .allTasks
                    .where((element) => element.critical == 1)
                    .toList()
                    .length,
              ),
              fallback: (BuildContext context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.notification_important,
                    size: 50,
                    color: Colors.grey,
                  ),
                  Text('No Critical Tasks   ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      )),
                ],
              ),
            ));
      },
    );
  }
}
