import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:icon/app/core/widgets/goal_stepper_footer.dart';

import '../controllers/goal_tracking_controller.dart';
import 'package:icon/app/modules/your_activity_goals/views/your_activity_goals_view.dart';

class GoalTrackingView extends GetView<GoalTrackingController> {
  const GoalTrackingView({super.key});
  @override
  Widget build(BuildContext context) {
    const kBackground = Color(0xFF0F0F0F);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 36),
                child: Image.asset(
                  'assets/images/goal_tracking_phone_background.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          side: BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        child: SvgPicture.asset('assets/svg/arrow-left.svg'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Goal Tracking',
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
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  'No more app juggling. Everything is now in one place - convenient and effective.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Color(0x66AE2400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    SvgPicture.asset('assets/svg/tick.svg'),
                    Text(
                      'Not every day is the same. This is where our adaptive engine kicks in, modifying your daily goals based on your life',
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
                stepIndex: 0,
                onPressed: () {
                  Get.to(
                    () => YourActivityGoalsView(),
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
