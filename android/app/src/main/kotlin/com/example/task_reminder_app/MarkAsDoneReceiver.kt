package com.example.task_reminder_app

import android.annotation.SuppressLint
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MarkAsDoneReceiver : BroadcastReceiver() {
    @SuppressLint("ServiceCast")
    override fun onReceive(context: Context, intent: Intent) {
        val notificationId = intent.getIntExtra("id", -1)
        if (notificationId != -1) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(notificationId) // Cancel the notification
            println("Notification with ID $notificationId marked as done.")
        }
    }
}
