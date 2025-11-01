import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';

class FitnessReportAppbarWidget extends StatelessWidget {
  const FitnessReportAppbarWidget({
    super.key,
    required this.controller,
    this.title,
  });

  final FitnessReportController controller;
  final String? title;
  final double titleFontSize = 18;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionPill(
          onTap: controller.currentPageIndex.value == 0
              ? Get.back
              : controller.gotToPreviousPage,
        ),
        Text(
          title ?? '',
          style: Get.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        // add hamburger icon
        ActionPill(onTap: controller.showOptionsBottomSheet, icon: Icons.menu),
      ],
    );
  }
}
