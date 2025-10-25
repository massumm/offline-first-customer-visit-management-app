import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../flavors/build_config.dart';
import 'exceptions/api_exception.dart';
import 'exceptions/app_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/not_found_exception.dart';
import 'exceptions/service_unavailable_exception.dart';
import 'exceptions/timeout_exception.dart';

Exception handleError(String error) {
  final logger = BuildConfig.instance.config.logger;
  logger.e("Generic exception: $error");

  return AppException(message: error);
}

Exception handleDioError(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.connectionTimeout:
      return AppException(message: "Connection timeout with API server");
    case DioExceptionType.sendTimeout:
      return TimeoutException("Send timeout in connection with API server");
    case DioExceptionType.receiveTimeout:
      return TimeoutException("Receive timeout in connection with API server");
    case DioExceptionType.badCertificate:
      return AppException(message: 'Bad certificate');
    case DioExceptionType.badResponse:
      return _parseDioErrorResponse(dioError);
    case DioExceptionType.cancel:
      return AppException(message: "Request to API server was cancelled");
    case DioExceptionType.connectionError:
      //errorToast("Error", "Request Failed");
      return NetworkException(
          "We couldn't connect to the server. Please ensure you have an active internet connection.");
    case DioExceptionType.unknown:
      return NetworkException(
          "We couldn't connect to the server. Please ensure you have an active internet connection.");
  }
}
Exception _parseDioErrorResponse(DioException dioError) {
  final Logger logger = BuildConfig.instance.config.logger;
  final response = dioError.response;
  final responseData = response?.data;
  final int statusCode = response?.statusCode ?? -1;

  String? status;
  String? serverMessage;
  String? serverDescription;

  // Safely parse the response data if it's a map
  if (responseData is Map<String, dynamic>) {
    status = responseData['status'] as String?;
    serverMessage = responseData['message'] as String?;
    // Prefer 'description', but fall back to 'detail' if it's not available.
    serverDescription = responseData['description'] as String? ??
        responseData['detail'] as String?;

    // Special handling for 400 Bad Request (validation errors)
    if (statusCode == HttpStatus.badRequest) {
      final StringBuffer detailedErrors = StringBuffer();
      if (responseData.containsKey("username") &&
          responseData["username"] is List) {
        detailedErrors.writeln(
            "Username: ${List<String>.from(responseData["username"]).join(', ')}");
      }
      if (responseData.containsKey("email") && responseData["email"] is List) {
        detailedErrors.writeln(
            "Email: ${List<String>.from(responseData["email"]).join(', ')}");
      }
      if (responseData.containsKey("password") &&
          responseData["password"] is List) {
        detailedErrors.writeln(
            "Password: ${List<String>.from(responseData["password"]).join(', ')}");
      }

      if (detailedErrors.isNotEmpty) {
        serverDescription = detailedErrors.toString().trim();
      }
    }
  } else if (responseData is String) {
    // Handle cases where the error response is just a plain string
    serverMessage = responseData;
  }

  logger.e(
    "DioError: [$statusCode] ${dioError.requestOptions.path}\n"
        "Response data: $responseData",
  );

  switch (statusCode) {
    case HttpStatus.serviceUnavailable: // 503
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound: // 404
      return NotFoundException(
        serverMessage ?? "Not found",
        status ?? "",
        serverDescription ?? "The requested resource was not found.",
      );
    case HttpStatus.unauthorized: // 401
    // Handles "Authentication credentials were not provided."
      return ApiException(
        httpCode: statusCode,
        status: status ?? "Unauthorized",
        message: serverMessage ?? serverDescription ?? "Authentication failed.",
        description: serverDescription ?? "You are not authorized to perform this action.",
      );
    case HttpStatus.badRequest: // 400
      return ApiException(
        httpCode: statusCode,
        status: status ?? "Bad Request",
        message: serverMessage ?? "Invalid request.",
        description: serverDescription ?? "Please check your input.",
      );
    default:
      return ApiException(
        httpCode: statusCode,
        status: status ?? "Error",
        message: serverMessage ?? "An API error occurred.",
        description: serverDescription ?? "Something went wrong. Please try again later.",
      );
  }
}
