import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';

import '../controllers/fitness_report_controller.dart';

class ReportDisplayView extends BaseView<FitnessReportController> {
  const ReportDisplayView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.onPageChange,
        itemCount: controller.pages.length,
        itemBuilder: (context, index) => controller.pages[index],
      ),
    );
  }
}
