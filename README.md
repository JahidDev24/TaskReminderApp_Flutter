# Task Reminder App

## Overview
The Task Reminder App is a Flutter-based application designed to manage tasks with reminders. It utilizes platform-specific native APIs for iOS and Android to provide a seamless notification experience, including recurrence support, haptic feedback, and action buttons for Android notifications.

---

## Features
- Add tasks with title, description, and reminder time.
- View a list of scheduled tasks.
- Notifications with platform-native implementations:
  - **iOS:** Native notification system with haptic feedback.
  - **Android:** Notifications with action buttons, persistent notifications, and recurrence support.
- Date and time pickers using native platform components.
- Recurrence options for daily, weekly, and monthly reminders.
- Dark mode support, adapting automatically to the system theme.

---

## Setup Instructions

### Prerequisites
1. Install Flutter ([Installation Guide](https://flutter.dev/docs/get-started/install)).
2. Install the latest versions of Xcode and Android Studio for iOS and Android development, respectively.
3. Ensure device emulators or physical devices are configured for testing.
4. Install platform dependencies using CocoaPods for iOS.

---

### Steps to Set Up and Run the Application

1. Clone the Repository:
   ```bash
   git clone <repository_url>
   cd task_reminder_app
   ```

2. Install Dependencies:
   ```bash
   flutter pub get
   ```

3. Set Up iOS Dependencies:
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. Run the Application:
   - For Android:
     ```bash
     flutter run -d android
     ```
   - For iOS:
     ```bash
     flutter run -d ios
     ```

5. Test Notifications:
   - Ensure permissions are granted for notifications on both platforms.
   - Use the UI to schedule a task and verify the notification at the set time.

---

## Platform-Specific Implementations

### Android
- **Notifications:**
  - Utilized `AlarmManager` and `BroadcastReceiver` for scheduling notifications.
  - Notifications include action buttons (e.g., "Mark as Done").
  - Persistent notifications are supported after app restarts.
- **Date and Time Picker:**
  - Used native Material Design pickers for a consistent user experience.
- **Unique Identification:**
  - Notifications are uniquely identified and managed using IDs derived from task data.

### iOS
- **Notifications:**
  - Leveraged `UNUserNotificationCenter` for scheduling local notifications.
  - Implemented haptic feedback using `UIImpactFeedbackGenerator` for user actions like adding or deleting tasks.
- **Date and Time Picker:**
  - Integrated native `UIDatePicker` through Flutter's platform channels.

---

## Challenges Faced
1. **Time Zone Handling:**
   - Ensured notifications respect the device’s local time zone by converting all times appropriately.
   - Resolved inconsistencies with time parsing across platforms.

2. **Cross-Platform Notification API Differences:**
   - Managed separate implementations for scheduling and managing notifications.
   - iOS required additional permissions and user feedback mechanisms compared to Android.

3. **Recurrence Implementation:**
   - Designed custom logic for monthly notifications due to platform limitations.
   - Android’s `AlarmManager` had to be configured for precise intervals to support recurrence.

4. **Notification Cancellation:**
   - Implemented robust methods for canceling notifications uniquely identified by task IDs.

5. **Platform Channel Communication:**
   - Established seamless communication between Dart and native layers using method channels.

---

## Testing
- Tested on Android (API 24+) and iOS 14+.
- Verified functionality on physical devices and emulators.

---

## Future Enhancements
1. Add support for snooze functionality directly from notifications.
2. Enhance recurrence options for custom intervals (e.g., every two weeks).
3. Introduce a cloud sync feature to save tasks across devices.

---

## Contact
For issues or feature requests, please open an issue on GitHub or contact [Jahid khan/support@quantechbit.com].

