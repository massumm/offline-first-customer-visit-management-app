import 'package:get/get.dart';

import '../controllers/start_workout_controller.dart';

class StartWorkoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartWorkoutController>(
      () => StartWorkoutController(),
    );
  }
}
