import 'package:get/get.dart';
import 'package:icon/app/modules/workout/services/index.dart';
import 'package:icon/app/modules/workout/services/save_workout_service.dart';
import '../controllers/workout_controller.dart';

class WorkoutBinding extends Bindings {
  @override
  void dependencies() {
    // ------------ Services -------------
    Get.lazyPut<WorkoutSettingsService>(() => WorkoutSettingsService());
    Get.lazyPut<ExerciseSelectionService>(() => ExerciseSelectionService());

    Get.lazyPut<WorkoutSetService>(() => WorkoutSetService());
    Get.lazyPut<RestTimerService>(() => RestTimerService());
    Get.lazyPut<SaveWorkoutService>(() => SaveWorkoutService());

    // --------- Controller -----------------
    Get.lazyPut<WorkoutController>(() => WorkoutController());
  }
}
