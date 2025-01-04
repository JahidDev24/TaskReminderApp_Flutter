package com.example.task_reminder_app
//
//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//
//class Bootreciver : BroadcastReceiver() {
//    override fun onReceive(context: Context, intent: Intent) {
//        if (Intent.ACTION_BOOT_COMPLETED == intent.action) {
//            // Here, you should reschedule all notifications
//            // This requires saving tasks and their scheduled times in persistent storage (e.g., SharedPreferences, SQLite, etc.)
//            val taskRepository = TaskRepository(context) // Custom repository for task storage
//
//            val tasks = taskRepository.getAllScheduledTasks() // Fetch saved tasks
//            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
//
//            for (task in tasks) {
//                val alarmIntent = Intent(context, NotificatioReciver::class.java).apply {
//                    putExtra("title", task.title)
//                    putExtra("body", task.description)
//                }
//                val pendingIntent = android.app.PendingIntent.getBroadcast(
//                    context,
//                    task.id, // Unique ID for each task
//                    alarmIntent,
//                    android.app.PendingIntent.FLAG_UPDATE_CURRENT
//                )
//
//                alarmManager.setExactAndAllowWhileIdle(
//                    android.app.AlarmManager.RTC_WAKEUP,
//                    task.scheduledTimeInMillis,
//                    pendingIntent
//                )
//            }
//        }
//    }
//}
