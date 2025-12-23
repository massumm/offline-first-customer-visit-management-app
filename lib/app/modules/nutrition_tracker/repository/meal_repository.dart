import 'package:icon/app/modules/nutrition_tracker/models/meal_response_model.dart';

abstract class MealRepository {
  Future<MealsResponse> getMeals();
  Future<void> createMeal({
    required String name,
    required int calories,
    required int protein,
    required int fats,
    required int carbs,
  });
  Future<void> updateMeal({
    required int mealId,
    required String name,
    required int calories,
    required int protein,
    required int fats,
    required int carbs,
  });
}