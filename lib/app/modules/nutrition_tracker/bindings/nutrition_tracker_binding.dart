import 'package:get/get.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository_impl.dart';

import '../controllers/nutrition_tracker_controller.dart';

class NutritionTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NutritionTrackerController>(
      () => NutritionTrackerController(),
    );
    Get.lazyPut<MealRepository>(
          () => MealRepositoryImpl(),
      tag: (MealRepository).toString(),
    );
  }


}
