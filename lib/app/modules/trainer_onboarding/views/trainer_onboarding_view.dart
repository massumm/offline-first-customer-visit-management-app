import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import '../../../../generated/assets.dart';
import '../controllers/trainer_onboarding_controller.dart';
import 'screens/trainer_onboarding_full_name.dart';

class TrainerOnboardingView extends GetView<TrainerOnboardingController> {
  const TrainerOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionButton(onTap: () => Navigator.maybePop(context)),
          Expanded(
            child: Stack(
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.7,
                    child: SuperImage(Assets.imagesGridlineImage),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: SuperImage(Assets.imagesBodyScanner),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Welcome to ",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.pageBackground,
                            ),
                          ),
                          Text(
                            "Icon",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Onboarding",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      10.height,
                      const Center(
                        child: Text(
                          'You’re about to create your AI clone. The more detail you give, the more accurate your digital clone will be. Be honest with your answers for the best results. Take your time, your progress will be autosaved and you can pick up from where you left off anytime. In total, this process should take 15-30 minutes.',
                          style: TextStyle(color: AppColors.pageBackground),
                        ),
                      ),
                      10.height,
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => Step1Screen());
                        },
                        child: const Text('Start now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
