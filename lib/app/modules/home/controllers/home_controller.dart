import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/values/app_colors.dart' show AppColors;
import 'package:icon/app/routes/app_pages.dart';

enum HeartRateStatus { normal, high, low }

enum ProteinStatus { onTrack, above, below }

class HomeController extends BaseController {
  // .............. Dummy data ................
  final username = 'Mish';
  final currentDay = 12;
  final currentLevel = 7;

  // Dynamic week data with current day at 5th position
  late final week = <DayItem>[];

  // Goals ring value
  var completedGoals = 2.obs;
  var totalGoals = 6.obs;

  // .............. Action Cards Percent ................
  var activityPercent = 0.85.obs;
  var recoveryPercent = 0.78.obs;
  var nutritionPercent = 0.65.obs;

  // .............. Nav ................
  var currentIndex = 3.obs;
  var selectedNavIndex = 0.obs;

  // Navigation method
  void handleNavigation(int index) {
    if (index == 4) {
      // Navigate to App Settings for Profile tab
      Get.toNamed(Routes.APP_SETTINGS);
      selectedNavIndex.value = index;
    } else {
      // Update index for other tabs
      selectedNavIndex.value = index;
    }
  }

  // steps
  var steps = 8450.obs;
  var targetSteps = 10000.obs;

  // hydaration
  var hydarationRemaningInLtr = 1.5.obs;

  // hear rate & hrv
  var hearRateHRVInBpm = 170.obs;
  var heartRateStatus = HeartRateStatus.normal.obs;

  // calories
  var caloriesConsumedInKCal = 1420.obs;
  var targetCaloriesInKCal = 2000.obs;

  // protein
  var proteinConsumedInPercentage = 0.57.obs;
  var proteinStatus = ProteinStatus.onTrack.obs;

  // sleep
  var wakeUpTime = const TimeOfDay(hour: 7, minute: 20).obs;
  var sleepBedTime = const TimeOfDay(hour: 22, minute: 0).obs;

  // .............. Action Cards ................
  List<ActionCardData> get actionCards => [
    ActionCardData(
      title: 'Recovery',
      color: AppColors.gradientBlueStart, // red-ish
      percent: recoveryPercent.value,
      gradient: AppColors.blueGradient,
    ),
    ActionCardData(
      title: 'Nutrition',
      color: AppColors.gradientGreenStart, // green-ish
      percent: nutritionPercent.value,
      gradient: AppColors.greenGradient,
    ),
    ActionCardData(
      title: 'Activity',
      color: AppColors.gradientRedStart, // olive-ish
      percent: activityPercent.value,
      gradient: AppColors.redGradient,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    week.addAll(_generateWeek());
  }

  List<DayItem> _generateWeek() {
    final now = DateTime.now();
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Calculate the start date (4 days before current day to keep it at 5th position)
    final startDate = now.subtract(Duration(days: 4));

    return List.generate(7, (index) {
      final date = startDate.add(Duration(days: index));
      final dayLabel = dayLabels[date.weekday - 1];
      final isToday =
          date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;

      final progress = (index > 4) ? 0.0 : (index * 0.15) % 1.0;

      return DayItem(dayLabel, date.day, progress, isToday);
    });
  }
}

class DayItem {
  final String label; // Mon/Tue...
  final int date; // 21/22...
  final double progress; // 0..1
  final bool isToday;

  DayItem(this.label, this.date, this.progress, this.isToday);
}

class ActionCardData {
  final String title;
  final Color color;
  final double percent;
  final LinearGradient? gradient;

  ActionCardData({
    required this.title,
    required this.color,
    required this.percent,
    this.gradient,
  });
}
