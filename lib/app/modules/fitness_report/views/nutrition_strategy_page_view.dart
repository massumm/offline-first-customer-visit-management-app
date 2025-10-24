import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/recovery_strategy_item_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/profile_stats_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class NutritionStrategyPageView extends BaseView<FitnessReportController> {
  NutritionStrategyPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Your Nutrition Strategy',
            ),
            16.height,
            IntroWidget(
              body:
                  'Food is fuel and the right balance can transform your energy, focus, and recovery. Based on your goals and habits, here\'s a plan built for sustainable results.',
            ),
            16.height,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Nutrition Objectives',
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.height,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.positiveBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.positiveBorderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RecoveryStrategyItemWidget(
                          title:
                              'Support your training and recovery with the right energy balance.',
                        ),
                        16.height,
                        RecoveryStrategyItemWidget(
                          title:
                              'Improve consistency through structured but flexible meals.',
                        ),
                        16.height,
                        RecoveryStrategyItemWidget(
                          title:
                              'Strengthen healthy food relationships and sustainable habits',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            16.height,
            ProfileStatsWidget(
              title: 'Your Daily Targets',
              stats: [
                StatItem(label: 'Daily Calorie Target', value: '2400 kcal'),
                StatItem(label: 'Protein', value: '180 g (30%)'),
                StatItem(label: 'Carbohydrates', value: '270 g (45%)'),
                StatItem(label: 'Fats', value: '67 g (25%)'),
                StatItem(label: 'Meal Frequency', value: '4 meals/day'),
                StatItem(label: 'Hydration Goal', value: '3.5 L/day'),
                StatItem(label: 'Dietary Preference', value: 'Balanced'),
                StatItem(
                  label: 'Restrictions / Allergies',
                  value: 'None specified',
                ),
              ],
            ),
            16.height,
            InfoCardWidget(
              icon: Assets.imagesFitnessReportFace,
              title: 'Icon Insight',
              description:
                  'You mentioned that eating well can be challenging when life gets busy – meal prepping twice a week can help you stay consistent without feeling restricted. Remember, progress comes from patterns, not perfection.',
              isGradient: true,
              iconType: IconType.asset,
            ),
            16.height,
            LoadingButton(onPressed: controller.gotToNextPage, label: 'Next'),
          ],
        ),
      ),
    );
  }
}
