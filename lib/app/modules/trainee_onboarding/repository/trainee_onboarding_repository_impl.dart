import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';
import '../../../data/local/preference/store/user_store.dart';
import '../models/trainee_preference_create_response_model.dart';
import '../models/trainee_profile_create_response_model.dart';
import 'trainee_onboarding_repository.dart';

class TraineeOnboardingRepositoryImpl extends BaseRemoteSource
    implements TraineeOnboardingRepository {
  final String? token = UserStore.to.token;

  @override
  Future<TraineeProfileCreateResponseModel> createTraineeProfile(
    Map<String, dynamic> model,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/trainees/profile/";
    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };
    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: model,
      options: Options(headers: headers),
      onSendProgress: (int sent, int total) {},
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseLoginResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  TraineeProfileCreateResponseModel _parseLoginResponse(
    Response<dynamic> response,
  ) {
    return TraineeProfileCreateResponseModel.fromJson(response.data);
  }

  @override
  Future<TraineePreferenceCreateResponseModel> createTraineePreferences(
    Map<String, dynamic> model,
  ) {
    final String endpoint = "${DioProvider.baseUrl}/api/trainees/preferences/";
    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };
    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: model,
      options: Options(headers: headers),
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parsePreferenceResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  TraineePreferenceCreateResponseModel _parsePreferenceResponse(
    Response<dynamic> response,
  ) {
    return TraineePreferenceCreateResponseModel.fromJson(response.data);
  }

  @override
  Future<Map<String, dynamic>> createTraineePreferenceActivity(Map<String, dynamic> data) {
    // TODO: implement createTraineePreferenceActivity
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createTraineePreferenceGoals(Map<String, dynamic> data) {
    final String endpoint = "${DioProvider.baseUrl}/api/trainees/preferences/goals/events/";

    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createTraineePreferenceNutrition(Map<String, dynamic> data) {
    final String endpoint = "${DioProvider.baseUrl}/api/trainees/preferences/nutrition/foods/";

    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createTraineePreferenceRecovery(Map<String, dynamic> data) {
    final String endpoint = "${DioProvider.baseUrl}/api/trainees/preferences/recovery_preferences/";

    final Map<String, String> headers = {
      'Authorization': "Bearer ${token ?? ''}",
    };

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
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
