import 'package:get/get.dart';

import '../controllers/nutrition_tracker_controller.dart';

class NutritionTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NutritionTrackerController>(
      () => NutritionTrackerController(),
    );
  }
}
