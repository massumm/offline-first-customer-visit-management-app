import 'package:get/get.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/repository/fitness_report_repository.dart';

class FitnessReportService {
  FitnessReportController? _controller;

  // ---------------- Repository ---------------
  final FitnessReportRepository _reportRepository = Get.find(
    tag: (FitnessReportRepository).toString(),
  );

  void attach(FitnessReportController c) {
    _controller = c;
  }

  void detach() {
    _controller = null;
  }

  Future<dynamic> fetchFitnessPlan() async {
    final response = await _reportRepository.fetchFitnessPlan();
    return response.data;
  }

  Future<dynamic> fetchRecoveryStrategies() async {
    final response = await _reportRepository.fetchRecoveryStrategies();
    return response.data;
  }

  Future<dynamic> fetchRecoveryGoals() async {
    final response = await _reportRepository.fetchRecoveryGoals();
    return response.data;
  }

  Future<dynamic> fetchRecoveryObjectives() async {
    final response = await _reportRepository.fetchRecoveryObjective();
    return response.data;
  }

  Future<dynamic> fetchNutritionStrategies() async {
    final response = await _reportRepository.fetchNutritionStrategies();
    return response.data;
  }

  Future<dynamic> fetchNutritionGoals() async {
    final response = await _reportRepository.fetchNutritionGoals();
    return response.data;
  }

  Future<dynamic> fetchNutritionObjectives() async {
    final response = await _reportRepository.fetchNutritionObjectives();
    return response.data;
  }

  Future<dynamic> fetchActivityStrategies() async {
    final response = await _reportRepository.fetchActivityStrategies();
    return response.data;
  }

  Future<dynamic> fetchActivityGoals() async {
    final response = await _reportRepository.fetchActivityGoalsObjective();
    return response.data;
  }

  Future<dynamic> fetchActivityObjectives() async {
    final response = await _reportRepository.fetchActivityObjective();
    return response.data;
  }

  Future<dynamic> fetchActivityFocusAreas() async {
    final response = await _reportRepository.fetchActivityFocus();
    return response.data;
  }

  Future<dynamic> fetchActivityTasks() async {
    final response = await _reportRepository.fetchActivityTask();
    return response.data;
  }

  Future<dynamic> fetchSchedulesTasks() async {
    final response = await _reportRepository.fetchSchedulesTasks();
    return response.data;
  }

  Future<dynamic> generateReport(Map<String, dynamic> data) async {
    final response = await _reportRepository.generateReport(data);
    return response.data;
  }
}
