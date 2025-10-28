import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';

class FitnessReportService {
  FitnessReportController? _controller;

  void attach(FitnessReportController c) {
    _controller = c;

    // Api connections descriptions.
  }

  void detach() {
    _controller = null;
  }
}
