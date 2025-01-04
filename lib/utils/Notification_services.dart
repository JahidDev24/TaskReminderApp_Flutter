import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static const MethodChannel _channel =
      MethodChannel('com.example.task_reminder/notifications');

  static Future<void> createNotification({
    required var id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String recurrence,
  }) async {
    try {
      await _channel.invokeMethod('createNotification', {
        'id': id,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime.toIso8601String(),
        'recurrence': recurrence,
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to create notification: ${e.message}');
      }
    }
  }

  static Future<void> cancelNotification(String id) async {
    try {
      await _channel.invokeMethod('cancelNotification', {'id': id});
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to cancel notification: ${e.message}');
      }
    }
  }
}
