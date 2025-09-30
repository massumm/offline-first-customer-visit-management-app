import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/modules/onboarding/views/onboarding_intro.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../../generated/assets.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "image": Assets.imagesOnboarding1,
      "title": "Set Your Goals",
      "desc":
      "Define your fitness journey with clear, achievable targets designed just for you.",
      "button": "Next"
    },
    {
      "image": Assets.imagesOnboarding2,
      "title": "Track Your Progress",
      "desc":
      "Monitor workouts, calories, and performance with real-time insights that keep you moving forward.",
      "button": "Next"
    },
    {
      "image": Assets.imagesOnboarding3,
      "title": "Expert-Crafted Icons",
      "desc":
      "Choose your icon – crafted by qualified fitness professionals and athletes – to help you.",
      "button": "Get Started"
    },
  ];

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Final action
      Get.to(() => const OnboardingIntro());
    }
  }

  void skip() {
    pageController.jumpToPage(onboardingData.length - 1);
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}