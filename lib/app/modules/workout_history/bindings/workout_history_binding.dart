import 'package:get/get.dart';

import '../controllers/workout_history_controller.dart';

class WorkoutHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkoutHistoryController>(
      () => WorkoutHistoryController(),
    );
  }
}
