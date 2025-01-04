import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_reminder_app/utils/Utility.dart';
import '../Model/task_model.dart';
import '../utils/Notification_services.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;

  TaskRepository._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 2, // Increment version for migrations
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            reminderTime TEXT,
            recurrence INTEGER,
            isRead INTEGER,
            snoozeDuration INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db
              .execute('ALTER TABLE tasks ADD COLUMN snoozeDuration INTEGER');
        }
      },
    );
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    debugPrint(task.toString());
    final db = await database;
    await db
        .insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((v) async {
      // Schedule the notification based on recurrence
      final recurrence = task.recurrence.toString().split('.').last;
      await NotificationService.createNotification(
        id: task.id,
        title: task.title,
        body: task.description,
        scheduledTime: task.reminderTime,
        recurrence: recurrence, // Pass recurrence to notification service
      );
    }).whenComplete(() {
      if (Platform.isIOS) {
        Utility.triggerMediumHapticFeedback();
      }
    });
  }

  /// Fetch tasks by date
  Future<List<Task>> getTasksByDate(DateTime date) async {
    final db = await database;
    final taskMaps = await db.query('tasks');

    return taskMaps
        .map((map) {
          final task = Task.fromMap(map);
          debugPrint("task--> " + task.recurrence.toString());
          // Handle recurrence
          if (task.recurrence == Recurrence.none) {
            // Compare only the date part
            return task.reminderTime.year == date.year &&
                    task.reminderTime.month == date.month &&
                    task.reminderTime.day == date.day
                ? task
                : null;
          } else if (task.recurrence == Recurrence.daily) {
            return task;
          } else if (task.recurrence == Recurrence.weekly) {
            return task.reminderTime.weekday == date.weekday ? task : null;
          } else if (task.recurrence == Recurrence.monthly) {
            return task.reminderTime.day == date.day ? task : null;
          }
          return null;
        })
        .where((task) => task != null)
        .cast<Task>()
        .toList();
  }

  /// Update a task
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Mark task as read
  Future<void> markTaskAsRead(String id) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Cancel the notification for this task
    await NotificationService.cancelNotification(
        id); // Ensure you have a cancel method in NotificationService
  }
}
