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

  int statusCode = dioError.response?.statusCode ?? -1;
  String? status;
  String? serverMessage;
  String? serverDescription; // General description

  // Specific fields for 400 error
  List<String>? usernameErrors;
  List<String>? emailErrors;
  List<String>? passwordErrors;


  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode = dioError.response?.data["statusCode"];
    }
    status = dioError.response?.data["status"];
    serverMessage = dioError.response?.data["message"];


    // Check if the error is a 400 and try to parse specific fields
    if (statusCode == HttpStatus.badRequest && dioError.response?.data is Map) {
      final responseData = dioError.response?.data as Map<String, dynamic>;
      if (responseData.containsKey("username") && responseData["username"] is List) {
        usernameErrors = List<String>.from(responseData["username"]);
      }
      if (responseData.containsKey("email") && responseData["email"] is List) {
        emailErrors = List<String>.from(responseData["email"]);
      }
      if (responseData.containsKey("password") && responseData["password"] is List) {
        passwordErrors = List<String>.from(responseData["password"]);
      }
      // You can construct a more specific error message here if needed
      // For example, concatenate all error messages.
      StringBuffer detailedErrors = StringBuffer();
      if (usernameErrors?.isNotEmpty ?? false) {
        detailedErrors.writeln("Username errors: ${usernameErrors!.join(', ')}");
      }
      if (emailErrors?.isNotEmpty ?? false) {
        detailedErrors.writeln("Email errors: ${emailErrors!.join(', ')}");
      }
      if (passwordErrors?.isNotEmpty ?? false) {
        detailedErrors.writeln("Password errors: ${passwordErrors!.join(', ')}");
      }
      if(detailedErrors.isNotEmpty) {
        serverDescription = detailedErrors.toString().trim();
      } else {
        serverDescription = dioError.response?.data["description"];
      }

    } else {
      serverDescription = dioError.response?.data["description"];
    }

  } catch (e, s) {
    logger.i("$e");
    logger.i(s.toString());


    // It seems 'code' is not always present, so logging it directly might cause an error
    // if it's null. Only log it if you are sure it should be there or add a null check.
    // logger.i(code.toString());


    serverMessage = "Something went wrong. Please try again later.";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound:
      return NotFoundException(
        serverMessage ?? "Not found.", // Provide a default message
        status ?? "",
        serverDescription ?? "",
      );
    case HttpStatus.badRequest: // Handle 400 specifically
    // You might want a specific Exception type for validation errors
      return ApiException(
        httpCode: statusCode,
        status: status ?? "Bad Request",
        message: serverMessage ?? "Invalid request.",
        description: serverDescription ?? "Please check your input.",
        // You could add the specific error fields to your ApiException if it's designed to hold them
        // errors: { "username": usernameErrors, "email": emailErrors, "password": passwordErrors }
      );
    default:
      return ApiException(
        httpCode: statusCode,
        status: status ?? "",
        message: serverMessage ?? "An API error occurred.",
        description: serverDescription ?? "",
      );
  }
}
