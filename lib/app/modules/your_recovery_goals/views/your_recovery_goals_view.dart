import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:icon/app/core/widgets/goal_stepper_footer.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/your_recovery_goals_controller.dart';
import 'package:icon/app/modules/your_nutrition_goals/views/your_nutrition_goals_view.dart';

class YourRecoveryGoalsView extends GetView<YourRecoveryGoalsController> {
  const YourRecoveryGoalsView({super.key});
  @override
  Widget build(BuildContext context) {
    const kBackground = Color(0xFF0F0F0F);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          SuperImage(
            Assets.imagesYourRecoveryGoals,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 36),
                child: Image.asset(
                  'assets/images/your_recovery_phone_background.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.mediaQuery.padding.top + 16),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                        ),
                        child: SvgPicture.asset('assets/svg/arrow-left.svg'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your Recovery Goals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  'We have created a custom recovery goal list for you, one that will repair your body over time. This can be accomplished through mobility sessions, hydration, and plenty of sleep.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x66072C4A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svg/tick.svg'),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect your favorite wearable for continuous analytics and insights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GoalStepperFooter(
                stepIndex: 2,
                onPressed: () {
                  Get.to(
                        () => const YourNutritionGoalsView(),
                    transition: Transition.leftToRight,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}