import 'package:get/get.dart';

import '../controllers/weekly_routine_controller.dart';

class WeeklyRoutineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeeklyRoutineController>(
      () => WeeklyRoutineController(),
    );
  }
}
