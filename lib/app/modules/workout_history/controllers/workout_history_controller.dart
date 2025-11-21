import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/enums/week_days.dart';

class WorkoutHistoryController extends BaseController {
  //TODO: Implement WorkoutHistoryController

  final selectedTabIndex = 0.obs;
  final count = 0.obs;
  final selectedWeek = 'Weekly'.obs;

  final totalWorkouts = 0.obs;
  final avgVolume = 0.obs;
  final peakWeight = 0.obs;

  final volumeIncrease = 0.0.obs;
  final strengthGain = 0.0.obs;

  void setVolumeIncrease(double value) => volumeIncrease.value = value;
  void setStrengthGain(double value) => strengthGain.value = value;

  double get volumeIncreaseValue => 60.0;
  double get strengthGainValue => 23.1;

  final weeklyTotalVolumeList = <DailyCharts>[].obs;
  
  ChartData get weeklyTotalVolumeChartData => ChartData(
    title: 'Total Volume (kg)',
    data: [
      DailyCharts(days: WeekDays.monday, value: 320),
      DailyCharts(days: WeekDays.tuesday, value: 310),
      DailyCharts(days: WeekDays.wednesday, value: 460),
      DailyCharts(days: WeekDays.thursday, value: 520),
      DailyCharts(days: WeekDays.friday, value: 600),
      DailyCharts(days: WeekDays.saturday, value: 650),
      DailyCharts(days: WeekDays.sunday, value: 700),
    ],
    interval: 150,
  );
  
  
  final maxWeightProcessList = <DailyCharts>[].obs;
  
  ChartData get maxWeightProcessChartData => ChartData(
    title: 'Max Weight Progress (kg)',
    data: [
      DailyCharts(days: WeekDays.monday, value: 45),
      DailyCharts(days: WeekDays.tuesday, value: 50),
      DailyCharts(days: WeekDays.wednesday, value: 55),
      DailyCharts(days: WeekDays.thursday, value: 60),
      DailyCharts(days: WeekDays.friday, value: 65),
      DailyCharts(days: WeekDays.saturday, value: 70),
      DailyCharts(days: WeekDays.sunday, value: 75),
    ],
    interval: 20,
  );

  final estimatedOneRepMaxList = <DailyCharts>[].obs;
  
  ChartData get estimatedOneRepMaxChartData => ChartData(
    title: 'Estimated 1 Rep Max (kg)',
    data: [
      DailyCharts(days: WeekDays.monday, value: 60),
      DailyCharts(days: WeekDays.tuesday, value: 65),
      DailyCharts(days: WeekDays.wednesday, value: 70),
      DailyCharts(days: WeekDays.thursday, value: 75),
      DailyCharts(days: WeekDays.friday, value: 80),
      DailyCharts(days: WeekDays.saturday, value: 85),
      DailyCharts(days: WeekDays.sunday, value: 90),
    ],
    interval: 25,
  );

  // Getters with calculations
  int get totalWorkoutsCount => dumbbellSquats.length;
  
  double get averageVolume {
    if (dumbbellSquats.isEmpty) return 0;
    double totalVolume = dumbbellSquats.fold(0, (sum, workout) => sum + workout.volumeKg);
    return totalVolume / dumbbellSquats.length;
  }
  
  double get peakWeightValue {
    if (dumbbellSquats.isEmpty) return 0;
    return dumbbellSquats.fold(0, (max, workout) => 
        workout.maxWeightKg > max ? workout.maxWeightKg : max);
  }

  final List<WorkoutHistory> dumbbellSquats = [
    WorkoutHistory(
      date: DateTime(2025, 11, 7),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2640,
      maxWeightKg: 75,
      duration: Duration(minutes: 50),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.upward,
    ),
    WorkoutHistory(
      date: DateTime(2025, 11, 4),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2640,
      maxWeightKg: 75,
      duration: Duration(minutes: 50),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.downward,
    ),
    WorkoutHistory(
      date: DateTime(2025, 11, 1),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2640,
      maxWeightKg: 75,
      duration: Duration(minutes: 50),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.noProgress,
    ),
    WorkoutHistory(
      date: DateTime(2025, 10, 28),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2640,
      maxWeightKg: 75,
      duration: Duration(minutes: 50),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.upward,
    ),
    WorkoutHistory(
      date: DateTime(2025, 10, 25),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2640,
      maxWeightKg: 75,
      duration: Duration(minutes: 50),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.upward,
    ),
    WorkoutHistory(
      date: DateTime(2025, 10, 25),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2200,
      maxWeightKg: 75,
      duration: Duration(minutes: 20),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.upward,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

enum ProgressDirection {
  upward,
  downward,
  noProgress,
}

class WorkoutHistory {
  final DateTime date;
  final String workoutName;
  final int noOfSets;
  final double volumeKg;
  final double maxWeightKg;
  final Duration duration;
  final double progressPercentage;
  final ProgressDirection progressDirection;

  WorkoutHistory({
    required this.date,
    required this.workoutName,
    required this.noOfSets,
    required this.volumeKg,
    required this.maxWeightKg,
    required this.duration,
    required this.progressPercentage,
    required this.progressDirection,
  });
}

class DailyCharts {
  final WeekDays days;
  final double value;

  DailyCharts({required this.days, required this.value});
}

class ChartData {
  final List<DailyCharts> data;
  final double interval;
  final String title;
  
  ChartData({required this.data, required this.interval, required this.title});
  
  double get maxValue {
    final highestValue = data.fold<double>(0, (max, item) => max > item.value ? max : item.value);
    return (highestValue / interval).ceil() * interval;
  }
}
