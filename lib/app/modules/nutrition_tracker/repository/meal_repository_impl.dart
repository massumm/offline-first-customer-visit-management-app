import 'package:dio/dio.dart';
import 'package:icon/app/modules/nutrition_tracker/models/meal_response_model.dart';
import 'package:icon/app/modules/nutrition_tracker/repository/meal_repository.dart';

import '../../../base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';

class MealRepositoryImpl extends BaseRemoteSource
    implements MealRepository{
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

}