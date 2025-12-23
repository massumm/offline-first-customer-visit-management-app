import '../models/activity_types_response_model.dart';
import '../models/recovery_response_model.dart';

abstract class RecoveryTrackerRepository {
  Future<ActivityTypesResponseModel> getActivityTypes();
  Future<RecoveryEntriesResponse> getRecoveryLists();
}
