import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';
import 'package:icon/app/modules/fitness_report/models/server_task_log_response_model.dart';

import '../../../base/network/dio_provider.dart';
import 'fitness_report_repository.dart';

class FitnessReportRepositoryImpl extends BaseRemoteSource
    implements FitnessReportRepository {
  final String token = UserStore.to.token;

  @override
  Future<Response> generateReport(
    Map<String, dynamic> data, {
    void Function(int, int)? onReceiveProgress,
  }) {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/generate/by-trainer/${data['trainer_id']}/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
      ),
      data: data,
      onReceiveProgress: onReceiveProgress,
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchActivityFocus() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/activity-focus-areas/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchActivityGoalsObjective() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/activity-goals/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchActivityObjective() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/activity-objectives/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchActivityStrategies() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/activity-strategies/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchActivityTask() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/activity-tasks/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchFitnessGoals() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/fitnessplan-goal-links/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchFitnessPlan() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/fitness-plans/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchNutritionGoals() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/nutrition-goals/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchNutritionObjectives() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/nutrition-objectives/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchNutritionStrategies() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/nutrition-strategies/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchRecoveryGoals() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/recovery-goals/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchRecoveryObjective() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/recovery-objectives/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchRecoveryStrategies() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/recovery-strategies/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> fetchSchedulesTasks() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/fitness_plan/task-schedules/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );
    try {
      return callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ServerTaskLagResponseModel> checkServerBackgroundTask(
    String celeryTaskId,
      void Function(int, int)? onReceiveProgress,
  ) {
    final String endpoint =
        "${DioProvider.baseUrl}/api/background_tasks/check-run-log/$celeryTaskId/";
    final Map<String, String> headers = {'Authorization': "Bearer $token"};
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
      onReceiveProgress: onReceiveProgress,
    );
    try {
      return callApiWithErrorParser(dioCall).then(
        (Response response) =>
            ServerTaskLagResponseModel.fromJson(response.data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
