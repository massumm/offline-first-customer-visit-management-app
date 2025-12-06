import 'package:get/get.dart';
import '../models/daily_goal_model.dart';
import '../repository/goal_tracking_repository.dart';
import '../repository/goal_tracking_repository_impl.dart';
import 'package:dio/dio.dart';

class GoalTrackingController extends GetxController {
  final GoalTrackingRepository repository = GoalTrackingRepositoryImpl(Dio());

  final RxList<DailyGoalModel> dailyGoals = <DailyGoalModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDailyGoals();
  }

  Future<void> fetchDailyGoals() async {
    isLoading.value = true;
    error.value = '';
    try {
      final goals = await repository.fetchDailyGoals();
      dailyGoals.assignAll(goals);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
