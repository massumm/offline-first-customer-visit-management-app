import 'package:get/get.dart';

import 'package:flutter/material.dart';
import '../controllers/workout_controller.dart';
import '../models/index.dart';

class Exercise {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final RxBool isSelected;

  Exercise({
    required this.id,
    required this.title,
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

  WorkoutController? controller;

  final RxList<EquipmentItem> equipmentItems = [
    EquipmentItem(image: '', label: 'All Equipment', isSelected: true),
    EquipmentItem(image: '', label: 'Barbell', isSelected: false),
    EquipmentItem(image: '', label: 'Dumbbell', isSelected: false),
    EquipmentItem(image: '', label: 'Kettlebell', isSelected: false),
    EquipmentItem(image: '', label: 'Machine', isSelected: false),
    EquipmentItem(image: '', label: 'Cardio', isSelected: false),
  ].obs;

  final RxList<MusclesItem> musclesItems = [
    MusclesItem(image: '', label: 'All Muscles', isSelected: true),
    MusclesItem(image: '', label: 'Abdominal', isSelected: false),
    MusclesItem(image: '', label: 'Abductors', isSelected: false),
    MusclesItem(image: '', label: 'Adductors', isSelected: false),
    MusclesItem(image: '', label: 'Triceps', isSelected: false),
    MusclesItem(image: '', label: 'Lats', isSelected: false),
    MusclesItem(image: '', label: 'Glutes', isSelected: false),
  ].obs;

  final RxList selectedExercise = <Exercise>[].obs;

  void attach(WorkoutController controller) {
    controller = controller;
  }

  void detach() {
    controller = null;
  }

  void toggleExercise(Exercise exercise) {
    exercise.isSelected.toggle();

    if (exercise.isSelected.isTrue) {
      selectedExercise.add(exercise);
    } else{
      selectedExercise.remove(exercise);
    }
  }

  @override
  void onInit() {
    super.onInit();

    recentExercises.assignAll([
      Exercise(
        id: 'squat',
        title: 'Barbell Squat',
        subtitle: 'Quads, Glutes',
        icon: Icons.fitness_center,
        selected: true,
      ),
      Exercise(
        id: 'deadlift',
        title: 'Deadlift',
        subtitle: 'Hamstrings, Glutes',
        icon: Icons.fitness_center,
        selected: true,
      ),
    ]);

    allExercises.assignAll([
      Exercise(
        id: 'db_squat',
        title: 'Dumbbell Squat',
        subtitle: 'Quads, Glutes',
        icon: Icons.fitness_center,
      ),
      Exercise(
        id: 'lunges',
        title: 'Walking Lunges',
        subtitle: 'Full Legs',
        icon: Icons.directions_walk,
        selected: true,
      ),
      Exercise(
        id: 'running',
        title: 'Running',
        subtitle: 'Cardio',
        icon: Icons.directions_run,
      ),
      Exercise(
        id: 'band',
        title: 'Resistance Band',
        subtitle: 'Calves',
        icon: Icons.loop,
      ),
    ]);
  }

  void selectSingleEquipment(int selectedIndex) {
    for (int i = 0; i < equipmentItems.length; i++) {
      final currentItem = equipmentItems[i];
      final bool isSelected = (i == selectedIndex);

      // Update only if the selection state changes to avoid unnecessary rebuilds
      if (currentItem.isSelected != isSelected) {
        equipmentItems[i] = currentItem.copyWith(isSelected: isSelected);
      }
    }
    equipmentItems.refresh();
  }

  void selectSingleMuscles(int selectedIndex) {
    for (int i = 0; i < musclesItems.length; i++) {
      final currentItem = musclesItems[i];
      final bool isSelected = (i == selectedIndex);

      // Update only if the selection state changes to avoid unnecessary rebuilds
      if (currentItem.isSelected != isSelected) {
        musclesItems[i] = currentItem.copyWith(isSelected: isSelected);
      }
    }
    musclesItems.refresh();
  }
}
