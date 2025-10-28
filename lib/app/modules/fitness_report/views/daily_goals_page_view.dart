import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/generated/assets.dart';

class DailyGoalsPageView extends BaseView<FitnessReportController> {
  DailyGoalsPageView({super.key});

  final List<Map<String, dynamic>> dailyGoalsData = [
    {
      'title': 'Step Goal',
      'frequency': 'Everyday',
      'value': '7,000 steps',
      'description': 'Stay active throughout the day — light movement adds up.',
      'icon': Assets.dailyGoalsStepGoal,
    },
    {
      'title': 'Workout Duration',
      'frequency': ['Mon', 'Thu', 'Sat'],
      'value': '45-60 mins',
      'description':
          'Focused sessions designed to balance intensity and recovery.',
      'icon': Assets.dailyGoalsWorkoutDuration,
    },
    {
      'title': 'Repair Goal',
      'frequency': 'Everyday',
      'value': '10 min mobility',
      'description':
          'Daily mobility or stretching to improve recovery and posture.',
      'icon': Assets.dailyGoalsRepairGoal,
    },
    {
      'title': 'Calorie Intake',
      'frequency': 'Everyday',
      'value': '2,200 kcal',
      'description': 'Optimized to support your strength and toning goals.',
      'icon': Assets.dailyGoalsCalorieIntakeGoal,
    },
    {
      'title': 'Water Goal',
      'frequency': 'Everyday',
      'value': '2.5 L',
      'description': 'Stay hydrated to boost focus and recovery.',
      'icon': Assets.dailyGoalsWaterGoal,
    },
    {
      'title': 'Sleep Goal',
      'frequency': 'Everyday',
      'value': '7.5 hrs',
      'description': 'Quality sleep is the foundation for progress and energy.',
      'icon': Assets.dailyGoalsSleepGoal,
    },
    {
      'title': 'Mood Reflection',
      'frequency': 'Everyday',
      'value': 'Daily check-in',
      'description': 'Track your mindset and mood to understand your trends.',
      'icon': Assets.dailyGoalsMoodReflectionGoal,
    },
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
              FitnessReportAppbarWidget(
                controller: controller,
                title: 'Daily Goals',
              ),
              16.height,
              Text(
                'Your Core Daily Goals',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
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
                        SvgPicture.asset(goal['icon'], width: 32, height: 32),
                        16.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal['title'],
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.height,
                              Text(
                                goal['value'],
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: Get.theme.colorScheme.onSurface,
                                ),
                              ),
                              8.height,
                              Text(
                                goal['frequency'] is List
                                    ? (goal['frequency'] as List).join(', ')
                                    : goal['frequency'],
                                style: Get.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              16.height,
              LoadingButton(onPressed: controller.gotToNextPage, label: 'Next'),
            ],
          ),
        ),
      ),
    );
  }
}
