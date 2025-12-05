import 'package:get/get.dart';

import '../controllers/your_nutrition_goals_controller.dart';

class YourNutritionGoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourNutritionGoalsController>(
      () => YourNutritionGoalsController(),
    );
  }
}
