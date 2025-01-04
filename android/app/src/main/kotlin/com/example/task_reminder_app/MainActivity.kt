package com.example.task_reminder_app


import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.AlarmManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.task_reminder/notifications"

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "createNotification") {
                val args = call.arguments as Map<String, String>
                val title = args["title"]
                val body = args["body"]
                val scheduledTime = args["scheduledTime"]
                val id = args["id"]
                val reccurance = args["recurrence"]
                scheduleNotification(title, body, scheduledTime,id.toString(),reccurance)
                result.success(null)
            }else if(call.method == "cancelNotification"){
                 val args = call.arguments as Map<String, String>
                val id = args["id"]
          
            cancelNotification(id)
            result.success(null)
      
            } else {
                result.notImplemented()
            }
        }
    }

    @SuppressLint("ScheduleExactAlarm")
    @RequiresApi(Build.VERSION_CODES.M)
    private fun scheduleNotification(
        title: String?,
        body: String?,
        scheduledTime: String?,
        id: String?,
        recurrence: String?
    ) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, NotificationReceiver::class.java).apply {
            putExtra("title", title)
            putExtra("body", body)
            putExtra("id", id)
        }

        // Generate a unique request code for the notification
        val requestCode = id?.hashCode() ?: System.currentTimeMillis().toInt()
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Parse the scheduled time
        val date = scheduledTime?.let {
            SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()).parse(it)
        }

        if (date != null) {
            when (recurrence?.lowercase(Locale.getDefault())) {
                "daily" -> {
                    alarmManager.setRepeating(
                        AlarmManager.RTC_WAKEUP,
                        date.time,
                        AlarmManager.INTERVAL_DAY,
                        pendingIntent
                    )
                }
                "weekly" -> {
                    alarmManager.setRepeating(
                        AlarmManager.RTC_WAKEUP,
                        date.time,
                        AlarmManager.INTERVAL_DAY * 7,
                        pendingIntent
                    )
                }
                "monthly" -> {
                    val oneMonthInterval = 30L * 24 * 60 * 60 * 1000 // Approximate month
                    alarmManager.setRepeating(
                        AlarmManager.RTC_WAKEUP,
                        date.time,
                        oneMonthInterval,
                        pendingIntent
                    )
                }
                else -> {
                    // Non-recurring notification with exact timing
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, date.time, pendingIntent)
                }
            }

            // Logging to verify scheduling
            println("Notification scheduled successfully")
            println("Title: $title")
            println("Body: $body")
            println("Scheduled Time: ${date.time}")
            println("Recurrence: $recurrence")
            println("Request Code: $requestCode")
        } else {
            println("Failed to parse scheduled time: $scheduledTime")
        }
    }


    private fun cancelNotification(id: String?) {
    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(this, NotificationReceiver::class.java)
    
    // Generate the unique request code used during scheduling
    val requestCode = (id).hashCode()
    val pendingIntent = PendingIntent.getBroadcast(this, requestCode, intent, PendingIntent.FLAG_IMMUTABLE)

    alarmManager.cancel(pendingIntent)
    println("Notification cancelled for: $id")
}

}
