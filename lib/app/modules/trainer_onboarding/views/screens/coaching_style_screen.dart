import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/identity_verification_full_name.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/tone_sliders_screen.dart';

class CoachingStyleScreen extends GetView<TrainerOnboardingController> {
  const CoachingStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainerOnboardingController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackPill(onTap: () => Navigator.maybePop(context)),
            30.height,
            const ProgressBar(currentStep: 2, stepText: "Coaching Style & Persona"),
            280.height,
            // Title
            Center(
              child: Text(
                "How would you describe your coaching style?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // fixed
                ),
              ),
            ),
            10.height,
            Expanded(
              child: ListView.builder(
                itemCount: controller.coachingStyles.length,
                itemBuilder: (context, index) {
                  final style = controller.coachingStyles[index];
                  return Obx(() {
                    final isSelected = controller.selectedIndex.value == index;
                    return GestureDetector(
                      onTap: () {
                        controller.selectedIndex.value = index;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.deepOrange : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                style["icon"] as IconData,
                                color: AppColors.pageBackground,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style["title"].toString(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.deepOrange : Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  04.height,
                                  Text(
                                    style["subtitle"].toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            20.height,
            ElevatedButton(
              onPressed: () {
                Get.to(() => ToneSlidersScreen());
              },
              child: const Text('Next'),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
