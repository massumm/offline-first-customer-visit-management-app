import 'package:get/get.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/repository/fitness_report_repository.dart';

class FitnessReportService {
  FitnessReportController? _controller;

  // ---------------- Repository ---------------
  final FitnessReportRepository _reportRepository = Get.find(
    tag: (FitnessReportRepository).toString(),
  );

  void attach(FitnessReportController c) {
    _controller = c;

    // Api connections descriptions.
  }

  void detach() {
    _controller = null;
  }
}
