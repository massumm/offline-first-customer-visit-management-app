import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/models/daily_goal.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/frequency_badge.dart';
import 'package:icon/app/core/widgets/asset_icon_container.dart';
import 'package:icon/generated/assets.dart';

class DailyGoalsPageView extends BaseView<FitnessReportController> {
  DailyGoalsPageView({super.key});

  final freqFontSize = 12;
  final mainTitleFontSize = 18;
  final cardWidgetTitleFontSize = 14;
  final cardWidgetSubtitleFontSize = 18;
  final cardWidgetDescriptionFontSize = 14;
  final assetWidth = 28;
  final assetHeight = 28;

  final List<DailyGoal> dailyGoalsData = [
    DailyGoal(
      title: 'Step Goal',
      frequency: ['Everyday'],
      subtitle: '7,000 steps',
      description: 'Stay active throughout the day — light movement adds up.',
      icon: Assets.dailyGoalsStepGoal,
    ),
    DailyGoal(
      title: 'Workout Duration',
      frequency: ['Mon', 'Thu', 'Sat'],
      subtitle: '45-60 mins',
      description:
          'Focused sessions designed to balance intensity and recovery.',
      icon: Assets.dailyGoalsWorkoutDuration,
    ),
    DailyGoal(
      title: 'Repair Goal',
      frequency: ['Everyday'],
      subtitle: '10 min mobility',
      description:
          'Daily mobility or stretching to improve recovery and posture.',
      icon: Assets.dailyGoalsRepairGoal,
    ),
    DailyGoal(
      title: 'Calorie Intake',
      frequency: ['Everyday'],
      subtitle: '2,200 kcal',
      description: 'Optimized to support your strength and toning goals.',
      icon: Assets.dailyGoalsCalorieIntakeGoal,
    ),
    DailyGoal(
      title: 'Water Goal',
      frequency: ['Everyday'],
      subtitle: '2.5 L',
      description: 'Stay hydrated to boost focus and recovery.',
      icon: Assets.dailyGoalsWaterGoal,
    ),
    DailyGoal(
      title: 'Sleep Goal',
      frequency: ['Everyday'],
      subtitle: '7.5 hrs',
      description: 'Quality sleep is the foundation for progress and energy.',
      icon: Assets.dailyGoalsSleepGoal,
    ),
    DailyGoal(
      title: 'Mood Reflection',
      frequency: ['Everyday'],
      subtitle: 'Daily check-in',
      description: 'Track your mindset and mood to understand your trends.',
      icon: Assets.dailyGoalsMoodReflectionGoal,
    ),
  ];

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Daily Goals',
            ),
            16.height,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Core Daily Goals',
                      style: Get.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: mainTitleFontSize.toDouble(),
                      ),
                    ),
                    16.height,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dailyGoalsData.length,
                      itemBuilder: (context, index) {
                        final goal = dailyGoalsData[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AssetIconContainer(
                                iconPath: goal.icon,
                                width: assetWidth.toDouble(),
                                height: assetHeight.toDouble(),
                              ),
                              16.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GoalTitle(
                                          goal: goal,
                                          cardWidgetTitleFontSize:
                                              cardWidgetTitleFontSize,
                                        ),
                                        const Spacer(),
                                        FrequencyWrap(
                                          goal: goal,
                                          freqFontSize: freqFontSize,
                                        ),
                                      ],
                                    ),
                                    4.height,
                                    GoalSubtitle(
                                      goal: goal,
                                      cardWidgetSubtitleFontSize:
                                          cardWidgetSubtitleFontSize,
                                    ),
                                    8.height,
                                    GoalDescription(
                                      goal: goal,
                                      cardWidgetDescriptionFontSize:
                                          cardWidgetDescriptionFontSize,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            16.height,

            LoadingButton(
              onPressed: controller.gotToNextPage,
              label: 'View your report',
            ),
          ],
        ),
      ),
    );
  }
}

class GoalDescription extends StatelessWidget {
  const GoalDescription({
    super.key,
    required this.goal,
    required this.cardWidgetDescriptionFontSize,
  });

  final DailyGoal goal;
  final int cardWidgetDescriptionFontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      goal.description,
      style: Get.textTheme.bodySmall?.copyWith(
        fontSize: cardWidgetDescriptionFontSize.toDouble(),
      ),
    );
  }
}

class GoalSubtitle extends StatelessWidget {
  const GoalSubtitle({
    super.key,
    required this.goal,
    required this.cardWidgetSubtitleFontSize,
  });

  final DailyGoal goal;
  final int cardWidgetSubtitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      goal.subtitle,
      style: Get.textTheme.bodySmall?.copyWith(
        fontSize: cardWidgetSubtitleFontSize.toDouble(),
        color: Get.theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class GoalTitle extends StatelessWidget {
  const GoalTitle({
    super.key,
    required this.goal,
    required this.cardWidgetTitleFontSize,
  });

  final DailyGoal goal;
  final int cardWidgetTitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      goal.title,
      style: Get.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: cardWidgetTitleFontSize.toDouble(),
      ),
    );
  }
}

class FrequencyWrap extends StatelessWidget {
  const FrequencyWrap({
    super.key,
    required this.goal,
    required this.freqFontSize,
  });

  final DailyGoal goal;
  final int freqFontSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: goal.frequency
          .map(
            (freq) =>
                FrequencyBadge(label: freq, fontSize: freqFontSize.toDouble()),
          )
          .toList(),
    );
  }
}
