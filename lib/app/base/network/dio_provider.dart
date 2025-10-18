import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../flavors/build_config.dart';
import '../../flavors/environment.dart';
import 'request_headers.dart';

class DioProvider {
  static String get baseUrl {
    if (BuildConfig.instance.environment == Environment.DEVELOPMENT) {
      return BuildConfig.instance.config.devUrl;
    } else {
      return BuildConfig.instance.config.productionUrl;
    }
  }

  static  String  get wsBaseUrl {
    if (BuildConfig.instance.environment == Environment.DEVELOPMENT) {
      return BuildConfig.instance.config.wsDevUrl;
    } else {
      return BuildConfig.instance.config.wsProductionUrl;
    }
  }

  static  String  get mediaBaseUrl {
    if (BuildConfig.instance.environment == Environment.DEVELOPMENT) {
      return BuildConfig.instance.config.mediaDevUrl;
    } else {
      return BuildConfig.instance.config.mediaProductionUrl;
    }
  }

  static String get socketBaseUrl {
    if (BuildConfig.instance.environment == Environment.DEVELOPMENT) {
      return BuildConfig.instance.config.socketDevUrl;
    } else {
      return BuildConfig.instance.config.socketProductionUrl;
    }
  }

  static Dio? _instance;
  static const int _maxLineWidth = 500;
  static bool _enableLogging = true;
      // BuildConfig.instance.environment == Environment.DEVELOPMENT;

  static final BaseOptions _options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );

  static final PrettyDioLogger _prettyDioLogger = PrettyDioLogger(
    requestHeader: false,
    requestBody: true,
    responseBody: _enableLogging,
    responseHeader: kDebugMode,
    error: true,
    compact: true,
    maxWidth: _maxLineWidth,
    enabled: true,//kDebugMode,
  );

  static Dio get _dio {
    _instance ??= Dio(_options);
    _refreshInterceptors();
    return _instance!;
  }

  static Dio get httpDio => _dio;

  /// Enable or disable logging dynamically
  static void setLoggingEnabled(bool enable) {
    if (_enableLogging != enable) {
      _enableLogging = enable;
      _refreshInterceptors();
    }
  }

  static void _refreshInterceptors() {
    _instance ??= Dio(_options);
    _instance!.interceptors.clear();
    _instance!.interceptors.add(RequestHeaderInterceptor());
    if (_enableLogging) {
      _instance!.interceptors.add(_prettyDioLogger);
    }
  }

  /// Dio client with Access token in header
  static Dio get tokenClient => _dio;

  /// Dio client with Access token in header and token refresh
  static Dio get dioWithHeaderToken => _dio;
}
