import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/start_workout/services/index.dart';

import '../services/start_workout_services_index.dart';
import '../views/index.dart';
import '../views/widgets/bottom_sheet/rest_timer_bottom_sheet.dart';
import '../views/widgets/clock_bottom_sheet.dart';

class StartWorkoutController extends BaseController {
  // ---------- Services ---------------
  final WorkoutSettingsService settingsService =
      Get.find<WorkoutSettingsService>();

  final ExerciseSelectionService exerciseSelectionService =
      Get.find<ExerciseSelectionService>();

  final WorkoutSetService workoutSetService = Get.find<WorkoutSetService>();

  final RestTimerService restTimerService = Get.find<RestTimerService>();

  // ------------- States -------------------

  @override
  void onInit() {
    super.onInit();

    settingsService.attach(this);
    workoutSetService.attach(this);
    restTimerService.attach(this);
    exerciseSelectionService.attach(this);
  }

  @override
  void onClose() {
    settingsService.detach();
    exerciseSelectionService.detach();
    workoutSetService.detach();
    restTimerService.detach();
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

  void onRestTimerTap() {
    Get.bottomSheet(
      RestTimerBottomSheet(
        selectedMinute: restTimerService.selectedMinute.value,
        selectedSecond: restTimerService.selectedSecond.value,
        onMinuteChanged: (value) {
          restTimerService.selectedMinute.value = value;
        },
        onSecondChanged: (value) {
          restTimerService.selectedSecond.value = value;
        },

        onStart: () {
          restTimerService.totalRestTimeInSec.value =
              restTimerService.selectedMinute.value * 60 +
              restTimerService.selectedSecond.value;
        },
      ),
    );
  }
}
