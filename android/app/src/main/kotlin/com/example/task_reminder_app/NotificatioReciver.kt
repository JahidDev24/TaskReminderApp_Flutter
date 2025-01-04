package com.example.task_reminder_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("title")
        val body = intent.getStringExtra("body")
        val notificationId = intent.getStringExtra("id")?.hashCode() ?: System.currentTimeMillis().toInt()

        // Mark as Done Action
        val markAsDoneIntent = Intent(context, MarkAsDoneReceiver::class.java).apply {
            putExtra("id", notificationId) // Pass the task ID for further action
        }
        val markAsDonePendingIntent = PendingIntent.getBroadcast(
            context,
            notificationId,
            markAsDoneIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Create Notification
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "task_reminder_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Task Reminder Notifications",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Channel for Task Reminders"
            }
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(context, channelId)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(R.mipmap.ic_launcher) // Replace with your icon
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true) // Dismiss the notification when tapped
            .addAction(R.mipmap.ic_launcher, "Mark as Done", markAsDonePendingIntent) // Add action button
            .build()

        // Show Notification
        notificationManager.notify(notificationId, notification)
    }
}


