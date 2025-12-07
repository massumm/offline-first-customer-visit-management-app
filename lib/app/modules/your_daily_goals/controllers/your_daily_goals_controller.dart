import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/firebase_crashlytics.dart';
import 'package:icon/app/modules/your_daily_goals/repository/daily_goal_repository.dart';

import '../../goal_tracking/models/daily_goal_model.dart';

class YourDailyGoalsController extends GetxController {
  final selectedTabIndex = 0.obs;
  final isLoading = true.obs;

  final RxList<String> tabs = ['All Goals'].obs;

  final DailyGoalRepository _repository = Get.find<DailyGoalRepository>(
    tag: (DailyGoalRepository).toString(),
  );

  final goalData = RxList<DailyGoalModel>();

  List<DailyGoalModel> get filteredGoals {
    // If 'All Goals' is selected, return the entire list.
    if (selectedTabIndex.value == 0) {
      return goalData;
    }

    if (selectedTabIndex.value >= tabs.length) {
      return [];
    }

    final selectedCategory = tabs[selectedTabIndex.value];

    return goalData
        .where(
          (goal) =>
              goal.section.toLowerCase() == selectedCategory.toLowerCase(),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchGoalData();
  }

  Future<void> fetchGoalData() async {
    try {
      isLoading.value = true;
      final response = await _repository.fetchDailyGoals();
      goalData.assignAll(response);

      final uniqueSections = response
          .map((goal) => goal.section)
          .toSet()
          .toList();
      tabs.assignAll(['All Goals', ...uniqueSections]);
    } catch (e, s) {
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      }
      e.logToCrashlytics(s);
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  Color getColorForGoal(DailyGoalModel goal) {
    final hexColor = goal.color;
    if (hexColor.startsWith('#') && hexColor.length >= 7) {
      try {
        return Color(
          int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000,
        );
      } catch (e) {
        return Colors.grey; // Fallback color
      }
    }
    return Colors.grey; // Default color
  }

  IconData getIconForGoal(DailyGoalModel goal) {
    const iconMap = {
      'directions_walk': Icons.directions_walk,
      'fitness_center': Icons.fitness_center,
      'local_fire_department': Icons.local_fire_department,
      'egg_outlined': Icons.egg_outlined,
      'water_drop': Icons.water_drop,
      'self_improvement': Icons.self_improvement,
    };
    return iconMap[goal.icon] ?? Icons.help_outline; // Default icon
  }
}
