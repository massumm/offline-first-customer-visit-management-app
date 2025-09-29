import 'package:dio/dio.dart';

import '../flavors/build_config.dart';
import 'network/dio_provider.dart';
import 'network/error_handler.dart';
import 'network/exceptions/base_exception.dart';

abstract class BaseRemoteSource {
  Dio get dioClient => DioProvider.dioWithHeaderToken;

  final logger = BuildConfig.instance.config.logger;

  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {
    try {
      Response<T> response = await api;
      return response;
    } on DioException catch (dioError) {
      Exception exception = handleDioError(dioError);
      // Log the transformed DioException before throwing
      logger.e("DioException caught and transformed to BaseException: >>>>>>> "
          "$exception : ${(exception as BaseException).description}");
      throw exception;
    } catch (error) {
      // This block will catch 'exception' thrown above if it's a BaseException,
      // or any other non-DioException from the 'await api' call.
      logger.e(
          "Error caught in callApiWithErrorParser's generic catch: >>>>>>> $error");
      if (error is BaseException) {
        rethrow; // Rethrow if it's already a BaseException (e.g., from the DioException block or other source)
      }
      // Otherwise, wrap it in a standard error type if not already a BaseException
      throw handleError(
          "$error"); // handleError should ideally return a BaseException
    }
  }
}
