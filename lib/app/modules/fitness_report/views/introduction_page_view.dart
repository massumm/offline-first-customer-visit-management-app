import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class IntroductionPageView extends BaseView<FitnessReportController> {
  const IntroductionPageView({super.key});

  @override
  Widget body(BuildContext context) {
    final plan = controller.currentFitnessPlan;
    return Scaffold(
      body: Container(
        color: Get.theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Introduction (by Icon)',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    IntroWidget(
                      body:
                          plan?.introductorySummary ??
                          'This comprehensive report is designed to give you insights into your fitness journey and help you achieve your goals.',
                    ),
                    // Removed Spacer()
                    InfoCardWidget(
                      icon: Assets.svgUserCircularIcon,
                      title: 'User\'s Current State',
                      description:
                          plan?.currentFitnessStateAnalysis ??
                          'You\'re starting from a strong foundation motivated, determined, and ready to make real progress. The details you shared have given me a clear picture of where you are right now, and what matters most to you.',
                      iconType: IconType.svg,
                    ),
                    16.height,
                    InfoCardWidget(
                      icon: Assets.imagesFitnessReportFace,
                      title: 'How Icon Will Help',
                      description:
                          plan?.closingRemarks ??
                          'You\'re starting from a strong foundation motivated, determined, and ready to make real progress. The details you shared have given me a clear picture of where you are right now, and what matters most to you.',
                      isGradient: true,
                      iconType: IconType.asset,
                    ),
                    8.height,
                  ],
                ),
              ),
            ),
            8.height,
            LoadingButton(
              onPressed: controller.gotToNextPage,
              label: 'View Your Report',
            ),
          ],
        ),
      ),
    );
  }
}
