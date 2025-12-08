import 'package:get/get.dart';

import '../controllers/fitness_report_controller.dart';

class FitnessReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FitnessReportController>(
      () => FitnessReportController(),
    );
  }
}
