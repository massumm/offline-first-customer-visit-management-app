import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class MindsetMotivationPageView extends BaseView<FitnessReportController> {
  MindsetMotivationPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Mindset and Motivation',
            ),

            // Add mindset and motivation content here
            const Spacer(),
            InfoCardWidget(
              icon: Assets.mindsetAndMotivationMindsetFocus,
              title: 'Your Mindset Focus',
              description:
                  'You mentioned finding consistency tough, especially when motivation drops. So we\'ll focus on building identity- based habits-simple actions that reinforce who you want to become, not just what you want to achieve.',
              iconType: IconType.svg,
            ),
            16.height,
            Text(
              'Recommended Mindset Principle',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.height,
            InfoCardWidget(
              icon: Assets.imagesFitnessReportFace,
              title: 'Progress > Perfection',
              description:
                  'Your journey isn\'t about being flawless - it\'s about showing up, adjusting, and growing through the process. Every small action counts more than you realize.',
              isGradient: true,
              iconType: IconType.asset,
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
