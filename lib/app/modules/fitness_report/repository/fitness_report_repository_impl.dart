import 'package:icon/app/base/base_remote_source.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';

import 'fitness_report_repository.dart';

class FitnessReportRepositoryImpl extends BaseRemoteSource
    implements FitnessReportRepository {
  final String token = UserStore.to.token;
}
