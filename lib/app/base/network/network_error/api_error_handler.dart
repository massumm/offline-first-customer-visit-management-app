import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../exceptions/api_exception.dart';
import '../exceptions/app_exception.dart';
import '../exceptions/base_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/not_found_exception.dart';
import '../exceptions/service_unavailable_exception.dart';
import '../exceptions/timeout_exception.dart';
import 'error_handler_widget.dart';

// Toast Message Prefixes
const String _kNetworkErrorPrefix = "Network Error: ";
const String _kDefaultErrorPrefix = "Error: ";

// Toast Configuration
const Toast _kDefaultToastLength = Toast.LENGTH_SHORT;
const Toast _kNetworkErrorToastLength =
    Toast.LENGTH_LONG; // Network errors might need more attention
const ToastGravity _kToastGravity = ToastGravity.BOTTOM;
const double _kToastFontSize = 16.0;

// Toast Colors
final Color _kErrorToastBackgroundColor = Colors.red.shade600;
const Color _kErrorToastTextColor = Colors.white;

// Optional: Specific color for network error toasts, or use the default error color
final Color _kNetworkErrorToastBackgroundColor =
    Colors.blueGrey.shade700; // Example: distinct color
const Color _kNetworkErrorToastTextColor = Colors.white;

void apiErrorHandler({
  required String fallbackMessage,
  Exception? exception,
  VoidCallback? onRetry,
}) {
  String toastMsg;
  // ignore: unused_local_variable
  String dialogTitle = "Error";
  String dialogContent;
  bool allowRetry = false; // Flag to determine if retry UI should be offered

  Toast toastLength = _kDefaultToastLength;
  Color toastBgColor = _kErrorToastBackgroundColor;
  Color toastTextColor = _kErrorToastTextColor;

  // Determine message, title, and retry capability based on exception type
  if (exception is BaseException) {
    String exceptionDisplayMessage = (exception.description.isNotEmpty
            ? exception.description
            : exception.message)
        .trim();
    dialogContent = exceptionDisplayMessage.isNotEmpty
        ? exceptionDisplayMessage
        : fallbackMessage;

    if (exception is NetworkException) {
      dialogTitle = "Network Error";
      toastMsg = _kNetworkErrorPrefix + dialogContent;
      toastBgColor = _kNetworkErrorToastBackgroundColor;
      toastTextColor = _kNetworkErrorToastTextColor;
      toastLength = _kNetworkErrorToastLength;
      if (onRetry != null) allowRetry = true;
    } else if (exception is TimeoutException) {
      dialogTitle = "Request Timeout";
      toastMsg = "Timeout: $dialogContent";
      // Use default error toast colors or define specific ones for timeout
      if (onRetry != null) allowRetry = true;
    } else if (exception is ServiceUnavailableException) {
      dialogTitle = "Service Unavailable";
      toastMsg = "Service Unavailable (${exception.httpCode}): $dialogContent";
      if (onRetry != null) allowRetry = true;
    } else if (exception is NotFoundException) {
      dialogTitle = "Not Found";
      toastMsg = "Not Found (${exception.httpCode}): $dialogContent";
      // allowRetry = false; // Default, typically no retry for 404
    } else if (exception is ApiException) {
      if (exception.httpCode == HttpStatus.found) {
        // 302
        // Handle redirection, typically to login for session expiry
        dialogTitle = "Session Expired";
        final String sessionExpiredMessage =
            "Your session has expired. Please log in again.";
        dialogContent = sessionExpiredMessage;
        toastMsg = sessionExpiredMessage;

        Fluttertoast.showToast(
          msg: toastMsg,
          toastLength: Toast.LENGTH_LONG,
          gravity: _kToastGravity,
          backgroundColor: _kErrorToastBackgroundColor,
          textColor: _kErrorToastTextColor,
          fontSize: _kToastFontSize,
        );

        _logout();
        return; // Exit early, no dialog needed as we are navigating
      }
      // Handles other API errors like 400, 401, 403, 500
      dialogTitle = "API Error (${exception.httpCode})";
      toastMsg = "API Error (${exception.httpCode}): $dialogContent";
      // Retry for server errors (5xx) or if httpCode indicates a transient issue or is unknown (-1, 0)
      if (onRetry != null &&
          (exception.httpCode >= 500 || exception.httpCode <= 0)) {
        allowRetry = true;
      }
    } else if (exception is AppException) {
      // Generic application error
      dialogTitle = "Application Error";
      toastMsg = "Error: $dialogContent";
      // allowRetry = false; // Default
    } else {
      // This case handles any other BaseException subtype not explicitly listed above.
      dialogTitle = "Application Error";
      toastMsg = _kDefaultErrorPrefix + dialogContent;
    }
  } else {
    // Exception is not a BaseException or is null
    dialogContent = fallbackMessage;
    toastMsg = _kDefaultErrorPrefix + fallbackMessage;
    // allowRetry = false; // Default
  }

  // Ensure toast message is not empty
  final finalToastMsg =
      toastMsg.trim().isNotEmpty ? toastMsg.trim() : fallbackMessage;

  Fluttertoast.showToast(
    msg: finalToastMsg,
    toastLength: toastLength,
    gravity: _kToastGravity,
    backgroundColor: toastBgColor,
    textColor: toastTextColor,
    fontSize: _kToastFontSize,
  );

  // Display the ErrorHandlerWidget in a dialog
  Get.dialog(
    ErrorHandlerWidget(
      errorMessage: dialogContent,
      onRetry: allowRetry
          ? () {
              onRetry!();
              Get.back();
            }
          : null,
    ),
    barrierDismissible: !allowRetry,
  );
}

void _logout() {

}
