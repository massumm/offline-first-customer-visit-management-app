import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

import '../services/start_workout_services_index.dart';
import '../views/index.dart';
import '../views/widgets/clock_bottom_sheet.dart';

class StartWorkoutController extends BaseController {
  // ---------- Services ---------------
  final WorkoutSettingsService settingsService =
      Get.find<WorkoutSettingsService>();

  final ExerciseSelectionService exerciseSelectionService =
      Get.find<ExerciseSelectionService>();

  final WorkoutSetService workoutSetService =
      Get.find<WorkoutSetService>();

  @override
  void onInit() {
    super.onInit();

    settingsService.attach(this);
    workoutSetService.attach(this);
  }

  @override
  void onClose() {
    settingsService.detach();
    exerciseSelectionService.detach();
    super.onClose();
  }

  void onSettingTap() {
    Get.to(() => WorkoutSettingsView());
  }

  void onClockTap(BuildContext context) {
    showClockBottomSheet(context);
  }

  void onAddExerciseTap() {
    Get.to(() => ExerciseSelectionView());
  }
}
