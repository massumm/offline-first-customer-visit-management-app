import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/models/activity_strategy_models.dart';
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

  // Nutrition Strategies
  static const List<String> _nutritionStrategies = [
    'Support your training and recovery with the right energy balance.',
    'Improve consistency through structured but flexible meals.',
    'Strengthen healthy food relationships and sustainable habits',
  ];

  // Daily Targets Data
  static const List<Map<String, String>> _dailyTargetsData = [
    {'label': 'Daily Calorie Target', 'value': '2400 kcal'},
    {'label': 'Protein', 'value': '180 g (30%)'},
    {'label': 'Carbohydrates', 'value': '270 g (45%)'},
    {'label': 'Fats', 'value': '67 g (25%)'},
  ];

  // Nutrition Approach Data
  static const List<Map<String, String>> _nutritionApproachData = [
    {'label': 'Meal Frequency', 'value': '4 meals/day'},
    {'label': 'Hydration Goal', 'value': '3.5 L/day'},
    {'label': 'Dietary Preference', 'value': 'Balanced'},
    {'label': 'Restrictions / Allergies', 'value': 'None specified'},
  ];

  // Nutrition Objectives Data
  static final List<ActivityObjective> _nutritionObjectivesData = [
    ActivityObjective(
      asset: Assets.nutritionObjectivesCurrentWeight,
      title: 'Current Weight',
      description: '180 lbs',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesGoalWeight,
      title: 'Goal Weight',
      description: '170 lbs',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesCurrentBodyFat,
      title: 'Current Body Fat %',
      description: '18%',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesTargetBodyFat,
      title: 'Target Body Fat %',
      description: '14%',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesHydrationGoal,
      title: 'Hydration Goal',
      description: '3.5 L/day',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesEnergyObjective,
      title: 'Energy Objective',
      description: 'Feel more energetic daily',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesMealConsistency,
      title: 'Meal Consistency',
      description: 'Improve structure & prep',
    ),
    ActivityObjective(
      asset: Assets.nutritionObjectivesHealthyHabits,
      title: 'Healthy Habits',
      description: 'Balanced eating patterns',
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
                ..._nutritionStrategies.asMap().entries.expand(
                  (entry) => [
                    ObjectivesItemWidget(title: entry.value),
                    if (entry.key < _nutritionStrategies.length - 1) 16.height,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column nutritionObjectivesWidget() {
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
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.1,
          children: _nutritionObjectivesData
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
    return Column(
      children: [
        ProfileStatsWidget(
          title: 'Your Daily Targets',
          stats: _dailyTargetsData
              .map(
                (item) =>
                    StatItem(label: item['label']!, value: item['value']!),
              )
              .toList(),
          dividerColor: _dividerColor,
        ),
        16.height,
        ProfileStatsWidget(
          title: 'Nutrition Approach',
          stats: _nutritionApproachData
              .map(
                (item) =>
                    StatItem(label: item['label']!, value: item['value']!),
              )
              .toList(),
          dividerColor: _dividerColor,
        ),
      ],
    );
  }
}
