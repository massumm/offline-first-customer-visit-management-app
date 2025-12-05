import 'package:get/get.dart';

import '../controllers/goal_tracking_controller.dart';

class GoalTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalTrackingController>(
      () => GoalTrackingController(),
    );
  }
}
