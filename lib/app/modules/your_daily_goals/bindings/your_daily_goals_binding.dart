import 'package:get/get.dart';

import '../controllers/your_daily_goals_controller.dart';

class YourDailyGoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourDailyGoalsController>(
      () => YourDailyGoalsController(),
    );
  }
}
