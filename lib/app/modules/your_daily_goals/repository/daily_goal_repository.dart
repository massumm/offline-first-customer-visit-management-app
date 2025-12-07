import 'package:icon/app/modules/goal_tracking/models/daily_goal_model.dart';

abstract class DailyGoalRepository {

  Future<List<DailyGoalModel>> fetchDailyGoals();
}