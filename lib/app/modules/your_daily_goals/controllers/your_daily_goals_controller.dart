import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/firebase_crashlytics.dart';
import 'package:icon/app/modules/your_daily_goals/repository/daily_goal_repository.dart';

import '../../goal_tracking/models/daily_goal_model.dart';

// Define an enum for goal categories to ensure type safety.
enum GoalCategory { activity, nutrition, recovery }

// Define a model for a goal.
class Goal {
  final String title;
  final String value;
  final String description;
  final String frequency;
  final Color color;
  final IconData icon;
  final GoalCategory category;

  Goal({
    required this.title,
    required this.value,
    required this.description,
    required this.frequency,
    required this.color,
    required this.icon,
    required this.category,
  });
}

class YourDailyGoalsController extends GetxController {
  final selectedTabIndex = 0.obs;

  /// Defines the titles for the tabs.
  final List<String> tabs = ['All Goals', 'Activity', 'Nutrition', 'Recovery'];

  /// Private list of all goals.
  final List<Goal> _allGoals = [
    Goal(
      title: 'Step Goal',
      value: '7,000 steps',
      description: 'From zero steps in a day… the right direction!',
      frequency: 'Everyday',
      color: Colors.red,
      icon: Icons.directions_walk,
      category: GoalCategory.activity,
    ),
    Goal(
      title: 'Workout',
      value: '45–60 mins',
      description: 'Training sessions aligned to overall performance.',
      frequency: 'Everyday',
      color: Colors.red,
      icon: Icons.fitness_center,
      category: GoalCategory.activity,
    ),
    Goal(
      title: 'Calorie Intake',
      value: '2,100 kcal',
      description: 'Caloric intake aligned to optimize energy.',
      frequency: 'Everyday',
      color: Colors.green,
      icon: Icons.local_fire_department,
      category: GoalCategory.nutrition,
    ),
    Goal(
      title: 'Protein Intake',
      value: '110 grams',
      description: 'Helps maximize growth through protein.',
      frequency: 'Everyday',
      color: Colors.green,
      icon: Icons.egg_outlined,
      category: GoalCategory.nutrition,
    ),
    Goal(
      title: 'Water Goal',
      value: '2.5 L',
      description: 'Stay hydrated for daily performance.',
      frequency: 'Everyday',
      color: Colors.blue,
      icon: Icons.water_drop,
      category: GoalCategory.nutrition,
    ),
    Goal(
      title: 'Repair Goal',
      value: '5 min mobility',
      description: 'Daily recovery routine to improve mobility.',
      frequency: 'Everyday',
      color: Colors.orange,
      icon: Icons.self_improvement,
      category: GoalCategory.recovery,
    ),
  ];

  List<Goal> get filteredGoals {
    if (selectedTabIndex.value == 0) {
      return _allGoals;
    }

    final selectedCategory = GoalCategory.values[selectedTabIndex.value - 1];
    return _allGoals
        .where((goal) => goal.category == selectedCategory)
        .toList();
  }

  final DailyGoalRepository _repository = Get.find<DailyGoalRepository>(
    tag: (DailyGoalRepository).toString(),
  );

  RxList goalData = RxList<DailyGoalModel>();

  @override
  void onInit() {
    super.onInit();

    fetchGoalData();
  }

  Future<void> fetchGoalData() async {
    try {
      final response = await _repository.fetchDailyGoals();

      goalData.assignAll(response);
    } catch (e, s) {
      if (e is ApiException) {
        CustomToast.showErrorToast(e.description);
      }
      e.logToCrashlytics(s);
    }
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}
