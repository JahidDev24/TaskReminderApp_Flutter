import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_reminder_app/utils/Colors.dart';
import 'package:task_reminder_app/utils/Extantion.dart';
import 'package:task_reminder_app/utils/Utility.dart';
import '../Controller/Taskbloc/task_bloc.dart';
import '../Model/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  final int clnum;

  const TaskCard({
    Key? key,
    required this.task,
    required this.clnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Icon(
                    Icons.circle,
                    color: MyColors().randomcolors[clnum].bgcolor,
                  ),
                  Expanded(
                    child: Container(
                      width: 3,
                      color: MyColors().randomcolors[clnum].bgcolor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                color: MyColors().randomcolors[clnum].bgcolor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust radius as needed
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              color: MyColors().randomcolors[clnum].opColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            Utility()
                                .formattedTime
                                .format(task.reminderTime.toLocal())
                                .toString(),
                            style: TextStyle(
                              color: MyColors()
                                  .randomcolors[clnum]
                                  .opColor
                                  .withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      2.toSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            task.description,
                            style: TextStyle(
                              color: MyColors()
                                  .randomcolors[clnum]
                                  .opColor
                                  .withOpacity(0.7),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          )),
                          // IconButton(
                          //   padding: const EdgeInsets.all(0),
                          //   icon: Icon(
                          //     task.isRead
                          //         ? Icons.check_circle_outline
                          //         : Icons.circle_outlined,
                          //     color: MyColors()
                          //         .randomcolors[clnum]
                          //         .opColor
                          //         .withOpacity(0.9),
                          //   ),
                          //   onPressed: () {
                          //     // Delete task
                          //     final taskBloc = context.read<TaskBloc>();
                          //     taskBloc.add(MarkTaskAsRead(task.id));
                          //   },
                          // ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: MyColors()
                                  .randomcolors[clnum]
                                  .opColor
                                  .withOpacity(0.9),
                            ),
                            onPressed: () {
                              // Delete task
                              final taskBloc = context.read<TaskBloc>();
                              taskBloc.add(DeleteTask(task.id));
                            },
                          ),
                        ],
                      ),
                      if (task.recurrence.name != "none")
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 7),
                          decoration: BoxDecoration(
                              color: MyColors.PurpleColor,
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            task.recurrence.name,
                            style: TextStyle(
                              letterSpacing: 1.4,
                              color: MyColors().randomcolors[clnum].opColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
