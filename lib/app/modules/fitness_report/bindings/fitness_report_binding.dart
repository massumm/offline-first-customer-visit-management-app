import 'package:get/get.dart';
import 'package:icon/app/modules/fitness_report/repository/fitness_report_repository.dart';
import 'package:icon/app/modules/fitness_report/repository/fitness_report_repository_impl.dart';
import 'package:icon/app/modules/fitness_report/services/FitnessReportService.dart';

import '../controllers/fitness_report_controller.dart';

class FitnessReportBinding extends Bindings {
  @override
  void dependencies() {
    // ----------------- Services  --------------
    Get.lazyPut<FitnessReportService>(
      () => FitnessReportService(),
      fenix: true,
    );
    // --------------- Controllers --------------
    Get.lazyPut<FitnessReportController>(
      () => FitnessReportController(),
      fenix: true, // Ensures controller can be recreated if needed
    );

    //------------- Repository --------------
    Get.lazyPut<FitnessReportRepository>(
      () => FitnessReportRepositoryImpl(),
      tag: (FitnessReportRepository).toString(),
    );
  }
}
