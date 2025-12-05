import 'package:get/get.dart';

import '../controllers/your_recovery_goals_controller.dart';

class YourRecoveryGoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourRecoveryGoalsController>(
      () => YourRecoveryGoalsController(),
    );
  }
}
