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

  // SnackBar with undo functionality
  static void show(
    BuildContext context, {
    required String message,
    VoidCallback? onUndo,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onUndo != null)
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onUndo();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Undo',
                  style: TextStyle(
                    color: Color(0xFFFF5722),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
