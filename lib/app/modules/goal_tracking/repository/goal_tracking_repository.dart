import '../models/daily_goal_model.dart';

abstract class GoalTrackingRepository {
  Future<List<DailyGoalModel>> fetchDailyGoals();
}
