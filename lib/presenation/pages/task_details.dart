import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/components/MyFormField.dart';
import '../../core/utils/components/PublicButton.dart';
import '../../core/utils/components/TimePicker.dart';
import '../../core/utils/components/datePicker.dart';
import '../../core/utils/components/loading_manager.dart';
import '../../data/model/task_model.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class TaskDetails extends StatefulWidget {
  final TaskModel task;

  TaskDetails({
    Key? key,
    required this.task,

  }) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {




  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            )),
        title: const Text(
          'Task Details',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(listener: (context, state) {
        if (state is UpdateDatabaseDone) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        return LoadingManager(
          color: Colors.white,
          isLoading: state is UpdateDatabaseLoading,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyFormField(
                          maxLines: 1,
                          title: 'Task Title',
                          type: TextInputType.text,
                          hint: widget.task.title,
                          readonly: false,
                          controller: cubit.titleController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyDatePicker(
                          controller: cubit.dateController,
                          title: "Date",
                          hint: widget.task.date,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTimePicker(
                          controller: cubit.timeController,
                          title: "Time Reminder",
                          hint: widget.task.time,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyFormField(
                                maxLines: null,
                                title: 'Issue Details',
                                type: TextInputType.text,
                                hint: widget.task.description,
                                readonly: false,
                                controller: cubit.decController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyFormField(
                          maxLines: null,
                          title: 'Action Taken',
                          readonly: false,
                          controller: cubit.actionController,
                          type: TextInputType.text,
                          hint: widget.task.action,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyFormField(
                          maxLines: 1,
                          type: TextInputType.text,
                          hint: widget.task.user,
                          readonly: true,
                          title: "Started By",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Priority Level',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                ...TaskCubit.get(context)
                                    .taskColors
                                    .asMap()
                                    .map(
                                      (key, value) => MapEntry(
                                        key,
                                        IconButton(
                                          onPressed: () {
                                            TaskCubit.get(context)
                                                .changeColor(key);
                                          },
                                          icon: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                TaskCubit
                                                    .get(context)
                                                    .selectedColor ==
                                                            key
                                                        ? Colors.green
                                                        : Colors.transparent,
                                                width: 3.0,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                color: value,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PublicButton(
                    backgroundColor: Colors.blue,
                    function: () async {
                      await TaskCubit.get(context).updateTask(
                          id: widget.task.id,
                          title: TaskCubit.get(context).titleController.text,
                          date: TaskCubit.get(context).dateController.text,
                          time: TaskCubit.get(context).timeController.text,
                          dec: TaskCubit.get(context).decController.text,
                          action: TaskCubit.get(context).actionController.text,
                          color: widget.task.colorPriority,
                          cxt: context);
                    },
                    text: 'Update Task',
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
