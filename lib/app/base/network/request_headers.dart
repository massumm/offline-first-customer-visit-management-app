import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../data/local/preference/store/user_store.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final customHeaders = await getCustomHeaders();
    options.headers.addAll(customHeaders);
    handler.next(options);
  }

  // Without this, authenticated API calls will fail.
  Future<Map<String, String>> getCustomHeaders() async {
    final customHeaders = <String, String>{'content-type': 'application/json'};

    // Add authentication token if available
    try {
      final userStore = Get.find<UserStore>();
      final token = userStore.token;
      if (token.isNotEmpty) {
        customHeaders['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // UserStore not initialized yet, skip token
      final Logger logger = Logger();
      logger.e('UserStore not initialized yet');
    }

    return customHeaders;
  }
}
