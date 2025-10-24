import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';

class DailyGoalsPageView extends BaseView<FitnessReportController> {
  DailyGoalsPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Daily Goals',
            ),
            16.height,
            Text(
              'Your Daily Goals',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            12.height,
            Text(
              'Stay on track with your personalized daily fitness goals.',
              style: Get.textTheme.bodyMedium,
            ),
            24.height,
            // Add daily goals content here
            const Spacer(),
            LoadingButton(onPressed: controller.gotToNextPage, label: 'Next'),
          ],
        ),
      ),
    );
  }
}
