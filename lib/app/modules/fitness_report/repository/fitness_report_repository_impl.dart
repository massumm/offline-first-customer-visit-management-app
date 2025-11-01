import 'package:dio/dio.dart';
import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';

import '../../../base/network/dio_provider.dart';
import 'fitness_report_repository.dart';

class FitnessReportRepositoryImpl extends BaseRemoteSource
    implements FitnessReportRepository {
  final String token = UserStore.to.token;

  @override
  Future<void> generateReport(Map<String, dynamic> data,  {void Function(int, int)? onSendProgress,}) {
    final String endpoint = "${DioProvider.baseUrl}/api/fitness_plan/generate/";

    final Map<String, String> headers = {'Authorization': "Bearer $token"};

    Future<Response<dynamic>> dioCall = dioClient.post(
      endpoint,
      options: Options(headers: headers),
      data: data,
      onSendProgress: onSendProgress,
    );

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((Response response) => Future.value());
    } catch (e) {
      rethrow;
    }
  }
}
