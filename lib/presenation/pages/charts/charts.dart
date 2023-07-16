import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/model/group.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class TasksChart extends StatefulWidget {
  @override
  _TasksChartState createState() => _TasksChartState();
}

class _TasksChartState extends State<TasksChart> {



  @override
  void initState() {
    ChartCubit.get(context).fetchDataFromFirestore(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChartCubit cubit = ChartCubit.get(context);

    return BlocBuilder<ChartCubit,ChartStates>(builder: (context,state)
        {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    ChartCubit.get(context).fetchDataFromFirestore(context);

                  },
                  icon:
                  state is ChartLoadingState ? CircularProgressIndicator() : Icon(Icons.refresh),
                ),
              ],
              title: Text(
                'Tasks Chart',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Center(
              child: SfCartesianChart(
                primaryYAxis: NumericAxis(
                  interval: 1,
                  title: AxisTitle(text: 'Number of Tasks'),
                ),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Groups'),
                ),
                series: <ColumnSeries<GroupTaskData, String>>[
                  ColumnSeries<GroupTaskData, String>(
                    dataSource: cubit.chartData,
                    xValueMapper: (GroupTaskData data, _) => data.groupName,
                    yValueMapper: (GroupTaskData data, _) => data.completedTasks,
                    name: 'Completed Tasks',
                    color: Colors.green,
                  ),
                  ColumnSeries<GroupTaskData, String>(
                    dataSource: cubit.chartData,
                    xValueMapper: (GroupTaskData data, _) => data.groupName,
                    yValueMapper: (GroupTaskData data, _) => data.incompleteTasks,
                    name: 'Incomplete Tasks',
                    color: Colors.red,
                  ),
                ],
                legend: Legend(isVisible: true),
              ),
            ),
          );
        }


    );
  }
}
