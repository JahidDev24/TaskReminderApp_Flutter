import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller = window?.rootViewController as! FlutterViewController
    let notificationChannel = FlutterMethodChannel(name: "com.example.task_reminder/notifications", binaryMessenger: controller.binaryMessenger)

    notificationChannel.setMethodCallHandler { (call, result) in
      if call.method == "createNotification" {
        // Ensure the arguments are correctly passed
        if let args = call.arguments as? [String: Any],
           let title = args["title"] as? String,
           let body = args["body"] as? String,
           let scheduledTimeStr = args["scheduledTime"] as? String {
          
          // Debugging: Print arguments and scheduledTimeStr
          print("Received arguments: \(args)")
          print("Scheduled Time String: \(scheduledTimeStr)")

          // Convert scheduledTime to Date
          if let scheduledTime = self.dateFromISOString(scheduledTimeStr) {
            self.scheduleLocalNotification(title: title, body: body, scheduledTime: scheduledTime)
            result(nil)
          } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid date format", details: nil))
          }
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for createNotification", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // Request notification permissions
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("Notification permission error: \(error)")
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Helper function to schedule a local notification
  private func scheduleLocalNotification(title: String, body: String, scheduledTime: Date) {
    let localScheduledTime = scheduledTime.toLocalTime()  // Convert to local time

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default

    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: localScheduledTime)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification: \(error)")
        } else {
            print("Notification scheduled successfully for \(localScheduledTime)")
        }
    }
  }

  /// Helper function to parse ISO8601 date string
  private func dateFromISOString(_ isoString: String) -> Date? {
    // Log received date string
    print("Attempting to parse ISO8601 date string: \(isoString)")

    // Try using the ISO8601DateFormatter
    let formatter = ISO8601DateFormatter()
    // Ensure it's configured to handle milliseconds properly
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = formatter.date(from: isoString) {
      print("Parsed with ISO8601DateFormatter: \(date)")
      return date
    } else {
      // Fallback: Use DateFormatter if ISO8601 fails
      let fallbackFormatter = DateFormatter()
      fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // Explicitly handle milliseconds
      if let date = fallbackFormatter.date(from: isoString) {
        print("Parsed with fallback DateFormatter: \(date)")
        return date
      } else {
        print("Failed to parse date with both formats.")
        return nil
      }
    }
  }
}

/// Helper extension to convert Date to local time
extension Date {
    func toLocalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = timeZone.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(seconds))
    }
}
