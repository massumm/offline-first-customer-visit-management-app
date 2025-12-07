// lib/app/modules/fitness_report/views/fitness_report_view.dart

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/modules/goal_tracking/views/goal_tracking_view.dart';
import 'package:icon/app/modules/your_activity_goals/views/your_activity_goals_view.dart';
import 'package:icon/app/modules/your_nutrition_goals/views/your_nutrition_goals_view.dart';
import 'package:icon/app/modules/your_recovery_goals/views/your_recovery_goals_view.dart';

import '../../../core/widgets/goal_stepper_footer.dart';
import '../controllers/fitness_report_controller.dart';

class FitnessReportView extends GetView<FitnessReportController> {
  const FitnessReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: controller.pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: controller.onPageChanged,
            children: const [
              GoalTrackingView(),
              YourActivityGoalsView(),
              YourNutritionGoalsView(),
              YourRecoveryGoalsView(),
            ],
          ),
          Obx(() => GoalStepperFooter(
            stepIndex: controller.currentPageIndex.value,
            onPressed: controller.goToNextPage,
          )),
        ],
      ),
    );
  }
}
