import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/workout/services/save_workout_service.dart';
import 'package:icon/app/modules/workout/views/save_workout_view.dart';
import '../services/rest_timer_service.dart';
import '../services/start_workout_services_index.dart';
import '../views/index.dart';
import '../views/widgets/bottom_sheet/rest_timer_bottom_sheet.dart';
import '../views/widgets/clock_bottom_sheet.dart';

class WorkoutController extends BaseController {
  // ---------- Services ---------------
  final WorkoutSettingsService settingsService =
      Get.find<WorkoutSettingsService>();
  final ExerciseSelectionService exerciseSelectionService =
      Get.find<ExerciseSelectionService>();
  final WorkoutSetService workoutSetService = Get.find<WorkoutSetService>();
  final RestTimerService restTimerService = Get.find<RestTimerService>();
  final SaveWorkoutService saveWorkoutService = Get.find<SaveWorkoutService>();

  // ------------- States -------------------
  Timer? _workoutTimer;
  final RxInt _elapsedSeconds = 0.obs;

  Rx<DateTime> loggedAt = DateTime.now().obs;



  double get totalVolume {
    return workoutSetService.workoutSets
        .where((set) => set.isComplete)
        .fold(0.0, (previousValue, set) {
      final reps = double.tryParse(set.reps) ?? 0;
      final kg = double.tryParse(set.kg) ?? 0;
      return previousValue + (reps * kg);
    });
  }
  String get onWorkoutDuration {
    final int hours = _elapsedSeconds.value ~/ 3600;
    final int minutes = (_elapsedSeconds.value % 3600) ~/ 60;
    final int seconds = _elapsedSeconds.value % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get totalSets => workoutSetService.workoutSets.length;
  @override
  void onInit() {
    super.onInit();
    settingsService.attach(this);
    workoutSetService.attach(this);
    restTimerService.attach(this);
    exerciseSelectionService.attach(this);
    saveWorkoutService.attach(this);

    // Start the workout timer
    _workoutTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedSeconds.value++;
    });
  }

  @override
  void onClose() {
    _workoutTimer?.cancel();
    settingsService.detach();
    exerciseSelectionService.detach();
    workoutSetService.detach();
    restTimerService.detach();
    saveWorkoutService.detach();
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

  void workoutOnDiscard() {
  }

  void workoutOnSave() {
    Get.to(() => SaveWorkoutView());
  }
}
