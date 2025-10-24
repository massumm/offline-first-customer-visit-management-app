import 'package:flutter/material.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/profile_stats_widget.dart';

class ProfileOverviewPageView extends BaseView<FitnessReportController> {
  ProfileOverviewPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Your Profile Overview',
            ),
            16.height,
            IntroWidget(
              body:
                  'Based on everything you\'ve shared, here\'s your current fitness snapshot. This will be the foundation for how your Icon builds your training,  nutrition, and recovery plan.',
            ),
            16.height,
            ProfileStatsWidget(
              title: 'Your Current Stats',
              stats: [
                StatItem(label: 'Name', value: 'Alex Johnson'),
                StatItem(label: 'Gender', value: 'Male'),
                StatItem(label: 'Current Weight', value: '180 lbs'),
                StatItem(label: 'Body Fat %', value: '18%'),
                StatItem(
                  label: 'Fitness Goal',
                  value: 'Build Strength & Lose Fat',
                ),
                StatItem(
                  label: 'Training Schedule',
                  value: '4 days/week — Morning',
                ),
                StatItem(label: 'Age', value: '28'),
                StatItem(label: 'Height', value: '5\'10" ft'),
                StatItem(label: 'Target Weight', value: '170 lbs'),
                StatItem(label: 'Activity Level', value: 'Moderately Active'),
                StatItem(label: 'Experience Level', value: 'Intermediate'),
              ],
            ),
            16.height,
            LoadingButton(onPressed: controller.gotToNextPage, label: 'Next'),
          ],
        ),
      ),
    );
  }
}
