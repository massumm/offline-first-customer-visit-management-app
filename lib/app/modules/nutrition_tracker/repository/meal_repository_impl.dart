// E:/office/Icon/lib/app/modules/nutrition_tracker/repository/meal_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:icon/app/modules/nutrition_tracker/models/meal_response_model.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';

import '../../../base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';

class MealRepositoryImpl extends BaseRemoteSource
    implements MealRepository {

  @override
  Future<MealsResponse> getMeals() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/meals/";
    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseMealsResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  MealsResponse _parseMealsResponse(Response<dynamic> response) {
    return MealsResponse.fromJson(response.data);
  }

  // NEW: Implement createMeal
  @override
  Future<void> createMeal({
    required String name,
    required int calories,
    required int protein,
    required int fats,
    required int carbs,
  }) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/meals/";
    final Map<String, dynamic> data = {
      'name': name,
      'calorie_count': calories,
      'protein_grams': protein,
      'fat_grams': fats,
      'carbohydrate_grams': carbs,
      // Add any other required fields for creation
    };
    Future<Response<dynamic>> dioCall = dioClient.post(endpoint, data: data);

    try {
      await callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }

  // NEW: Implement updateMeal
  @override
  Future<void> updateMeal({
    required int mealId,
    required String name,
    required int calories,
    required int protein,
    required int fats,
    required int carbs,
  }) async {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/meals/$mealId/"; // Endpoint for a specific meal
    final Map<String, dynamic> data = {
      'name': name,
      'calorie_count': calories,
      'protein_grams': protein,
      'fat_grams': fats,
      'carbohydrate_grams': carbs,
      // Add any other fields that can be updated
    };
    Future<Response<dynamic>> dioCall = dioClient.put(endpoint, data: data); // Use PUT for updating

    try {
      await callApiWithErrorParser(dioCall);
    } catch (e) {
      rethrow;
    }
  }
}