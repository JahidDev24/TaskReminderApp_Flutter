part of 'task_bloc.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);
}

class DeleteTask extends TaskEvent {
  final String taskId;

  DeleteTask(this.taskId);
}

class MarkTaskAsRead extends TaskEvent {
  final String taskId;

  MarkTaskAsRead(this.taskId);
}

class SnoozeTask extends TaskEvent {
  final String taskId;
  final Duration snoozeDuration;

  SnoozeTask(this.taskId, this.snoozeDuration);
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);
}

class SetRecurrence extends TaskEvent {
  final String taskId;
  final Recurrence recurrence;

  SetRecurrence(this.taskId, this.recurrence);
}

class LoadTasksByDate extends TaskEvent {
  final DateTime date;

  LoadTasksByDate(this.date);
}
