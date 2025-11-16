import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/extensions/app_extansions.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import 'progress_ring.dart';

class GoalsCard extends StatelessWidget {
  final VoidCallback onPressed;

  const GoalsCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightCardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.lightBorderGrayColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Daily Goals',
                      style: AppTextTheme.headlineSmallBold,
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  ' ${controller.completedGoals.value}/${controller.totalGoals.value}',
                              style: AppTextTheme.bodyMediumRegular.copyWith(
                                color: AppColors.colorPrimary,
                              ),
                            ),
                            TextSpan(
                              text: ' Goals Completed',
                              style: AppTextTheme.bodyMediumRegular.copyWith(
                                color: AppColors.lightTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.width,
              Obx(
                () => ProgressRing(
                  size: 74,
                  value: controller.totalGoals.value > 0
                      ? controller.completedGoals.value /
                            controller.totalGoals.value
                      : 0.0,
                  valueColor: AppColors.gradientRedStart,
                  valueGradient: AppColors.redGradient,
                  thickness: 8,
                  showPercentage: true,
                  percentageFontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
