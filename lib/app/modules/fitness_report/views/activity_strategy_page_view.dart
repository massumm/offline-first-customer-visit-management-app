import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/models/activity_strategy_models.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objective_card_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/objectives_item_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/strategy_section_widget.dart';
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

  static final List<TrainingPlan> _recommendedTrainingPlanList = [
    TrainingPlan(title: 'Frequency', description: '4 days per week'),
    TrainingPlan(title: 'Session Duration', description: '45–60 mins'),
  ];

  static const List<String> _trainingDaysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Saturday',
  ];

  static final List<String> _primaryFocusAreaList = [
    "Upper Body Strength",
    "Core Stability",
    "Cardiovascular Health",
  ];

  // Activity Objectives Data
  static final List<ActivityObjective> _activityObjectivesData = [
    ActivityObjective(
      asset: Assets.activityObjectivesPrimaryGoalCircular,
      title: 'PRIMARY GOAL',
      description: 'Build Strength & Endurance',
    ),
    ActivityObjective(
      asset: Assets.activityObjectivesTrainingFreqCircular,
      title: 'TRAINING FREQUENCY',
      description: '4 days/week',
    ),
    ActivityObjective(
      asset: Assets.activityObjectivesWorkoutDurationCircular,
      title: 'WORKOUT DURATION',
      description: '45–60 mins',
    ),
    ActivityObjective(
      asset: Assets.activityObjectivesTrainingFocusCircular,
      title: 'TRAINING FOCUS',
      description: 'Full-Body + Core Stability',
    ),
    ActivityObjective(
      asset: Assets.activityObjectivesPreferredActivitiesCircular,
      title: 'PREFERRED ACTIVITIES',
      description: 'Weights, Running, Yoga',
    ),
    ActivityObjective(
      asset: Assets.activityObjectivesIntensityLevelCircular,
      title: 'INTENSITY LEVEL',
      description: 'Moderate to High',
    ),
    ActivityObjective(
      asset: Assets.activityObjectivesDailyStepGoal,
      title: 'DAILY STEP GOAL',
      description: '7,000 steps/day',
    ),
    ActivityObjective(
      asset: Assets.commonEnergyCircular,
      title: 'ENERGY SYSTEM',
      description: 'Glycolytic & Aerobic Focus',
    ),
  ];

  static const List<String> _activityObjectiveStrategies = [
    'Build strength and endurance through structured training',
    'Balance intensity with proper recovery to prevent bumout',
    'Improve performance and movement quality over time',
  ];

  static final List<EnergySystemFocus> _energySystemFocusList = [
    EnergySystemFocus(title: "Aerobic", value: 50.0),
    EnergySystemFocus(title: "Glycolytic (Lactic-Acid)", value: 25.0),
    EnergySystemFocus(title: "Phosphagen (ATP-PC)", value: 50.0),
  ];

  static final List<PreferredActivity> _preferredActivitiesList = [
    PreferredActivity(
      asset: Assets.activityObjectivesResistanceTrainingCircular,
      title: 'Resistance Training',
    ),
    PreferredActivity(
      asset: Assets.activityObjectivesRunningCircular,
      title: 'Running',
    ),
    PreferredActivity(
      asset: Assets.activityObjectivesYogaCircular,
      title: 'Yoga',
    ),
  ];

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            appbarWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    introWidget(),
                    16.height,
                    activityObjectivesWidget1(),
                    16.height,
                    activityObjectivesWidget2(),
                    16.height,
                    recommendedTrainingPlanWidget(),
                    16.height,
                    primaryFocusAreaWidget(),
                    16.height,
                    preferredActivitiesWidget(),
                    16.height,
                    energySystemFocusWidget(),
                    16.height,
                    iconInsightWidget(),
                    16.height,
                  ],
                ),
              ),
            ),
            LoadingButton(
              onPressed: controller.gotToNextPage,
              label: 'View Your Report',
            ),
          ],
        ),
      ),
    );
  }

  Column activityObjectivesWidget2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          childAspectRatio: 1.1,
          children: _activityObjectivesData
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
                ..._activityObjectiveStrategies.asMap().entries.expand(
                  (entry) => [
                    ObjectivesItemWidget(title: entry.value),
                    if (entry.key < _activityObjectiveStrategies.length - 1)
                      16.height,
                  ],
                ),
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
    return StrategySectionWidget(
      title: _recommendedTrainingPlan,
      description: _recommendedTrainingPlanDesc,
      cardItems: _recommendedTrainingPlanList,
      childAspectRatio: 1.5,
      cardBuilder: (objective) => ObjectiveCardWidget(
        title: objective.title,
        titleColor: Get.theme.primaryColor,
        description: objective.description,
        bgColor: Get.isDarkMode
            ? AppColors.darkBgColor
            : AppColors.lightBgColorSecondary,
      ),
      tagSectionTitle: _trainingDays,
      tagItems: _trainingDaysList,
    );
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
          Column(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _preferredActivitiesList.length - 1,
                itemBuilder: (context, index) {
                  final activity = _preferredActivitiesList[index];

                  return ObjectiveCardWidget(
                    assetPath: activity.asset,
                    title: activity.title,
                    titleFontSize: 12,
                    description: '',
                    bgColor: Get.isDarkMode
                        ? AppColors.darkBgColor
                        : AppColors.lightBgColorSecondary,
                    isCentered: true,
                    padding: 8,
                  );
                },
              ),
              8.height,
              SizedBox(
                width: double.infinity,
                height: Get.width / 3.5,
                child: ObjectiveCardWidget(
                  assetPath: _preferredActivitiesList.last.asset,
                  title: _preferredActivitiesList.last.title,
                  titleFontSize: 12,
                  description: '',
                  bgColor: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : AppColors.lightBgColorSecondary,
                  isCentered: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget primaryFocusAreaWidget() {
    return StrategySectionWidget(
      cardBuilder: (objective) => ObjectiveCardWidget(
        title: objective.title,
        description: objective.description,
        bgColor: Get.isDarkMode
            ? AppColors.darkBgColorSecondary
            : AppColors.lightBgColorSecondary,
      ),
      tagSectionTitle: _primaryFocusArea,
      tagItems: _primaryFocusAreaList,
    );
  }

  Widget iconInsightWidget() {
    return InfoCardWidget(
      icon: Assets.imagesFitnessReportFace,
      title: _iconInsightTitle,
      description: _iconInsightDesc,
      isGradient: true,
      iconType: IconType.asset,
    );
  }

  double _calculateCircleHorizontalPosition() {
    // For a ternary diagram:
    // Left corner (0,0) = 100% Glycolytic
    // Right corner (width,0) = 100% Phosphagen
    // Top corner (width/2, height) = 100% Aerobic

    final glycolytic = _energySystemFocusList[1].value; // Left
    final phosphagen = _energySystemFocusList[2].value; // Right
    final aerobic = _energySystemFocusList[0].value; // Top

    // X position: weighted blend of phosphagen (right) and aerobic contributes to centering
    final triangleWidth = 344.0; // Adjust to your actual triangle width

    // Barycentric to Cartesian conversion for X
    return triangleWidth * (phosphagen + aerobic * 0.5) / 100;
  }

  double _calculateCircleVerticalPosition() {
    final aerobic = _energySystemFocusList[0].value;
    final triangleHeight = 298.0; // Adjust to your actual triangle height

    // Y position: higher aerobic = lower Y value (closer to top)
    // Using equilateral triangle height formula
    return triangleHeight * (1 - (aerobic * Math.sqrt(3) / 2) / 100);
  }

  Widget energySystemFocusWidget() {
    const String energySystemFocusTitle = 'Energy System Focus';
    const double titleFontSize = 18;
    const String energySystemFocusDescription =
        'Your plan targets multiple energy systems for optimal performance.';
    const double descriptionFontSize = 16;
    const double valueFontSize = 22;
    const double title2FontSize = 14;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              energySystemFocusTitle,
              style: Get.textTheme.bodyLarge?.copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: controller.showEnergySystemInfoDialog,
              child: Text(
                'More Info',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: Get.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        16.height,
        Text(
          energySystemFocusDescription,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontSize: descriptionFontSize,
          ),
        ),
        16.height,

        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_energySystemFocusList[0].value}%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: valueFontSize,
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.height,
              Text(
                _energySystemFocusList[0].title,
                style: TextStyle(
                  fontSize: title2FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 400,
          height: 335,
          child: Container(
            padding: const EdgeInsets.all(0),

            child: Stack(
              alignment: Alignment.center,
              children: [
                if (Get.isDarkMode)
                  SvgPicture.asset(
                    Assets.activityObjectivesTriangleDark,
                    width: double.infinity,
                    height: double.infinity,
                  )
                else
                  SvgPicture.asset(
                    Assets.activityObjectivesTriangle,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                Positioned(
                  left:
                      _calculateCircleHorizontalPosition() -
                      24, // Center the circle
                  top: _calculateCircleVerticalPosition() - 23,
                  child: Get.isDarkMode
                      ? SvgPicture.asset(
                          Assets.activityObjectivesCircleInsideTriangleDark,
                        )
                      : SvgPicture.asset(
                          Assets.activityObjectivesCircleInsideTriangle,
                        ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                16.height,
                Text(
                  '${_energySystemFocusList[1].value}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.height,
                Text(
                  _energySystemFocusList[1].title.split(' ').join('\n'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: title2FontSize),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                16.height,
                Text(
                  '${_energySystemFocusList[2].value}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                10.height,
                Text(
                  _energySystemFocusList[2].title.split(' ').join('\n'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: title2FontSize),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
