import 'package:dio/dio.dart';

import '../../base_remote_source.dart';
import '../../network/dio_provider.dart';
import 'trainee_onboarding_auth_repository.dart';

class TraineeOnboardingAuthRepositoryImpl extends BaseRemoteSource
    implements TraineeOnboardingAuthRepository {
  @override
  Future<Map<String, dynamic>> registerEmail(Map<String, dynamic> payload) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/accounts/register-email/";

    Future<Response<dynamic>> dioCall = dioClient.post(endpoint, data: payload);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getTokenFromEmail(Map<String, dynamic> payload) {
    final String endpoint =
        "${DioProvider.baseUrl}/api/accounts/generate-token-for-email/";

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