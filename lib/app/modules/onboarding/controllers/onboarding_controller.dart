import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/onboarding/views/onboarding_intro.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/app/modules/onboarding/models/onboarding_item.dart';
import 'package:icon/app/modules/onboarding/widgets/set_your_goals_animated.dart';
import 'package:icon/app/modules/onboarding/widgets/track_your_progress_animated.dart';
import 'package:icon/app/modules/onboarding/widgets/expert_crafted_icons_animated.dart';

class OnboardingController extends BaseController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  late final List<OnboardingItem> onboardingData = [
    OnboardingItem(
      imageWidget: setYourGoals(),
      title: "Set Your Goals",
      description:
          "Define your fitness journey with clear, achievable targets designed just for you.",
      buttonLabel: "Next",
    ),
    OnboardingItem(
      imageWidget: trackYourProgress(),
      title: "Track Your Progress",
      description:
          "Monitor workouts, calories, and performance with real-time insights that keep you moving forward.",
      buttonLabel: "Next",
    ),
    OnboardingItem(
      imageWidget: expertCraftedIcons(),
      title: "Expert-Crafted Icons",
      description:
          "Choose your icon – crafted by qualified fitness professionals and athletes – to help you.",
      buttonLabel: "Get Started",
    ),
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
    pageController.animateToPage(
      onboardingData.length - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToFitnessReport() {
    Get.toNamed(Routes.FITNESS_REPORT);
  }

  Widget setYourGoals() {
    return const SetYourGoalsAnimated();
  }

  Widget trackYourProgress() {
    return const TrackYourProgressAnimated();
  }

  Widget expertCraftedIcons() {
    return const ExpertCraftedIconsAnimated();
  }
}

