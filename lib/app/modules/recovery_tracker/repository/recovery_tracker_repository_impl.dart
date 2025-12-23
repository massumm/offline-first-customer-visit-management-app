import 'package:dio/dio.dart' show Response;

import '../../../base/base_remote_source.dart';
import '../../../base/network/dio_provider.dart';
import '../models/activity_types_response_model.dart';
import '../models/recovery_response_model.dart';
import 'recovery_tracker_repository.dart';

class RecoveryTrackerRepositoryImpl extends BaseRemoteSource
    implements RecoveryTrackerRepository {
  @override
  Future<ActivityTypesResponseModel> getActivityTypes() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/activity-types/";

    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseActivityTypesResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  ActivityTypesResponseModel _parseActivityTypesResponse(
    Response<dynamic> response,
  ) {
    return ActivityTypesResponseModel.fromJson(response.data);
  }

  @override
  Future<RecoveryEntriesResponse> getRecoveryLists() {
    // TODO: implement getRecoveryLists
    final String endpoint =
        "${DioProvider.baseUrl}/api/v1/activity_tracking/recovery-entries";

    Future<Response<dynamic>> dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => _parseRecoveryResponse(response));
    } catch (e) {
      rethrow;
    }
  }
  RecoveryEntriesResponse _parseRecoveryResponse(
      Response<dynamic> response,
      ) {
    return RecoveryEntriesResponse.fromJson(response.data);
  }

}
