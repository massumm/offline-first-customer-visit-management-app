// lib/app/modules/fitness_report/controllers/fitness_report_controller.dart

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:icon/app/routes/app_pages.dart';

class FitnessReportController extends GetxController {
  final pageController = PageController();
  final currentPageIndex = 0.obs;
  final int totalPages = 4;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Called when the page in the PageView changes.
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  /// Navigates to the next page or handles completion on the last page.
  void goToNextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.toNamed(Routes.YOUR_DAILY_GOALS);
    }
  }
}
