import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/fitness_report/widgets/intro_widget.dart';
import 'package:icon/generated/assets.dart';

class IntroductionPageView extends BaseView<FitnessReportController> {
  IntroductionPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Get.theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FitnessReportAppbarWidget(
              controller: controller,
              title: 'Introduction (by Icon)',
            ),
            16.height,
            IntroWidget(
              body:
                  'This comprehensive report is designed to give you insights into your fitness journey and help you achieve your goals.',
            ),

            Spacer(),
            // Add more introduction content here
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svgUserCircularIcon,
                        height: 40,
                        width: 40,
                      ),
                      8.width,
                      Text(
                        'User’s Current State',
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Text(
                    'You’re starting from a strong foundation motivated, determined, and ready to make real progress. The details you shared have given me a clear picture of where you are right now, and what matters most to you.',
                    style: Get.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            16.height,
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE9522B), Color(0xFF007BF7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          Assets.imagesFitnessReportFace,
                          height: 40,
                          width: 40,
                        ),
                        8.width,
                        Text(
                          'How Icon Will Help',
                          style: Get.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    Text(
                      'You’re starting from a strong foundation motivated, determined, and ready to make real progress. The details you shared have given me a clear picture of where you are right now, and what matters most to you.',
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
