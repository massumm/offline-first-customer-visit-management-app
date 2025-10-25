import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import '../controllers/trainee_fitness_report_generation_controller.dart';
import 'email_registration_view.dart';
import 'saving_view.dart';

class TraineeFitnessReportGenerationView
    extends BaseView<TraineeFitnessReportGenerationController> {
  TraineeFitnessReportGenerationView({super.key});

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      return controller.enableApiProgressState.isTrue
          ?  SavingView()
          : const EmailRegistrationView();
    });
  }
}


