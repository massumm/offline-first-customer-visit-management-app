import 'package:get/get.dart';
import 'package:icon/app/modules/start_workout/services/index.dart';

import '../controllers/start_workout_controller.dart';
import '../services/start_workout_services_index.dart';

class StartWorkoutBinding extends Bindings {
  @override
  void dependencies() {
    // ------------ Services -------------
    Get.lazyPut<WorkoutSettingsService>(() => WorkoutSettingsService());
    Get.lazyPut<ExerciseSelectionService>(() => ExerciseSelectionService());
    Get.lazyPut<StartWorkoutController>(() => StartWorkoutController());
    Get.lazyPut<WorkoutSetService>(() => WorkoutSetService());
    Get.lazyPut<RestTimerService>(() => RestTimerService());
  }
}
