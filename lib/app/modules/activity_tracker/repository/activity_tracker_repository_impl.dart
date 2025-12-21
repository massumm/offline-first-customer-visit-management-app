import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';

import '../../../base/network/dio_provider.dart';
import '../models/activity_logs_response_model.dart';
import 'activity_tracker_repository.dart';

class ActivityTrackerRepositoryImpl extends BaseRemoteSource
    implements ActivityTrackerRepository {
  @override
  Future<ActivityLogsResponseModel> activityLogs() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity-tracking/workouts/";
    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseActivityResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  ActivityLogsResponseModel _parseActivityResponse(Response<dynamic> response) {
    return ActivityLogsResponseModel.fromJson(response.data);
  }
}
