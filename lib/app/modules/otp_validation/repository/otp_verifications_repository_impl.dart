import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';
import 'package:icon/app/modules/login/models/login_response_model.dart';

import '../../../base/network/dio_provider.dart';
import 'otp_verifications_repository.dart';

class OtpVerificationsRepositoryImpl extends BaseRemoteSource
    implements OtpVerificationsRepository {
  final String token = UserStore.to.token;

  @override
  Future<LoginResponseModel> varifyOtp(Map<String, dynamic> payload) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/otp/verify/";

    Future<Response<dynamic>> dioCall = dioClient.post(endpoint, data: payload);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseLoginResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  LoginResponseModel _parseLoginResponse(Response<dynamic> response) {
    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<void> otpRequest(Map<String, String> payload) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/otp/request/";

    Future<Response<dynamic>> dioCall = dioClient.post(endpoint, data: payload);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data);
    } catch (e) {
      rethrow;
    }
  }
}
