import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objective_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/recovery_strategy_item_widget.dart';
import 'package:icon/generated/assets.dart';

class ActivityStrategyPageView extends BaseView<FitnessReportController> {
  ActivityStrategyPageView({super.key});

  // Common values
  static const String _yourActivityObjectives = "Your Activity Objectives";
  static const String _recommendedTrainingPlan = "Recommended Training Plan";
  static const String _recommendedTrainingPlanDesc = "Full-Body Split";
  static const String _activityStrategyTitle = 'Activity Strategy';
  static const String _introBody =
      "Your Icon has analysed your training style, goals, and availability to design a plan that fits seamlessly into your week. The goal isn't just to move more — it's to move with purpose.";
  static const String _primaryFocusArea = 'Primary Focus Area';
  static const String _preferredActivities = 'Preferred Activities';
  static const String _energySystemFocus = 'Energy System Focus';
  static const String _energySystemFocusDesc =
      "Your plan targets multiple energy systems for optimal performance.";
  static const String _iconInsightTitle = 'Icon Insight';
  static const String _iconInsightDesc =
      "You want to tone your body and build strength  let's start with a 6-week foundational strength phase. After that, we'll transition to a hypertrophy approach to maximize definition and energy output.";
  static const String _trainingDays = 'Training Days';

  static const List<Map<String, String>> _recommendedTrainingPlanList = [
    {'title': 'Frequency', 'description': '4 days per week'},
    {'title': 'Session Duration', 'description': '45–60 mins'},
  ];

  static const List<String> _trainingDaysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Saturday',
  ];

  // Activity Objectives Data
  static const List<Map<String, String>> _activityObjectivesData = [
    {
      'asset': 'activityObjectivesPrimaryGoalCircular',
      'title': 'PRIMARY GOAL',
      'description': 'Build Strength & Endurance',
    },
    {
      'asset': 'activityObjectivesTrainingFreqCircular',
      'title': 'TRAINING FREQUENCY',
      'description': '4 days/week',
    },
    {
      'asset': 'activityObjectivesWorkoutDurationCircular',
      'title': 'WORKOUT DURATION',
      'description': '45–60 mins',
    },
    {
      'asset': 'activityObjectivesTrainingFocusCircular',
      'title': 'TRAINING FOCUS',
      'description': 'Full-Body + Core Stability',
    },
    {
      'asset': 'activityObjectivesPreferredActivitiesCircular',
      'title': 'PREFERRED ACTIVITIES',
      'description': 'Weights, Running, Yoga',
    },
    {
      'asset': 'activityObjectivesIntensityLevelCircular',
      'title': 'INTENSITY LEVEL',
      'description': 'Moderate to High',
    },
    {
      'asset': 'activityObjectivesResistanceTrainingCircular',
      'title': 'DAILY STEP GOAL',
      'description': '7,000 steps/day',
    },
    {
      'asset': 'commonEnergyCircular',
      'title': 'ENERGY SYSTEM',
      'description': 'Glycolytic & Aerobic Focus',
    },
  ];

  static const List<String> _activityObjectiveStrategies = [
    'Build strength and endurance through structured training',
    'Balance intensity with proper recovery to prevent bumout',
    'Improve performance and movement quality over time',
  ];

  static const List<String> _primaryFocusAreaList = [
    "Upper Body Strength",
    "Core Stability",
    "Cardiovascular Endurance",
  ];

  static const List<Map<String, dynamic>> _energySystemFocusList = [
    {'title': "Aerobic", 'value': 25.0},
    {'title': "Glycolytic (Lactic Acid)", 'value': 25.0},
    {'title': "Phosphagen (ATP-PC)", 'value': 50.0},
  ];

  static const List<Map<String, String>> _preferredActivitiesList = [
    {'asset': 'resistanceTrainingCircular', 'title': 'Weights'},
    {'asset': 'runningCircular', 'title': 'Running'},
    {'asset': 'yogaCircular', 'title': 'Yoga'},
  ];

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appbarWidget(),
              16.height,
              introWidget(),
              16.height,
              activityObjectivesWidget1(),
              16.height,
              activityObjectivesWidget2(),
              16.height,
              recommendedTrainingPlanWidget(),
              16.height,
              preferredActivitiesWidget(),
              16.height,
              LoadingButton(onPressed: controller.gotToNextPage, label: 'Next'),
            ],
          ),
        ),
      ),
    );
  }

  Column activityObjectivesWidget2() {
    return Column(
      children: [
        Text(
          _yourActivityObjectives,
          style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        16.height,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: .9,
          children: _activityObjectivesData
              .map(
                (objective) => ObjectiveCardWidget(
                  assetPath: _getAssetPath(objective['asset']!),
                  title: objective['title']!,
                  description: objective['description']!,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Container activityObjectivesWidget1() {
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
            _yourActivityObjectives,
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
                ..._activityObjectiveStrategies
                    .asMap()
                    .entries
                    .expand(
                      (entry) => [
                        RecoveryStrategyItemWidget(title: entry.value),
                        if (entry.key < _activityObjectiveStrategies.length - 1)
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

  IntroWidget introWidget() {
    return IntroWidget(body: _introBody);
  }

  FitnessReportAppbarWidget appbarWidget() {
    return FitnessReportAppbarWidget(
      controller: controller,
      title: _activityStrategyTitle,
    );
  }

  Widget recommendedTrainingPlanWidget() {
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
            _recommendedTrainingPlan,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height,
          Text(_recommendedTrainingPlanDesc, style: Get.textTheme.bodyMedium),
          8.height,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.7,
            children: _recommendedTrainingPlanList
                .map(
                  (objective) => ObjectiveCardWidget(
                    title: objective['title']!,
                    titleColor: Get.theme.primaryColor,
                    description: objective['description']!,
                    bgColor: Get.isDarkMode
                        ? AppColors.darkBgColorSecondary
                        : AppColors.lightBgColorSecondary,
                  ),
                )
                .toList(),
          ),
          16.height,
          // Training days
          Text(
            _trainingDays,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height,
          Wrap(
            children: _trainingDaysList
                .map(
                  (trainingDay) => Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(right: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.iconBgColorLight,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Get.theme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      trainingDay,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String _getAssetPath(String assetName) {
    switch (assetName) {
      case 'activityObjectivesPrimaryGoalCircular':
        return Assets.activityObjectivesPrimaryGoalCircular;
      case 'activityObjectivesTrainingFreqCircular':
        return Assets.activityObjectivesTrainingFreqCircular;
      case 'activityObjectivesWorkoutDurationCircular':
        return Assets.activityObjectivesWorkoutDurationCircular;
      case 'activityObjectivesTrainingFocusCircular':
        return Assets.activityObjectivesTrainingFocusCircular;
      case 'activityObjectivesPreferredActivitiesCircular':
        return Assets.activityObjectivesPreferredActivitiesCircular;
      case 'activityObjectivesIntensityLevelCircular':
        return Assets.activityObjectivesIntensityLevelCircular;
      case 'activityObjectivesResistanceTrainingCircular':
        return Assets.activityObjectivesResistanceTrainingCircular;
      case 'commonEnergyCircular':
        return Assets.commonEnergyCircular;
      default:
        return Assets.commonEnergyCircular;
    }
  }

  String _getPreferredActivityAssetPath(String assetName) {
    switch (assetName) {
      case 'resistanceTrainingCircular':
        return Assets.activityObjectivesResistanceTrainingCircular;
      case 'runningCircular':
        return Assets.activityObjectivesRunningCircular;
      case 'yogaCircular':
        return Assets.activityObjectivesYogaCircular;
      default:
        return Assets.activityObjectivesResistanceTrainingCircular;
    }
  }

  Widget preferredActivitiesWidget() {
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
            _preferredActivities,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height,
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _preferredActivitiesList.length,
            itemBuilder: (context, index) {
              final activity = _preferredActivitiesList[index];
              final isLast = index == _preferredActivitiesList.length - 1;

              return isLast
                  ? SizedBox(
                      height: 200,
                      child: ObjectiveCardWidget(
                        assetPath: _getPreferredActivityAssetPath(
                          activity['asset']!,
                        ),
                        title: activity['title']!,
                        description: '',
                        bgColor: Get.isDarkMode
                            ? AppColors.darkBgColorSecondary
                            : AppColors.lightBgColorSecondary,
                      ),
                    )
                  : ObjectiveCardWidget(
                      assetPath: _getPreferredActivityAssetPath(
                        activity['asset']!,
                      ),
                      title: activity['title']!,
                      description: '',
                      bgColor: Get.isDarkMode
                          ? AppColors.darkBgColorSecondary
                          : AppColors.lightBgColorSecondary,
                    );
            },
          ),
        ],
      ),
    );
  }
}
