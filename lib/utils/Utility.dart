import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder_app/utils/Colors.dart';

class Utility {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_SHORT,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1, // Duration for iOS/Web
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  // Function to trigger light impact feedback
  static void triggerLightHapticFeedback() {
    HapticFeedback.lightImpact(); // Triggers a light haptic feedback
  }

  // Function to trigger medium impact feedback
  static void triggerMediumHapticFeedback() {
    HapticFeedback.mediumImpact(); // Triggers a medium haptic feedback
  }

  // Function to trigger heavy impact feedback
  static void triggerHeavyHapticFeedback() {
    HapticFeedback.heavyImpact(); // Triggers a heavy haptic feedback
  }

  // Function to trigger selection click feedback
  static void triggerSelectionClickFeedback() {
    HapticFeedback
        .selectionClick(); // Triggers a simple selection click feedback
  }

  DateFormat formattedTime = DateFormat('hh:mm a');
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No Date Selected';
    return DateFormat('MM/dd/yyyy hh:mm a').format(dateTime);
  }

  static InputDecoration mytextfielddecoration(hinttext, extra) =>
      InputDecoration(
        errorStyle: const TextStyle(fontSize: 12),
        hintText: hinttext,
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: MyColors.textFieldBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: MyColors.textFieldBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: MyColors.textFieldBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ).copyWith(suffix: extra);
}
