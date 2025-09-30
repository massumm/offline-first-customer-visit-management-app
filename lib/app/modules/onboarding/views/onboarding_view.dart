import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/widgets/super_image.dart';

import '../../../core/values/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: controller.skip,
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardingData.length,
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                itemBuilder: (context, index) {
                  final data = controller.onboardingData[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SuperImage(data['image'], height: 250, width: 250),
                      const SizedBox(height: 20),
                      Text(
                        data["title"]!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          data["desc"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: controller.currentPage.value == index ? 18 : 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? Colors.red
                          : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: controller.nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  controller.onboardingData[controller
                      .currentPage
                      .value]["button"]!,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Have an account? ',
                style: TextStyle(color: AppColors.subTextColor),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () {
                        controller.goToLogin();
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 1),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.w700,

                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
