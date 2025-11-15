import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/profile_stats_widget.dart';

class ProfileOverviewPageView extends BaseView<FitnessReportController> {
  const ProfileOverviewPageView({super.key});

  @override
  Widget body(BuildContext context) {
    final plan = controller.currentFitnessPlan;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Your Profile Overview',
            ),
            16.height,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntroWidget(
                      body:
                          plan?.introductorySummary ??
                          'Based on everything you\'ve shared, here\'s your current fitness snapshot. This will be the foundation for how your Icon builds your training,  nutrition, and recovery plan.',
                    ),
                    16.height,
                    ProfileStatsWidget(
                      title: 'Your Current Stats',
                      stats: [
                        StatItem(
                          label: 'Name',
                          value: plan?.trainee.toString() ?? '-',
                        ),
                        StatItem(
                          label: 'Trainer',
                          value: plan?.trainer.toString() ?? '-',
                        ),
                        StatItem(
                          label: 'Current Fitness State',
                          value: plan?.currentFitnessStateAnalysis ?? '-',
                        ),
                        StatItem(
                          label: 'Introductory Summary',
                          value: plan?.introductorySummary ?? '-',
                        ),
                        StatItem(
                          label: 'Closing Remarks',
                          value: plan?.closingRemarks ?? '-',
                        ),
                        StatItem(
                          label: 'Recommended Mindset Principle',
                          value: plan?.recommendedMindsetPrinciple ?? '-',
                        ),
                        StatItem(
                          label: 'Mindset Principle Justification',
                          value:
                              plan?.recommendedMindsetPrincipleJustification ??
                              '-',
                        ),
                        StatItem(
                          label: 'Created At',
                          value: plan?.createdAt ?? '-',
                        ),
                        StatItem(
                          label: 'Updated At',
                          value: plan?.updatedAt ?? '-',
                        ),
                      ],
                    ),
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
}
