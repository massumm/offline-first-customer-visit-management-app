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
import 'package:icon/app/modules/fitness_report/widgets/recovery_objective_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class RecoveryStrategyPageView extends BaseView<FitnessReportController> {
  RecoveryStrategyPageView({super.key});

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
              title: 'Your Recovery Strategy',
            ),
            16.height,
            IntroWidget(
              body:
                  'You recover best when your energy is steady and your stress is low. Based on your responses, here\'s a recovery approach designed around your lifestyle.',
            ),
            16.height,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Recovery Objectives',
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
                          title: 'Improve sleep consistency and quality',
                        ),
                        16.height,
                        RecoveryStrategyItemWidget(
                          title: 'Lower daily stress and improve focus',
                        ),
                        16.height,
                        RecoveryStrategyItemWidget(
                          title: 'Enhance muscle repair and mobility',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            16.height,
            Text(
              'Your Recovery Objectives',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.height,
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
              children: [
                RecoveryObjectiveCardWidget(
                  assetPath: Assets.svgSleepCircular,
                  title: 'SLEEP DURATION TARGET',
                  description: '7-8 hours per night',
                ),
                RecoveryObjectiveCardWidget(
                  assetPath: Assets.svgEnergyCircular,
                  title: 'ENERGY LEVEL\n',
                  description: 'Moderate, peaks in morning',
                ),
                RecoveryObjectiveCardWidget(
                  assetPath: Assets.svgSleepCircular,
                  title: 'CURRENT STRESS LEVEL',
                  description: '1/10',
                ),
                RecoveryObjectiveCardWidget(
                  assetPath: Assets.svgEnergyCircular,
                  title: 'RECOVERY DAYS PER WEEK',
                  description: '2-3',
                ),
                RecoveryObjectiveCardWidget(
                  assetPath: Assets.svgSleepCircular,
                  title: 'TARGET STRESS LEVEL',
                  description: '4/10',
                ),
                RecoveryObjectiveCardWidget(
                  assetPath: Assets.svgEnergyCircular,
                  title: 'RECOVERY FOCUS\n',
                  description: 'Mobility & Active Rest',
                ),
              ],
            ),
            16.height,
            InfoCardWidget(
              icon: Assets.svgLifestyleConsiderations,
              title: 'Repair Strategy',
              description:
                  'To help you recover faster, I\'ve built a mix of rest and movement into your plan, including light mobility sessions, proper sleep targets, and active rest days. These help your body adapt without burning out.',
            ),
            16.height,
            InfoCardWidget(
              icon: Assets.svgLifestyleConsiderations,
              title: 'Lifestyle Considerations',
              description:
                  'Your schedule and habits matter. Since you mentioned a busy work routine with irregular hours, your plan prioritizes short, effective recovery techniques that fit your day.',
            ),
            16.height,
            InfoCardWidget(
              icon: Assets.imagesFitnessReportFace,
              title: 'Icon Insight',
              description:
                  'Your schedule and habits matter. Since you mentioned a busy work routine with irregular hours, your plan prioritizes short, effective recovery techniques that fit your day.',
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
