import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/modules/goal_tracking/models/daily_goal_model.dart';

import '../../../base/network/dio_provider.dart';
import '../../../data/local/preference/store/user_store.dart';
import 'daily_goal_repository.dart';

class DailyGoalRepositoryImpl extends BaseRemoteSource
    implements DailyGoalRepository {
  final String? token = UserStore.to.token;

  @override
  Future<List<DailyGoalModel>> fetchDailyGoals() {
    final String endpoint =
        "${DioProvider.baseUrl}/api/goal_tracking/daily-goals/";
    final Map<String, String> headers = {
      'Authorization': "Bearer ${UserStore.to.token}",
    };
    Future<Response<dynamic>> dioCall = dioClient.get(
      endpoint,
      options: Options(headers: headers),
    );

    try {
      return callApiWithErrorParser(dioCall).then(
        (Response response) => (response.data as List)
            .map((json) => DailyGoalModel.fromJson(json))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
