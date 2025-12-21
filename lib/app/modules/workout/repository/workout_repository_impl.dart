import 'package:dio/dio.dart';

import '../../../base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';
import '../models/equipments_response_model.dart';
import '../models/exercises_response_model.dart';
import '../models/muscle_group_response_model.dart';
import 'workout_repository.dart';

class WorkoutRepositoryImpl extends BaseRemoteSource
    implements WorkoutRepository {
  @override
  Future<EquipmentResponseModel> getEquipments() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/equipment/";
    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseEquipmentsResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  EquipmentResponseModel _parseEquipmentsResponse(Response<dynamic> response) {
    return EquipmentResponseModel.fromJson(response.data);
  }

  @override
  Future<ExercisesResponseModel> getExercises() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/exercises/";
    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseExercisesResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  ExercisesResponseModel _parseExercisesResponse(Response<dynamic> response) {
    return ExercisesResponseModel.fromJson(response.data);
  }

  @override
  Future<MuscleGroupResponseModel> getMusclesGroups() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/muscle-groups/";
    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseMuscleGroupsResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  MuscleGroupResponseModel _parseMuscleGroupsResponse(
    Response<dynamic> response,
  ) {
    return MuscleGroupResponseModel.fromJson(response.data);
  }
}
