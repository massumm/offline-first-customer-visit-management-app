import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/modules/trainee_onboarding/models/trainee_onboarding_questions_model.dart';
import '../../../base/network/dio_provider.dart';
import '../../../data/local/preference/store/user_store.dart';
import 'traineer_onboarding_qa_repository.dart';

class TraineeOnboardingQARepositoryImpl extends BaseRemoteSource
    implements TraineeOnboardingQARepository {
  final String? token = UserStore.to.token;

  @override
  Future<TraineeOnboardingQuestionsModel> fetchQuestionsData(int trainerId) {
    final String endpoint =
        "${DioProvider.baseUrl}/api/trainees/onboardings/$trainerId/questions/";

    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };

    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseQuestionsResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  TraineeOnboardingQuestionsModel _parseQuestionsResponse(
    Response<dynamic> response,
  ) => TraineeOnboardingQuestionsModel.fromJson(response.data);
}
