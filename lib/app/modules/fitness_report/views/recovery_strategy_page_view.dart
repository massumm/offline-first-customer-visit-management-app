import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/models/info_card_model.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objectives_item_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objective_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class RecoveryStrategyPageView extends BaseView<FitnessReportController> {
  const RecoveryStrategyPageView({super.key});

  // Common values
  static const String _title = 'Your Recovery Strategy';
  static const String _yourRecoveryObjectives = 'Your Recovery Objectives';
  static const String _introBody =
      'You recover best when your energy is steady and your stress is low. Based on your responses, here\'s a recovery approach designed around your lifestyle.';

  // Use controller.currentRecoveryStrategy for dynamic data

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
              onPressed: controller.goToCongratulationsPage,
              label: 'Register',
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
    final strategy = controller.currentRecoveryStrategy;
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
                if (strategy != null) ...[
                  ObjectivesItemWidget(title: strategy.generalInsights),
                  16.height,
                  ObjectivesItemWidget(
                    title: strategy.generalLifestyleRecommendations,
                  ),
                ] else
                  ObjectivesItemWidget(
                    title: 'No recovery strategy data available',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column recoveryObjectivesWidget() {
    final strategy = controller.currentRecoveryStrategy;
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
        if (strategy != null && strategy.objectives.isNotEmpty)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            children: strategy.objectives
                .map(
                  (objective) => ObjectiveCardWidget(
                    assetPath: Assets.svgRecoveryFocus,
                    title: objective.objective,
                    description: objective.description,
                  ),
                )
                .toList(),
          )
        else
          Text('No recovery objectives available'),
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
