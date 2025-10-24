import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import '../views/introduction_page_view.dart';
import '../views/profile_overview_page_view.dart';
import '../views/recovery_strategy_page_view.dart';
import '../views/nutrition_strategy_page_view.dart';
import '../views/activity_strategy_page_view.dart';
import '../views/daily_goals_page_view.dart';
import '../views/mindset_motivation_page_view.dart';
import '../views/integration_summary_page_view.dart';
import '../views/icon_closing_message_page_view.dart';

class FitnessReportController extends BaseController {
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  List<Widget> get pages => [
    IntroductionPageView(),
    ProfileOverviewPageView(),
    RecoveryStrategyPageView(),
    NutritionStrategyPageView(),
    ActivityStrategyPageView(),
    DailyGoalsPageView(),
    MindsetMotivationPageView(),
    IntegrationSummaryPageView(),
    IconClosingMessagePageView(),
  ];

  final currentPageIndex = 0.obs;

  void onPageChange(int index) {
    currentPageIndex.value = index;
  }

  void gotToNextPage() {
    if (currentPageIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value++;
    }
  }

  void gotToPreviousPage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value--;
    }
  }
}
