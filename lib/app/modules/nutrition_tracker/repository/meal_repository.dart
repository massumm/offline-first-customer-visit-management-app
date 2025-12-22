import 'package:icon/app/modules/nutrition_tracker/models/meal_response_model.dart';

abstract class MealRepository {
  Future<MealsResponse> getMeals();
}