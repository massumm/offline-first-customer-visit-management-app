// lib/app/modules/nutrition_tracker/bindings/nutrition_tracker_binding.dart
import 'package:get/get.dart';
import 'package:icon/app/modules/nutrition_tracker/controllers/nutrition_tracker_controller.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository_impl.dart'; // Ensure this is imported

class NutritionTrackerBinding extends Bindings {
  @override
  void dependencies() {
    // First, ensure the repository is available as other controllers might need it globally
    Get.lazyPut<MealRepository>(
          () => MealRepositoryImpl(),
      tag: (MealRepository).toString(),
      fenix: true, // Keep it in memory if other parts of the app might use it
    );

    // Then, put the NutritionTrackerController itself
    Get.lazyPut<NutritionTrackerController>(
          () => NutritionTrackerController(),
      // Optionally use fenix: true if you want it to persist across routes,
      // but typically controllers for a specific view are disposed when the view is popped.
      // For the main tracker screen, you might want it to persist, so `fenix: true` is okay.
      fenix: true, // This is often suitable for main screen controllers
    );
  }
}
        