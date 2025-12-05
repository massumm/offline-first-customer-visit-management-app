import 'package:dio/dio.dart';
import '../models/daily_goal_model.dart';
import 'goal_tracking_repository.dart';

class GoalTrackingRepositoryImpl implements GoalTrackingRepository {
  final Dio dio;
  GoalTrackingRepositoryImpl(this.dio);

  @override
  Future<List<DailyGoalModel>> fetchDailyGoals() async {
    /*final response = await dio.get('/api/goal_tracking/daily-goals/');
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => DailyGoalModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch daily goals');
    }*/
    return [];
  }
}
