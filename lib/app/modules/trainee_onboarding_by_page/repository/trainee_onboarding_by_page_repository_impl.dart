import 'package:dio/dio.dart';

import 'package:icon/app/base/base_remote_source.dart';
import '../models/trainee_onboarding.dart';
import '../../../base/network/dio_provider.dart';
import '../../../data/local/preference/store/user_store.dart';

import 'trainee_onboarding_by_page_repository.dart';

class TraineeOnboardingByPageRepositoryImpl extends BaseRemoteSource
    implements TraineeOnboardingByPageRepository {
  final String? token = UserStore.to.token;

  @override
  Future<void> submitTraineeOnboardingData(
    TraineeOnboardingDataModel data,
  ) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/by_trainer/1/onboarding/submit/";
    final Map<String, String> headers = {
      'Authorization': "Bearer ${UserStore.to.token}",
    };
    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: data.toJson(),
      options: Options(headers: headers),
      onSendProgress: (int sent, int total) {},
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data);
    } catch (e) {
      rethrow;
    }
  }
}
