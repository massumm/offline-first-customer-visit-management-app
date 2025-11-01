abstract class FitnessReportRepository {
  Future<void> generateReport(
      Map<String, dynamic> data, {
        void Function(int, int)? onSendProgress,
      });

  Future<void> fetchRecoveryGoals();
  Future<void> fetchSchedulesTasks();
  Future<void> fetchRecoveryStrategies();
  Future<void> fetchRecoveryObjective();
  Future<void> fetchNutritionStrategies();
  Future<void> fetchNutritionObjectives();
  Future<void> fetchNutritionGoals();
  Future<void> fetchFitnessGoals();
  Future<void> fetchFitnessPlan();
  Future<void> fetchActivityTask();
  Future<void> fetchActivityStrategies();
  Future<void> fetchActivityObjective();
  Future<void> fetchActivityGoalsObjective();
  Future<void> fetchActivityFocus();

}