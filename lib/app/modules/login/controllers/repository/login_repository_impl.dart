import 'package:dio/dio.dart';
import 'package:icon/app/base/models/login_response_model.dart';

import '../../../../base/base_remote_source.dart';
import '../../../../base/network/dio_provider.dart';
import 'login_repository.dart';

class LoginRepositoryImpl extends BaseRemoteSource implements LoginRepository {
  @override
  Future<LoginResponseModel> login(Map<String, dynamic> requestBody) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/login/";

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: requestBody,
    );

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
}
