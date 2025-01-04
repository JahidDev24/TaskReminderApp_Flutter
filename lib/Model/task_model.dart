enum Recurrence { none, daily, weekly, monthly }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime reminderTime;
  final Recurrence recurrence;
  final bool isRead; // New property to track "Mark as Read"
  final Duration? snoozeDuration; // New property to store snooze duration

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.reminderTime,
    this.recurrence = Recurrence.none,
    this.isRead = false, // Default is unread
    this.snoozeDuration, // Optional snooze duration
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminderTime': reminderTime.toIso8601String(),
      'recurrence': recurrence.index,
      'isRead':
          isRead ? 1 : 0, // Convert boolean to int for database compatibility
      'snoozeDuration':
          snoozeDuration?.inMinutes, // Store snooze duration in minutes
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      reminderTime: DateTime.parse(map['reminderTime']),
      recurrence: Recurrence.values[map['recurrence']],
      isRead: map['isRead'] == 1, // Convert int to boolean
      snoozeDuration: map['snoozeDuration'] != null
          ? Duration(minutes: map['snoozeDuration'])
          : null,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? reminderTime,
    Recurrence? recurrence,
    bool? isRead,
    Duration? snoozeDuration,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderTime: reminderTime ?? this.reminderTime,
      recurrence: recurrence ?? this.recurrence,
      isRead: isRead ?? this.isRead,
      snoozeDuration: snoozeDuration ?? this.snoozeDuration,
    );
  }
}
