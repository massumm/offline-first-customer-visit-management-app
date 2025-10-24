import 'package:get/get.dart';

import '../controllers/trainee_fitness_report_generation_controller.dart';

class TraineeFitnessReportGenerationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraineeFitnessReportGenerationController>(
      () => TraineeFitnessReportGenerationController(),
    );
  }
}
