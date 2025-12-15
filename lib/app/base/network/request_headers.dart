import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../data/local/preference/store/user_store.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    getCustomHeaders().then((customHeaders) {
      options.headers.addAll(customHeaders);
      super.onRequest(options, handler);
    });
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
