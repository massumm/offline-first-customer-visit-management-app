import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/values/app_colors.dart';

class CustomToast {
  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    int durationSeconds = 3,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: durationSeconds,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      webBgColor: "#${backgroundColor.value.toRadixString(16).substring(2)}",
      webPosition: gravity == ToastGravity.BOTTOM ? "top" : "bottom",
    );
  }

  // Success toast
  static void showSuccessToast(String message) {
    showToast(
      message: message,
      backgroundColor: AppColors.colorPrimary,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // Error toast
  static void showErrorToast(String message) {
    showToast(
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // Warning toast
  static void showWarningToast(String message) {
    showToast(
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
