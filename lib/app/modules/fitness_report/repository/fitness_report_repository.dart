import 'package:dio/dio.dart';
import 'package:icon/app/modules/fitness_report/models/server_task_log_response_model.dart';

abstract class FitnessReportRepository {
  Future<Response> generateReport(
    Map<String, dynamic> data, {
    void Function(int, int)? onReceiveProgress,
  });

  Future<Response> fetchRecoveryGoals();
  Future<Response> fetchSchedulesTasks();
  Future<Response> fetchRecoveryStrategies();
  Future<Response> fetchRecoveryObjective();
  Future<Response> fetchNutritionStrategies();
  Future<Response> fetchNutritionObjectives();
  Future<Response> fetchNutritionGoals();
  Future<Response> fetchFitnessGoals();
  Future<Response> fetchFitnessPlan();
  Future<Response> fetchActivityTask();
  Future<Response> fetchActivityStrategies();
  Future<Response> fetchActivityObjective();
  Future<Response> fetchActivityGoalsObjective();
  Future<Response> fetchActivityFocus();

  Future<ServerTaskLagResponseModel> checkServerBackgroundTask(String celeryTaskId);
}
