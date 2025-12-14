import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/start_workout/views/workout_settings_view.dart';

import '../services/start_workout_services_index.dart';
import '../views/widgets/clock_bottom_sheet.dart';

class StartWorkoutController extends BaseController {
  // ---------- Services ---------------
  final WorkoutSettingsService settingsService =
      Get.find<WorkoutSettingsService>();

  @override
  void onInit() {
    super.onInit();

    settingsService.attach(this);
  }

  void onSettingTap() {
    Get.to(() => WorkoutSettingsView());
  }

  void onClockTap(BuildContext context) {
    showClockBottomSheet(context);
  }
}
