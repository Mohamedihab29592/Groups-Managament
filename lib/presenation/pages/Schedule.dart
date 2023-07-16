
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/Schedule_Task_Item.dart';

class Event {
  final String title;
  final DateTime date;

  Event(this.title, this.date);
}

class Schedule extends StatefulWidget {
  final int taskId;

  const Schedule({Key? key, required this.taskId}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  String now = DateFormat("EEEE").format(DateTime.now());
  String selectedValue = DateFormat("dd MMM, yyyy'").format(DateTime.now());
  DateTime _firstDay = DateTime.utc(2023, 01, 01);
  DateTime _lastDay = DateTime.utc(2025, 12, 31);
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;


  List<Event> _getEventsForDay(DateTime day) {
    final formattedDay = DateFormat("dd MMM, yyyy").format(day);
    final DateTime parsedDay = DateFormat("dd MMM, yyyy").parse(formattedDay);

    return TaskCubit.get(context).allTasks
        .where((task) {
      final DateTime taskDate = DateFormat("dd MMM, yyyy").parse(task.date);
      return taskDate.isAtSameMomentAs(parsedDay);
    })
        .map((task) => Event(task.title, parsedDay))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = selectedDay;
      selectedValue = DateFormat("dd MMM, yyyy").format(selectedDay);
      now = DateFormat("EEEE").format(selectedDay);
    });
  }



  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () async {
                    await TaskCubit.get(context).getTasksData(context);
                  },
                  icon: state is AppLoadingState
                      ? CircularProgressIndicator()
                      : Icon(Icons.refresh),
                ),
              ),
            ],
            title: Text(
              'Schedule',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Column(
            children: [
              TableCalendar<Event>(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: _getEventsForDay,



                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) {
                  return isSameDay(_focusedDay, day);
                },
              ),

              const Divider(),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Text(
                      now,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      selectedValue,
                    ),
                  ],
                ),
              ),
              if (cubit.allTasks
                  .where((element) => element.date == selectedValue)
                  .toList()
                  .isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ScheduleTaskItem(
                      task: cubit.allTasks
                          .where((element) => element.date == selectedValue)
                          .toList()[index],
                    ),
                    itemCount: cubit.allTasks
                        .where((element) => element.date == selectedValue)
                        .toList()
                        .length,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                    ),
                    Icon(
                      Icons.edit,
                      size: 50,
                      color: Colors.grey,
                    ),
                    Text(
                      'No Tasks on this day  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
