import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:icon/app/core/widgets/goal_stepper_footer.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/your_nutrition_goals_controller.dart';
import 'package:icon/app/modules/your_daily_goals/views/your_daily_goals_view.dart';

class YourNutritionGoalsView extends GetView<YourNutritionGoalsController> {
  const YourNutritionGoalsView({super.key});
  @override
  Widget build(BuildContext context) {
    const kBackground = Color(0xFF0F0F0F);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          SuperImage(
            Assets.imagesYourNutritionGoals,
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
                  'assets/images/your_nutrition_phone_background.png',
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
                        'Your Nutrition Goals',
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
                  'Fuel your body right. Log your meals, track your macros, and get personalized insights to help you reach your nutrition targets.',
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
                  color: const Color(0x6600875A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svg/tick.svg'),
                    const SizedBox(height: 8),
                    const Text(
                      'Integrate with your favorite food tracking apps to make logging seamless and automatic.',
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
                stepIndex: 3,
                onPressed: () {
                  Get.to(
                        () => const YourDailyGoalsView(),
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
