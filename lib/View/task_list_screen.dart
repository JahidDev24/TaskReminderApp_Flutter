// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_reminder_app/View/add_task_screen.dart';
import 'package:task_reminder_app/utils/Extantion.dart';
import '../Controller/Taskbloc/task_bloc.dart';
import '../Controller/ThemeCubit.dart';
import '../widgets/task_card.dart';
import '../widgets/timeline.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: context.read<ThemeCubit>().state == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
              )),
          child: IconButton(
            icon: Icon(
              context.read<ThemeCubit>().state == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              context
                  .read<ThemeCubit>()
                  .toggleTheme(context.read<ThemeCubit>().state);
            },
          ),
        ),
        actions: [
          MaterialButton(
            height: 48,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.blue,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.add, color: Colors.white),
                SizedBox(width: 8),
                Text("Add Task",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
          ),
          10.toSpace
        ],
      ),
      body: Column(
        children: [
          IntrinsicHeight(
              child: ThemingTimeLineCalender(
            onchanged: (c) => context.read<TaskBloc>().add(LoadTasksByDate(c)),
          )),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  final tasks = state.tasks;
                  if (tasks.isEmpty) {
                    return const Center(
                        child: Text('No tasks found. Add a new task.'));
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        clnum: index % 5,
                      );
                    },
                  );
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
