import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/modules/register/model/registration_response_model.dart';

import '../../../base/network/dio_provider.dart';
import 'registration_repository.dart';

class RegistrationRepositoryImpl extends BaseRemoteSource
    implements RegistrationRepository {
  @override
  Future<RegistrationResponseModel> onRegister(
    Map<String, dynamic> requestBody,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/accounts/register/";

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

  RegistrationResponseModel _parseLoginResponse(Response<dynamic> response) {
    return RegistrationResponseModel.fromJson(response.data);
  }
}
