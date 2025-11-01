import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';

import '../../../base/network/dio_provider.dart';
import 'fitness_report_repository.dart';

class FitnessReportRepositoryImpl extends BaseRemoteSource
    implements FitnessReportRepository {
  final String token = UserStore.to.token;

  @override
  Future<void> generateReport(Map<String, dynamic> data,  {void Function(int, int)? onSendProgress,}) {
    final String endpoint = "${DioProvider.baseUrl}/api/fitness_plan/generate/";

    final Map<String, String> headers = {'Authorization': "Bearer $token"};

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      options: Options(headers: headers),
      data: data,
      onSendProgress: onSendProgress,
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => Future.value());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> fetchActivityFocus() {
    // TODO: implement fetchActivityFocus
    throw UnimplementedError();
  }

  @override
  Future<void> fetchActivityGoalsObjective() {
    // TODO: implement fetchActivityGoalsObjective
    throw UnimplementedError();
  }

  @override
  Future<void> fetchActivityObjective() {
    // TODO: implement fetchActivityObjective
    throw UnimplementedError();
  }

  @override
  Future<void> fetchActivityStrategies() {
    // TODO: implement fetchActivityStrategies
    throw UnimplementedError();
  }

  @override
  Future<void> fetchActivityTask() {
    // TODO: implement fetchActivityTask
    throw UnimplementedError();
  }

  @override
  Future<void> fetchFitnessGoals() {
    // TODO: implement fetchFitnessGoals
    throw UnimplementedError();
  }

  @override
  Future<void> fetchFitnessPlan() {
    // TODO: implement fetchFitnessPlan
    throw UnimplementedError();
  }

  @override
  Future<void> fetchNutritionGoals() {
    // TODO: implement fetchNutritionGoals
    throw UnimplementedError();
  }

  @override
  Future<void> fetchNutritionObjectives() {
    // TODO: implement fetchNutritionObjectives
    throw UnimplementedError();
  }

  @override
  Future<void> fetchNutritionStrategies() {
    // TODO: implement fetchNutritionStrategies
    throw UnimplementedError();
  }

  @override
  Future<void> fetchRecoveryGoals() {
    // TODO: implement fetchRecoveryGoals
    throw UnimplementedError();
  }

  @override
  Future<void> fetchRecoveryObjective() {
    // TODO: implement fetchRecoveryObjective
    throw UnimplementedError();
  }

  @override
  Future<void> fetchRecoveryStrategies() {
    // TODO: implement fetchRecoveryStrategies
    throw UnimplementedError();
  }

  @override
  Future<void> fetchSchedulesTasks() {
    // TODO: implement fetchSchedulesTasks
    throw UnimplementedError();
  }
}
