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
  String? code;
  String? serverMessage;
  String? serverDescription;

  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode = dioError.response?.data["statusCode"];
    }
    status = dioError.response?.data["status"];
    code = dioError.response?.data["code"];
    serverMessage = dioError.response?.data["message"];
    serverDescription = dioError.response?.data["description"];
  } catch (e, s) {
    logger.i("$e");
    logger.i(s.toString());
    logger.i(code.toString());

    serverMessage = "Something went wrong. Please try again later.";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound:
      return NotFoundException(
        serverMessage ?? "",
        status ?? "",
        serverDescription ?? "",
      );
    default:
      return ApiException(
        httpCode: statusCode,
        status: status ?? "",
        message: serverMessage ?? "",
        description: serverDescription ?? "",
      );
  }
}
