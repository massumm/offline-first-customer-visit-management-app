import 'package:get/get.dart';

import '../controllers/your_daily_goals_controller.dart';
import '../repository/daily_goal_repository.dart';
import '../repository/daily_goal_repository_impl.dart';

class YourDailyGoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyGoalRepository>(
      () => DailyGoalRepositoryImpl(),
      tag: (DailyGoalRepository).toString(),
    );
    Get.lazyPut<YourDailyGoalsController>(() => YourDailyGoalsController());
  }
}
