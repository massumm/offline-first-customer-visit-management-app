import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/base/network/dio_provider.dart';
import 'forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl extends BaseRemoteSource
    implements ForgotPasswordRepository {
  @override
  Future<Map<String, dynamic>> requestPasswordReset(
    Map<String, dynamic> requestBody,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/password-reset/request/";

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: requestBody,
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> requestOtp(
    Map<String, dynamic> requestBody,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/otp/request/";

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: requestBody,
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(
    Map<String, dynamic> requestBody,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/otp/verify/";

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: requestBody,
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resetPasswordConfirm(
    Map<String, dynamic> requestBody,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/password-reset/confirm/";

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: requestBody,
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
