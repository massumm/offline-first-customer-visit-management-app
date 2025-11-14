import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/fitness_report/widgets/report_menu_item_widget.dart';
import '../services/fitness_report_service.dart';
import '../views/introduction_page_view.dart';
import '../views/profile_overview_page_view.dart';
import '../views/recovery_strategy_page_view.dart';
import '../views/nutrition_strategy_page_view.dart';
import '../views/activity_strategy_page_view.dart';
import '../views/daily_goals_page_view.dart';
import '../views/mindset_motivation_page_view.dart';
import '../views/congratulations_page_view.dart';
import '../models/fitness_plan_model.dart';

class FitnessReportController extends BaseController {
  // --- Computed Getters for Current Page Data ---
  RecoveryStrategyModel? get currentRecoveryStrategy {
    if (recoveryStrategies.isNotEmpty && currentPageIndex.value == 2) {
      return recoveryStrategies.first;
    }
    return null;
  }

  NutritionStrategyModel? get currentNutritionStrategy {
    if (nutritionStrategies.isNotEmpty && currentPageIndex.value == 3) {
      return nutritionStrategies.first;
    }
    return null;
  }

  ActivityStrategyModel? get currentActivityStrategy {
    if (activityStrategies.isNotEmpty && currentPageIndex.value == 4) {
      return activityStrategies.first;
    }
    return null;
  }

  FitnessPlanModel? get currentFitnessPlan => fitnessPlan.value;
  // --- Data Models ---
  Rxn<FitnessPlanModel> fitnessPlan = Rxn<FitnessPlanModel>();
  RxList<RecoveryStrategyModel> recoveryStrategies =
      <RecoveryStrategyModel>[].obs;
  RxList<NutritionStrategyModel> nutritionStrategies =
      <NutritionStrategyModel>[].obs;
  RxList<ActivityStrategyModel> activityStrategies =
      <ActivityStrategyModel>[].obs;

  Future<void> loadFitnessReportData() async {
    final planData = await _reportService.fetchFitnessPlan();
    if (planData is List && planData.isNotEmpty) {
      fitnessPlan.value = FitnessPlanModel.fromJson(planData[0]);
      recoveryStrategies.value = fitnessPlan.value?.recoveryStrategies ?? [];
      nutritionStrategies.value = fitnessPlan.value?.nutritionStrategies ?? [];
      activityStrategies.value = fitnessPlan.value?.activityStrategies ?? [];
    }
  }

  // -------------------Services ------------------
  final FitnessReportService _reportService = Get.find<FitnessReportService>();
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    _reportService.attach(this);
    // Load backend data on controller init
    loadFitnessReportData();
  }

  @override
  void onClose() {
    pageController.dispose();
    _reportService.detach();
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
    // IntegrationSummaryPageView(),
    CongratulationsMessagePageView(),
  ];

  final currentPageIndex = 0.obs;
  final menuCloseDelay = const Duration(milliseconds: 200);
  bool _isNavigating = false;

  static const List<String> menuTitles = [
    'Introduction (by Icon)',
    'Your Profile Overview',
    'Recovery Strategy',
    'Nutrition Strategy',
    'Activity Strategy',
    'Daily Goals',
    'Mindset & Motivation',
    // 'Integration Summary',
    'Icon Closing Message',
  ];

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

  void goToCongratulationsPage() {
    final congratulationsPageIndex = pages.length - 1;
    pageController.animateToPage(
      congratulationsPageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    onPageChange(congratulationsPageIndex);
  }

  void showOptionsBottomSheet() {
    final double reportTitleFontSize = 16;
    final double menuItemTitleFontSize = 14;
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
                    fontSize: reportTitleFontSize,
                  ),
                ),
                ActionPill(onTap: Get.back, icon: Icons.close),
              ],
            ),
            16.height,
            Column(
              children: [
                ...menuTitles.asMap().entries.expand(
                  (entry) => [
                    ReportMenuItemWidget(
                      title: entry.value,
                      titleFontSize: menuItemTitleFontSize,
                      onTap: () {
                        Get.back();
                        Future.delayed(menuCloseDelay, () {
                          onPageChange(entry.key);
                        });
                      },
                    ),
                    if (entry.key < menuTitles.length - 1) 8.height,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showEnergySystemInfoDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Get.theme.cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ActionPill(onTap: Get.back, icon: Icons.close)],
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEnergySystemInfo(
                      'Aerobic',
                      'Low/moderate intensity activities for long durations. Examples include running, swimming or cycling at long distances.',
                    ),
                    12.height,
                    _buildEnergySystemInfo(
                      'Glycolytic',
                      'Moderate/high intensity activities for short durations, such as one or two minutes. Examples include sprinting, weightlifting and team sports.',
                    ),
                    12.height,
                    _buildEnergySystemInfo(
                      'Phosphagen',
                      'Extremely high intensity activities lasting only 5-15 seconds. Examples include powerlifting and maximum-effort sprinting.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnergySystemInfo(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Get.theme.colorScheme.primary,
          ),
        ),
        4.height,
        Text(
          description,
          style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
