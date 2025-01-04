import 'package:bloc/bloc.dart';


import '../../Model/task_model.dart';
import '../../repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasksByDate>((event, emit) async {
      try {
        final tasks = await repository.getTasksByDate(event.date);
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError("Failed to load tasks"));
      }
    });

    on<MarkTaskAsRead>((event, emit) async {
      await repository.markTaskAsRead(event.taskId);
      add(LoadTasksByDate(DateTime.now())); // Reload tasks
    });

    on<AddTask>((event, emit) async {
      await repository.addTask(event.task);
      add(LoadTasksByDate(DateTime.now())); // Reload tasks
    });

    on<DeleteTask>((event, emit) async {
      await repository.deleteTask(event.taskId);
      add(LoadTasksByDate(DateTime.now())); // Reload tasks
    });
  }
}
