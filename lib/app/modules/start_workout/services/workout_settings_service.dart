import 'package:get/get.dart';
import 'package:icon/app/core/utils/display_awake_util.dart';
import 'package:icon/app/modules/start_workout/controllers/start_workout_controller.dart';

// workout setting business logic.
class WorkoutSettingsService extends GetxService {
  StartWorkoutController? _c;

  final RxBool keepAwakeOnWorkout = false.obs;
  final RxBool plateCalculator = false.obs;
  final RxBool rpeTracker = false.obs;
  final RxBool smartSetScrolling = false.obs;
  final RxBool inlineTimer = false.obs;
  final RxBool personalRecordNotifications = false.obs;

  void attach(StartWorkoutController controller) {
    _c = controller;
  }

  void detach() {
    _c = null;
  }

  void toggleKeepAwakeOnWorkout(_) async {
    keepAwakeOnWorkout.toggle();

    await DisplayAwakeUtil.setAwake(keepAwakeOnWorkout.value);
  }

  void toggleRpeTracker(_) => rpeTracker.toggle();

  void togglePlateCalculator(_) => plateCalculator.toggle();

  void toggleSmartSetScrolling(_) => smartSetScrolling.toggle();

  void toggleInlineTimer(_) => inlineTimer.toggle();

  void togglePersonalRecordNotifications(_) =>
      personalRecordNotifications.toggle();
}
