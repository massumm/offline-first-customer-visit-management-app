import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/models/activity_strategy_models.dart';
import 'package:icon/app/modules/fitness_report/models/info_card_model.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objectives_item_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objective_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class RecoveryStrategyPageView extends BaseView<FitnessReportController> {
  RecoveryStrategyPageView({super.key});

  // Common values
  static const String _title = 'Your Recovery Strategy';
  static const String _yourRecoveryObjectives = 'Your Recovery Objectives';
  static const String _introBody =
      'You recover best when your energy is steady and your stress is low. Based on your responses, here\'s a recovery approach designed around your lifestyle.';

  // Recovery Objectives Strategies
  static const List<String> _recoveryStrategies = [
    'Improve sleep consistency and quality',
    'Lower daily stress and improve focus',
    'Enhance muscle repair and mobility',
  ];

  // Recovery Objectives Data
  static final List<ActivityObjective> _recoveryObjectivesData = [
    ActivityObjective(
      asset: Assets.svgSleepCircular,
      title: 'SLEEP DURATION TARGET',
      description: '7-8 hours per night',
    ),
    ActivityObjective(
      asset: Assets.commonEnergyCircular,
      title: 'ENERGY LEVEL',
      description: 'Moderate, peaks in morning',
    ),
    ActivityObjective(
      asset: Assets.svgCurrentStress,
      title: 'CURRENT STRESS LEVEL',
      description: '1/10',
    ),
    ActivityObjective(
      asset: Assets.svgRecoveryDays,
      title: 'RECOVERY DAYS PER WEEK',
      description: '2-3',
    ),
    ActivityObjective(
      asset: Assets.svgTargetStress,
      title: 'TARGET STRESS LEVEL',
      description: '4/10',
    ),
    ActivityObjective(
      asset: Assets.svgRecoveryFocus,
      title: 'RECOVERY FOCUS',
      description: 'Mobility & Active Rest',
    ),
  ];

  // Info Cards Data
  static final List<InfoCardData> _infoCardsData = [
    InfoCardData(
      icon: Assets.svgLifestyleConsiderations,
      title: 'Repair Strategy',
      description:
          'To help you recover faster, I\'ve built a mix of rest and movement into your plan, including light mobility sessions, proper sleep targets, and active rest days. These help your body adapt without burning out.',
      iconType: IconType.svg,
    ),
    InfoCardData(
      icon: Assets.svgLifestyleConsiderations,
      title: 'Lifestyle Considerations',
      description:
          'Your schedule and habits matter. Since you mentioned a busy work routine with irregular hours, your plan prioritizes short, effective recovery techniques that fit your day.',
      iconType: IconType.svg,
    ),
    InfoCardData(
      icon: Assets.imagesFitnessReportFace,
      title: 'Icon Insight',
      description:
          'Your schedule and habits matter. Since you mentioned a busy work routine with irregular hours, your plan prioritizes short, effective recovery techniques that fit your day.',
      isGradient: true,
      iconType: IconType.asset,
    ),
  ];

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            appbarWidget(),
            16.height,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    introWidget(),
                    16.height,
                    recoveryStrategiesWidget(),
                    16.height,
                    recoveryObjectivesWidget(),
                    16.height,
                    ...infoCardsWidgets(),
                    8.height,
                  ],
                ),
              ),
            ),
            8.height,
            LoadingButton(
              onPressed: controller.gotToNextPage,
              label: 'View your report',
            ),
          ],
        ),
      ),
    );
  }

  FitnessReportAppbarWidget appbarWidget() {
    return FitnessReportAppbarWidget(controller: controller, title: _title);
  }

  IntroWidget introWidget() {
    return IntroWidget(body: _introBody);
  }

  Container recoveryStrategiesWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _yourRecoveryObjectives,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          16.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? AppColors.darkBgColorPositive
                  : AppColors.positiveBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.positiveBorderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._recoveryStrategies.asMap().entries.expand(
                  (entry) => [
                    ObjectivesItemWidget(title: entry.value),
                    if (entry.key < _recoveryStrategies.length - 1) 16.height,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column recoveryObjectivesWidget() {
    final recoveryObjectivestitleFontSize = 18.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _yourRecoveryObjectives,
          style: Get.textTheme.bodyLarge?.copyWith(
            fontSize: recoveryObjectivestitleFontSize,
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
          childAspectRatio: 1,
          children: _recoveryObjectivesData
              .map(
                (objective) => ObjectiveCardWidget(
                  assetPath: objective.asset,
                  title: objective.title,
                  description: objective.description,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  List<Widget> infoCardsWidgets() {
    return _infoCardsData
        .asMap()
        .entries
        .expand(
          (entry) => [
            InfoCardWidget(
              icon: entry.value.icon,
              title: entry.value.title,
              description: entry.value.description,
              isGradient: entry.value.isGradient,
              iconType: entry.value.iconType,
            ),
            if (entry.key < _infoCardsData.length - 1) 16.height,
          ],
        )
        .toList();
  }
}
