import '../models/activity_logs_response_model.dart';

abstract class ActivityTrackerRepository {
  Future<ActivityLogsResponseModel> activityLogs();
}
