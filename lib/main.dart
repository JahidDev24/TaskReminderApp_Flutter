import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_reminder_app/View/task_list_screen.dart';
import 'Controller/Taskbloc/task_bloc.dart';
import 'Controller/ThemeCubit.dart';
import 'repositories/task_repository.dart';

void main() {
  runApp(const TaskReminderApp());
}

class TaskReminderApp extends StatelessWidget {
  const TaskReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TaskBloc(TaskRepository())..add(LoadTasksByDate(DateTime.now())),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(), // Add ThemeCubit
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Task Reminder App',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode, // Use theme from ThemeCubit
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const TaskListScreen(),
          );
        },
      ),
    );
  }
}
