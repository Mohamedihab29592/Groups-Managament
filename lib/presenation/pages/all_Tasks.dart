import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/primary_task_item.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({Key? key}) : super(key: key);

  @override
  State<AllTasks> createState() => _AllTasksState();
}


class _AllTasksState extends State<AllTasks> {

  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);

    return BlocBuilder<TaskCubit, TaskState>(


      builder: (context, state) {
          return ConditionalBuilder(condition: cubit.allTasks.isNotEmpty, builder: (context)=> Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemBuilder: (context, index) => PrimaryTaskItem(
                task: cubit.allTasks[index],
              ),
              itemCount: cubit.allTasks.length,
            ),
          ),
              fallback:(context)=>  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [


                  Icon(
                    Icons.edit,
                    size: 50,
                    color: Colors.grey,
                  ),
                  Text('No Tasks   ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      )),
                ],
              ));


      },
    );
  }
}
