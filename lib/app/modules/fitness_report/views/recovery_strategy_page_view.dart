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
  static const List<Map<String, String>> _recoveryObjectivesData = [
    {
      'asset': 'svgSleepCircular',
      'title': 'SLEEP DURATION TARGET',
      'description': '7-8 hours per night',
    },
    {
      'asset': 'commonEnergyCircular',
      'title': 'ENERGY LEVEL\n',
      'description': 'Moderate, peaks in morning',
    },
    {
      'asset': 'svgCurrentStress',
      'title': 'CURRENT STRESS LEVEL',
      'description': '1/10',
    },
    {
      'asset': 'svgRecoveryDays',
      'title': 'RECOVERY DAYS PER WEEK',
      'description': '2-3',
    },
    {
      'asset': 'svgTargetStress',
      'title': 'TARGET STRESS LEVEL',
      'description': '4/10',
    },
    {
      'asset': 'svgRecoveryFocus',
      'title': 'RECOVERY FOCUS\n',
      'description': 'Mobility & Active Rest',
    },
  ];

  // Info Cards Data
  static const List<Map<String, String>> _infoCardsData = [
    {
      'icon': 'svgLifestyleConsiderations',
      'title': 'Repair Strategy',
      'description':
          'To help you recover faster, I\'ve built a mix of rest and movement into your plan, including light mobility sessions, proper sleep targets, and active rest days. These help your body adapt without burning out.',
    },
    {
      'icon': 'svgLifestyleConsiderations',
      'title': 'Lifestyle Considerations',
      'description':
          'Your schedule and habits matter. Since you mentioned a busy work routine with irregular hours, your plan prioritizes short, effective recovery techniques that fit your day.',
    },
    {
      'icon': 'imagesFitnessReportFace',
      'title': 'Icon Insight',
      'description':
          'Your schedule and habits matter. Since you mentioned a busy work routine with irregular hours, your plan prioritizes short, effective recovery techniques that fit your day.',
      'isGradient': 'true',
    },
  ];

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appbarWidget(),
            16.height,
            introWidget(),
            16.height,
            recoveryStrategiesWidget(),
            16.height,
            recoveryObjectivesWidget(),
            16.height,
            ...infoCardsWidgets(),
            16.height,
            LoadingButton(onPressed: controller.gotToNextPage, label: 'Next'),
          ],
        ),
      ),
    );
  }

  FitnessReportAppbarWidget appbarWidget() {
    return FitnessReportAppbarWidget(
      controller: controller,
      title: _title,
    );
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
                ..._recoveryStrategies
                    .asMap()
                    .entries
                    .expand(
                      (entry) => [
                        RecoveryStrategyItemWidget(title: entry.value),
                        if (entry.key < _recoveryStrategies.length - 1)
                          16.height,
                      ],
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column recoveryObjectivesWidget() {
    return Column(
      children: [
        Text(
          _yourRecoveryObjectives,
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
          children: _recoveryObjectivesData
              .map(
                (objective) => ObjectiveCardWidget(
                  assetPath: _getRecoveryAssetPath(objective['asset']!),
                  title: objective['title']!,
                  description: objective['description']!,
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
              icon: _getInfoCardAssetPath(entry.value['icon']!),
              title: entry.value['title']!,
              description: entry.value['description']!,
              isGradient: entry.value['isGradient'] == 'true',
              iconType: IconType.asset,
            ),
            if (entry.key < _infoCardsData.length - 1) 16.height,
          ],
        )
        .toList();
  }

  String _getRecoveryAssetPath(String assetName) {
    switch (assetName) {
      case 'svgSleepCircular':
        return Assets.svgSleepCircular;
      case 'commonEnergyCircular':
        return Assets.commonEnergyCircular;
      case 'svgCurrentStress':
        return Assets.svgCurrentStress;
      case 'svgRecoveryDays':
        return Assets.svgRecoveryDays;
      case 'svgTargetStress':
        return Assets.svgTargetStress;
      case 'svgRecoveryFocus':
        return Assets.svgRecoveryFocus;
      default:
        return Assets.commonEnergyCircular;
    }
  }

  String _getInfoCardAssetPath(String assetName) {
    switch (assetName) {
      case 'svgLifestyleConsiderations':
        return Assets.svgLifestyleConsiderations;
      case 'imagesFitnessReportFace':
        return Assets.imagesFitnessReportFace;
      default:
        return Assets.svgLifestyleConsiderations;
    }
  }
}
