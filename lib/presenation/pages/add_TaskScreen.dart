
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/components/MyFormField.dart';
import '../../core/utils/components/PublicButton.dart';
import '../../core/utils/components/TimePicker.dart';

import '../../core/utils/components/datePicker.dart';
import '../../core/utils/components/loading_manager.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var formKey = GlobalKey<FormState>();

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
          'Add Task',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(listener: (context, state) {
        if (state is AppInsertDateBaseDone) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        return LoadingManager(
          color: Colors.white,
          isLoading: state is AppLoadingInsertDataBaseState,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyFormField(
                              textCapitalization: TextCapitalization.none,
                              maxLines: null,
                              title: 'Title',
                              readonly: false,
                              controller: cubit.titleController,
                              type: TextInputType.text,
                              hint: 'Enter Title',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              validation: (value) {
                                if (value.isEmpty) {
                                  return " title can not be empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //DataPicker
                            MyDatePicker(
                              controller: cubit.dateController,
                              title: "Follow Up Date",
                              hint: "01 Jan,2023",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyTimePicker(
                              controller: cubit.timeController,
                              title: "Time Reminder",
                              hint: '12:00 AM',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: MyFormField(
                                    textCapitalization: TextCapitalization.none,
                                    maxLines: null,
                                    title: 'issue Details',
                                    readonly: false,
                                    controller: cubit.decController,
                                    type: TextInputType.text,
                                    hint: 'Enter issue details',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    validation: (value) {
                                      if (value.isEmpty) {
                                        return " details can not be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            MyFormField(
                              textCapitalization: TextCapitalization.none,
                              maxLines: null,
                              title: 'Action Taken',
                              readonly: false,
                              controller: cubit.actionController,
                              type: TextInputType.text,
                              hint: 'Issue Escalated to ..',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              validation: (value) {
                                if (value.isEmpty) {
                                  return " Action Taken can not be empty";
                                }
                                return null;
                              },
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
                                              // color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: TaskCubit.get(context)
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
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Critical',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Checkbox(
                                  value: cubit.isCritical == 0 ? false : true,
                                  onChanged: (bool? value) {
                                    TaskCubit.get(context).setCritical(value);
                                  },
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PublicButton(
                    backgroundColor: Colors.blue,
                    function: () async {
                      if (formKey.currentState!.validate()) {
                        await TaskCubit.get(context).insertDatabase(context);
                      }
                    },
                    text: 'Create Task',
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
