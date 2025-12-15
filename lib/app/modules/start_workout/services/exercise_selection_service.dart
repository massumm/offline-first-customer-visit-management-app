import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../controllers/start_workout_controller.dart';

class Exercise {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final RxBool isSelected;

  Exercise({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    bool selected = false,
  }) : isSelected = selected.obs;
}

class ExerciseSelectionService extends GetxService {
  final RxList<Exercise> recentExercises = <Exercise>[].obs;
  final RxList<Exercise> allExercises = <Exercise>[].obs;

  int get selectedCount =>
      recentExercises.where((e) => e.isSelected.value).length +
      allExercises.where((e) => e.isSelected.value).length;

  StartWorkoutController? controller;

  void attach(StartWorkoutController controller) {
    controller = controller;
  }

  void detach() {
    controller = null;
  }

  void toggleExercise(Exercise exercise) {
    exercise.isSelected.toggle();
  }

  @override
  void onInit() {
    super.onInit();

    recentExercises.assignAll([
      Exercise(
        id: 'squat',
        name: 'Barbell Squat',
        subtitle: 'Quads, Glutes',
        icon: Icons.fitness_center,
        selected: true,
      ),
      Exercise(
        id: 'deadlift',
        name: 'Deadlift',
        subtitle: 'Hamstrings, Glutes',
        icon: Icons.fitness_center,
        selected: true,
      ),
    ]);

    allExercises.assignAll([
      Exercise(
        id: 'db_squat',
        name: 'Dumbbell Squat',
        subtitle: 'Quads, Glutes',
        icon: Icons.fitness_center,
      ),
      Exercise(
        id: 'lunges',
        name: 'Walking Lunges',
        subtitle: 'Full Legs',
        icon: Icons.directions_walk,
        selected: true,
      ),
      Exercise(
        id: 'running',
        name: 'Running',
        subtitle: 'Cardio',
        icon: Icons.directions_run,
      ),
      Exercise(
        id: 'band',
        name: 'Resistance Band',
        subtitle: 'Calves',
        icon: Icons.loop,
      ),
    ]);
  }
}
