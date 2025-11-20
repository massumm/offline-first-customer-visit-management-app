import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';

class WorkoutHistoryController extends BaseController {
  //TODO: Implement WorkoutHistoryController

  final selectedTabIndex = 0.obs;
  final count = 0.obs;

  final totalWorkouts = 0.obs;
  final avgVolume = 0.obs;
  final peakWeight = 0.obs;

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
      progressDirection: ProgressDirection.upward,
    ),
    WorkoutHistory(
      date: DateTime(2025, 11, 1),
      workoutName: 'Dumbbell Squat',
      noOfSets: 4,
      volumeKg: 2640,
      maxWeightKg: 75,
      duration: Duration(minutes: 50),
      progressPercentage: 9.0,
      progressDirection: ProgressDirection.upward,
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
