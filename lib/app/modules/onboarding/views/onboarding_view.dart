import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/super_image.dart';

import '../../../core/values/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends BaseView<OnboardingController> {
   OnboardingView({super.key});

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final isLastPage =
              controller.currentPage.value ==
                  controller.onboardingData.length - 1;
          if (isLastPage) {
            return 48.height;
          }
          return Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: controller.skip,
              child: Text(
                "Skip",
                style: TextStyle(color: AppColors.colorPrimary),
              ),
            ),
          );
        }),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.onboardingData.length,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              itemBuilder: (context, index) {
                final data = controller.onboardingData[index];
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["title"]!,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    20.height,
                    Text(data["desc"]!, style: Get.textTheme.bodyMedium),
                    10.height,
                    const Spacer(),
                    Center(
                      child: SuperImage(
                        data['image'],
                        height: 340,
                        width: 250,
                        radius: 12,
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            ),
          ),
        ),
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.onboardingData.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: controller.currentPage.value == index ? 18 : 10,
                decoration: BoxDecoration(
                  color: controller.currentPage.value == index
                      ? AppColors.colorPrimary
                      : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
              () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: controller.nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
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
                        bottom: BorderSide(color: Colors.black, width: 1.5),
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
    );
  }
}
