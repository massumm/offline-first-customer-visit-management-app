import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/fitness_report/services/FitnessReportService.dart';
import 'package:icon/app/modules/fitness_report/widgets/report_menu_item_widget.dart';
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
  // -------------------Services ------------------
  final FitnessReportService _reportService = Get.find<FitnessReportService>();
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);

    // ----------------- init services ----------------
    _reportService.attach(this);
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
  final menuCloseDelay = const Duration(milliseconds: 200);
  bool _isNavigating = false;

  void onPageChange(int pageIndex) {
    if (_isNavigating || pageIndex == currentPageIndex.value) {
      return;
    }
    debugPrint("onPageChange: Current Page Index: ${currentPageIndex.value}");
    debugPrint("onPageChange: New Page Index: $pageIndex");

    _isNavigating = true;
    final distance = pageIndex - currentPageIndex.value;

    if (distance == 1) {
      gotToNextPage();
    } else if (distance == -1) {
      gotToPreviousPage();
    } else {
      pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentPageIndex.value = pageIndex;
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      _isNavigating = false;
    });
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

  void showOptionsBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'View Your Report',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ActionPill(onTap: Get.back, icon: Icons.close),
              ],
            ),
            16.height,
            Column(
              children: [
                ReportMenuItemWidget(
                  title: 'Introduction (by Icon)',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(0);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Your Profile Overview',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(1);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Recovery Strategy',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(2);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Nutrition Strategy',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(3);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Activity Strategy',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(4);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Daily Goals',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(5);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Mindset & Motivation',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(6);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Integration Summary',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(7);
                    });
                  },
                ),
                8.height,
                ReportMenuItemWidget(
                  title: 'Icon Closing Message',
                  onTap: () {
                    Get.back();
                    Future.delayed(menuCloseDelay, () {
                      onPageChange(8);
                    });
                  },
                ),
                8.height,
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
