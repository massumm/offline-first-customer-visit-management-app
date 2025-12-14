import 'package:get/get.dart';

import '../controllers/start_workout_controller.dart';
import '../services/workout_settings_service.dart';

class StartWorkoutBinding extends Bindings {
  @override
  void dependencies() {
    // ------------ Services -------------
    Get.lazyPut<WorkoutSettingsService>(() => WorkoutSettingsService());
    Get.lazyPut<StartWorkoutController>(() => StartWorkoutController());
  }
}
