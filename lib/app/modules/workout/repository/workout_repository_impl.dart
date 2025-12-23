import 'dart:async';

import 'package:dio/dio.dart';
import 'package:icon/app/modules/workout/models/workout_create_response_model.dart';

import '../../../base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';
import 'workout_repository.dart';

class WorkoutRepositoryImpl extends BaseRemoteSource
    implements WorkoutRepository {
  @override
  Future<WorkoutCreateResponseModel> createWorkout(Map<String, dynamic> body) {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity-tracking/workouts/create/";
    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseWorkoutCreateResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  WorkoutCreateResponseModel _parseWorkoutCreateResponse(
    Response<dynamic> response,
  ) => WorkoutCreateResponseModel.fromJson(response.data);
}
