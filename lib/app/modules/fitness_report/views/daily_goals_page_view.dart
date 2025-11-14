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

class DailyGoalsPageView extends BaseView<FitnessReportController> {
  DailyGoalsPageView({super.key});

  final freqFontSize = 12;
  final mainTitleFontSize = 18;
  final cardWidgetTitleFontSize = 14;
  final cardWidgetSubtitleFontSize = 18;
  final cardWidgetDescriptionFontSize = 14;
  final assetWidth = 28;
  final assetHeight = 28;

  // Use controller.currentFitnessPlan?.dailyGoals for dynamic data

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
                      itemCount:
                          controller.currentFitnessPlan?.dailyGoals.length ?? 0,
                      itemBuilder: (context, index) {
                        final goal =
                            controller.currentFitnessPlan!.dailyGoals[index];
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
              onPressed: controller.goToCongratulationsPage,
              label: 'Register',
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
