import 'package:get/get.dart';
import 'package:icon/app/modules/nutrition_tracker/controllers/nutrition_tracker_entry_controller.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository_impl.dart';

class NutritionTrackerEntryBinding extends Bindings {
  @override
  void dependencies() {
    // Register MealRepository if it hasn't been already (e.g., in InitialBindings)
    // Using lazyPut with a tag is good practice if it's not a global singleton
    Get.lazyPut<MealRepository>(
            () => MealRepositoryImpl(),
        tag: (MealRepository).toString(),
        // The `fenix` property can keep it in memory after its route is gone
        // but only rebuilds its state if needed, if false it will be disposed
        fenix: true // Keep repository in memory even if not directly used, useful if other controllers need it.
    );

    // Put the entry controller. Get.lazyPut is preferred for controllers tied to a single view.
    Get.lazyPut<NutritionTrackerEntryController>(
          () => NutritionTrackerEntryController(),
    );
  }
}