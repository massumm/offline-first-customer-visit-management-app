import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/modules/trainer_onboarding/repository/tainer_onboarding_repository.dart';

import '../../../base/network/dio_provider.dart';
import '../../../data/local/preference/store/user_store.dart';

class TrainerOnboardingRepositoryImpl extends BaseRemoteSource
    implements TrainerOnboardingRepository {
  final String? token = UserStore.to.token;

  @override
  Future<String> createTrainerProfile(Map<String, dynamic> data) {
    DioProvider.setLoggingEnabled(true);
    final String endpoint = "${DioProvider.baseUrl}/api/trainees/profile/";
    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };
    Future<Response<dynamic>> dioCall = dioClient.put(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data.toString());
    } catch (e) {
      rethrow;
    }
  }
}
