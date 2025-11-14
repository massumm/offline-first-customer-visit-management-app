import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objective_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objectives_item_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/profile_stats_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class NutritionStrategyPageView extends BaseView<FitnessReportController> {
  NutritionStrategyPageView({super.key});

  // Common values
  static const String _title = 'Your Nutrition Strategy';
  static const String _yourNutritionObjectives = 'Your Nutrition Objectives';
  static const String _introBody =
      'Food is fuel and the right balance can transform your energy, focus, and recovery. Based on your goals and habits, here\'s a plan built for sustainable results.';
  static const String _iconInsightTitle = 'Icon Insight';
  static const String _iconInsightDescription =
      'You mentioned that eating well can be challenging when life gets busy – meal prepping twice a week can help you stay consistent without feeling restricted. Remember, progress comes from patterns, not perfection.';
  static const Color _dividerColor = Color(0xFFE8E4E2);

  // Use controller.currentNutritionStrategy for dynamic data

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
                    nutritionStrategiesWidget(),
                    16.height,
                    nutritionObjectivesWidget(),
                    16.height,
                    dailyTargets(),
                    16.height,
                    iconInsightWidget(),
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

  Container nutritionStrategiesWidget() {
    final strategy = controller.currentNutritionStrategy;
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
            _yourNutritionObjectives,
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
                    title: strategy.generalDietaryRecommendations,
                  ),
                ] else
                  ObjectivesItemWidget(
                    title: 'No nutrition strategy data available',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column nutritionObjectivesWidget() {
    final strategy = controller.currentNutritionStrategy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _yourNutritionObjectives,
          style: Get.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
            childAspectRatio: 1.1,
            children: strategy.objectives
                .map(
                  (objective) => ObjectiveCardWidget(
                    assetPath: Assets.nutritionObjectivesHealthyHabits,
                    title: objective.objective,
                    description: objective.description,
                  ),
                )
                .toList(),
          )
        else
          Text('No nutrition objectives available'),
      ],
    );
  }

  InfoCardWidget iconInsightWidget() {
    return InfoCardWidget(
      icon: Assets.imagesFitnessReportFace,
      title: _iconInsightTitle,
      description: _iconInsightDescription,
      isGradient: true,
      iconType: IconType.asset,
    );
  }

  Column dailyTargets() {
    final strategy = controller.currentNutritionStrategy;
    return Column(
      children: [
        ProfileStatsWidget(
          title: 'Your Daily Targets',
          stats: strategy != null && strategy.objectives.isNotEmpty
              ? strategy.objectives
                    .map(
                      (obj) => StatItem(
                        label: obj.objective,
                        value: obj.description,
                      ),
                    )
                    .toList()
              : [],
          dividerColor: _dividerColor,
        ),
        16.height,
        ProfileStatsWidget(
          title: 'Nutrition Approach',
          stats: strategy != null
              ? [
                  StatItem(
                    label: 'General Insights',
                    value: strategy.generalInsights,
                  ),
                  StatItem(
                    label: 'Dietary Recommendations',
                    value: strategy.generalDietaryRecommendations,
                  ),
                ]
              : [],
          dividerColor: _dividerColor,
        ),
      ],
    );
  }
}
