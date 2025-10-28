import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/fitness_report/controllers/fitness_report_controller.dart';
import 'package:icon/app/modules/fitness_report/widgets/fitness_report_appbar_widget.dart';
import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';
import 'package:icon/generated/assets.dart';

class CongratulationsMessagePageView extends BaseView<FitnessReportController> {
  CongratulationsMessagePageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FitnessReportAppbarWidget(controller: controller),
              // 16.height,
              SvgPicture.asset(Assets.congratulationsCongo),
              16.height,
              Text(
                'Congratulations, Mish!',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.height,
              Text(
                'You\'ve completed your Personalized Icon Report. You now have a complete roadmap for your fitness journey-covering activity, nutrition, recovery, mindset, and daily goals.',
                style: Get.textTheme.bodyMedium,
              ),
              16.height,
              InfoCardWidget(
                icon: Assets.imagesFitnessReportFace,
                title: 'Icon Insight',
                description:
                    'Your personalised dashboard and chat with Icon are ready. Register now to start putting your plan into action and track your journey daily. Remember, progress is built one step at a time and your Icon will be there every step of the way.',
                isGradient: true,
                iconType: IconType.asset,
              ),
              24.height,
              LoadingButton(
                onPressed: controller.gotToNextPage,
                label: 'Register',
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF156AC6),
                    Color(0xFF007BF7),
                    Color(0xFFFD6371),
                    Color(0xFFE9522B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
