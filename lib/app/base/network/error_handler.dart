import 'dart:io';

import 'package:dio/dio.dart';

import '../../flavors/build_config.dart';
import 'exceptions/api_exception.dart';
import 'exceptions/app_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/not_found_exception.dart';
import 'exceptions/service_unavailable_exception.dart';
import 'exceptions/timeout_exception.dart';

class ApiErrorResponse {
  final String? status;
  final String? message;
  final String? error;
  final String? description;
  final Map<String, dynamic>? errors;

  ApiErrorResponse({
    this.status,
    this.message,
    this.error,
    this.description,
    this.errors,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      description: json['description'] as String? ?? json['detail'] as String?,
      errors: json,
    );
  }
}

Exception handleError(String error) {
  final logger = BuildConfig.instance.config.logger;
  logger.e("Generic exception: $error");

  return AppException(message: error);
}

Exception handleDioError(DioException dioError) {
  final logger = BuildConfig.instance.config.logger;

  switch (dioError.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      logger.w("Timeout occurred: ${dioError.message}");
      return TimeoutException("Connection timeout with the server.");
    case DioExceptionType.badResponse:
      // This is the most common case, for 4xx and 5xx errors.
      return _parseDioErrorResponse(dioError);
    case DioExceptionType.cancel:
      logger.i("Request to API server was cancelled.");
      return AppException(message: "Request was cancelled.");
    case DioExceptionType.connectionError:
      logger.e("Connection Error: ${dioError.message}");
      return NetworkException(
        "Connection error. Please check your internet connection.",
      );
    case DioExceptionType.badCertificate:
      logger.w("Bad certificate: ${dioError.message}");
      return AppException(message: 'Invalid SSL certificate.');
    case DioExceptionType.unknown:
      // The 'unknown' error can be a variety of things.
      // A common cause is a SocketException when there's no internet connection.
      if (dioError.error is SocketException) {
        logger.e(
          "SocketException: No Internet connection. ${dioError.message}",
        );
        return NetworkException(
          "No internet. Please check your connection and try again.",
        );
      }
      logger.e("Unknown Dio Error: ${dioError.message}");
      return AppException(message: "An unexpected error occurred.");
  }
}

Exception _parseDioErrorResponse(DioException dioError) {
  final logger = BuildConfig.instance.config.logger;
  final response = dioError.response;
  final statusCode = response?.statusCode ?? -1;
  final requestPath = dioError.requestOptions.path;

  logger.e(
    "API Error: [$statusCode] $requestPath\n"
    "Response data: ${response?.data}",
  );

  ApiErrorResponse? apiError;
  if (response?.data is Map<String, dynamic>) {
    apiError = ApiErrorResponse.fromJson(response!.data);
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable: // 503
      return ServiceUnavailableException("Service is temporarily unavailable.");
    case HttpStatus.notFound: // 404
      return NotFoundException(
        apiError?.message ?? "Not found",
        apiError?.status ?? "",
        apiError?.description ?? "The requested resource was not found.",
      );
    case HttpStatus.unauthorized: // 401
      return ApiException(
        httpCode: statusCode,
        status: apiError?.status ?? "Unauthorized",
        message: apiError?.message ?? "Authentication failed.",
        description: apiError?.description ?? "You are not authorized.",
      );
    case HttpStatus.badRequest: // 400
      final detailedErrors = _parseValidationErrors(apiError?.errors);

      String errorMessage = [
        apiError?.error,
        apiError?.message,
      ].where((s) => s?.isNotEmpty ?? false).join('\n');

      return ApiException(
        httpCode: statusCode,
        status: apiError?.status ?? "Bad Request",
        message: errorMessage.isNotEmpty ? errorMessage : "Invalid request.",
        description:
            detailedErrors ??
            apiError?.description ??
            "Please check your input.",
      );
    default:
      return ApiException(
        httpCode: statusCode,
        status: apiError?.status ?? "Error",
        message: apiError?.message ?? "An API error occurred.",
        description:
            apiError?.description ?? "Something went wrong. Please try again.",
      );
  }
}

String? _parseValidationErrors(Map<String, dynamic>? errors) {
  if (errors == null) return null;

  final StringBuffer detailedErrors = StringBuffer();

  errors.forEach((key, value) {
    if (value is List) {
      // join the error messages.
      detailedErrors.writeln(value.join(', '));
    }
  });

  if (detailedErrors.isNotEmpty) {
    return detailedErrors.toString().trim();
  }

  return null;
}
