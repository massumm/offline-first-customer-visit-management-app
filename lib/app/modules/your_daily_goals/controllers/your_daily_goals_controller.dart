import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/firebase_crashlytics.dart';
import 'package:icon/app/modules/your_daily_goals/repository/daily_goal_repository.dart';

import '../../goal_tracking/models/daily_goal_model.dart';

class YourDailyGoalsController extends GetxController {
  final selectedTabIndex = 0.obs;

  /// The list of tabs is now reactive. It starts with 'All Goals' and is
  /// populated dynamically from the fetched data. Your view must observe
  /// this list to rebuild the tabs when they are loaded.
  final RxList<String> tabs = ['All Goals'].obs;

  final DailyGoalRepository _repository = Get.find<DailyGoalRepository>(
    tag: (DailyGoalRepository).toString(),
  );

  /// This now serves as the single source of truth for your goals.
  final goalData = RxList<DailyGoalModel>();

  /// A computed list of goals that automatically filters based on the selected tab.
  /// Your view should observe this list to display the correct goals.
  List<DailyGoalModel> get filteredGoals {
    // If 'All Goals' is selected, return the entire list.
    if (selectedTabIndex.value == 0) {
      return goalData;
    }

    // Prevent range error if tabs are still loading
    if (selectedTabIndex.value >= tabs.length) {
      return [];
    }

    // Get the category name from the tabs list (e.g., "Workout").
    final selectedCategory = tabs[selectedTabIndex.value];

    // Filter the goalData list where the goal's section matches the
    // selected category. This comparison is case-insensitive for robustness.
    return goalData
        .where((goal) =>
    goal.section.toLowerCase() == selectedCategory.toLowerCase())
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchGoalData();
  }

  /// Fetches daily goals and dynamically builds the list of tabs.
  Future<void> fetchGoalData() async {
    try {
      final response = await _repository.fetchDailyGoals();
      goalData.assignAll(response);

      // --- DYNAMIC TAB GENERATION ---
      // Extract unique, non-empty section names from the fetched data.
      final uniqueSections =
      response.map((goal) => goal.section).toSet().toList();

      // Add the unique sections to the tabs list, preserving 'All Goals'.
      tabs.assignAll(['All Goals', ...uniqueSections]);

    } catch (e, s) {
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      }
      e.logToCrashlytics(s);
    }
  }

  /// Updates the selected tab index. Because `selectedTabIndex` is an observable,
  /// this will automatically cause `filteredGoals` to be re-evaluated.
  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  // --- Helper Methods for the View ---

  /// Converts a hex color string from your model into a `Color` object.
  /// Assumes `goal.color` is a string like "#RRGGBB".
  Color getColorForGoal(DailyGoalModel goal) {
    final hexColor = goal.color;
    if (hexColor.startsWith('#') && hexColor.length >= 7) {
      try {
        return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
      } catch (e) {
        return Colors.grey; // Fallback color
      }
    }
    return Colors.grey; // Default color
  }

  /// Maps an icon name string from your model to a real `IconData` object.
  /// You should expand this map to include all icon names from your API.
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
