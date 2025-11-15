import 'package:flutter/material.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/modules/trainee_fitness_report_generation/views/saving_view.dart';

import '../controllers/trainee_fitness_report_generation_controller.dart';

class TraineeFitnessReportGenerationView
    extends BaseView<TraineeFitnessReportGenerationController> {
  const TraineeFitnessReportGenerationView({super.key});

  @override
  Widget body(BuildContext context) {
    return SavingView();
  }
}
