import 'package:flutter/material.dart';

import '../../core/utils/components/constats.dart';
import '../../data/model/task_model.dart';
import '../cubit/cubit.dart';
import '../pages/task_details.dart';


class PrimaryTaskItem extends StatefulWidget {
  final TaskModel task;

  const PrimaryTaskItem({
    Key? key,
   required this.task,
  }) : super(key: key);

  @override
  State<PrimaryTaskItem> createState() => _PrimaryTaskItemState();
}

class _PrimaryTaskItemState extends State<PrimaryTaskItem> {





  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
       navigateTo(context, TaskDetails(task: widget.task,));
       TaskCubit.get(context).selectTaskToUpdate(task: widget.task);
      },

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            InkWell(
              onTap: () async{
                await TaskCubit.get(context).updateCompleteTask(widget.task.id,context);

              },
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color:
                  widget.task.completed == 1
                      ? TaskCubit.get(context).taskColors[widget.task.colorPriority]
                      : null,
                  border: Border.all(
                    color:
                       TaskCubit.get(context).taskColors[widget.task.colorPriority],
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: widget.task.completed == 1
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18.0,
                      )
                    :
                Container(),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Text(
                widget.task.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child:IconButton(
                      icon: Icon(
                        widget.task.critical == 1
                            ? Icons.notification_important_rounded
                            :  Icons.notification_important_outlined,
                        color: Colors.red,
                      ),
                      onPressed: ()async{
                       await TaskCubit.get(context).updateCriticalTask(widget.task.id,context);
                        Navigator.pop(context);

                      },
                    ),


                  ),
                  PopupMenuItem(
                    value: 2,
                    child:IconButton( icon: Icon(Icons.delete),onPressed: (){

                      GlobalMethods.warningDialog(
                          title: 'Delete your task?',
                          subTitle: 'Are you sure?',
                          fct: () async{
                            await  TaskCubit.get(context).deleteData(id:widget.task.id,co:context);
                            Navigator.pop(context);
                          },
                          context: context);
                    },),

                  ),

                ]),
          ],
        ),
      ),
        );



  }
}






