import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/generated/assets.dart';

class FullBodyTrackerController extends BaseController {
  //TODO: Implement FullBodyTrackerController

  final workOuts = [
    Workout(
      name: 'Push',
      day: 'Day-1',
      description:
          'The first workout of the week focuses on the push muscles of the upper body: the chest, shoulders, and triceps.',
      exercises: [
        Exercise(
          name: 'Barbell Squat',
          sets: 1,
          reps: '5-8',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerBarbellSquatDark
              : Assets.fullBodyTrackerBarbellSquat,
        ),
        Exercise(
          name: 'Resistance Band',
          sets: 6,
          reps: '5-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerResistanceBandDark
              : Assets.fullBodyTrackerResistanceBand,
        ),
        Exercise(
          name: 'Walking Lunges',
          sets: 4,
          reps: '10-12',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerWalkingLungesDark
              : Assets.fullBodyTrackerWalkingLunges,
        ),
        Exercise(
          name: 'Dumbbell Squat',
          sets: 4,
          reps: '10-12',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerDumbbellSquatDark
              : Assets.fullBodyTrackerDumbbellSquat,
        ),
        Exercise(
          name: 'Deadlift',
          sets: 4,
          reps: '12-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerDeadliftDark
              : Assets.fullBodyTrackerDeadlift,
        ),
        Exercise(
          name: 'Barbell Squat',
          sets: 3,
          reps: '12-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerBarbellSquatDark
              : Assets.fullBodyTrackerBarbellSquat,
        ),
      ],
      expanded: true.obs,
    ),
    Workout(
      name: 'Pull',
      day: 'Day-2',
      description:
          'This workout focuses on the upper body muscles involved in pulling motions—the entire back (traps, rhomboids, lats), biceps, and rear shoulders.',
      exercises: [
        Exercise(
          name: 'Barbell Squat',
          sets: 1,
          reps: '5-8',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerBarbellSquatDark
              : Assets.fullBodyTrackerBarbellSquat,
        ),
        Exercise(
          name: 'Resistance Band',
          sets: 6,
          reps: '5-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerResistanceBandDark
              : Assets.fullBodyTrackerResistanceBand,
        ),
        Exercise(
          name: 'Walking Lunges',
          sets: 4,
          reps: '10-12',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerWalkingLungesDark
              : Assets.fullBodyTrackerWalkingLunges,
        ),
        Exercise(
          name: 'Dumbbell Squat',
          sets: 4,
          reps: '10-12',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerDumbbellSquatDark
              : Assets.fullBodyTrackerDumbbellSquat,
        ),
        Exercise(
          name: 'Deadlift',
          sets: 4,
          reps: '12-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerDeadliftDark
              : Assets.fullBodyTrackerDeadlift,
        ),
        Exercise(
          name: 'Barbell Squat',
          sets: 3,
          reps: '12-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerBarbellSquatDark
              : Assets.fullBodyTrackerBarbellSquat,
        ),
      ],
      expanded: false.obs,
    ),
    Workout(
      name: 'Legs',
      day: 'Day-3',
      description:
          'The final workout of the week focuses on the lower body musculature: the glutes, hamstrings, quadriceps, and calves.',
      exercises: [
        Exercise(
          name: 'Barbell Squat',
          sets: 1,
          reps: '5-8',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerBarbellSquatDark
              : Assets.fullBodyTrackerBarbellSquat,
        ),
        Exercise(
          name: 'Resistance Band',
          sets: 6,
          reps: '5-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerResistanceBandDark
              : Assets.fullBodyTrackerResistanceBand,
        ),
        Exercise(
          name: 'Walking Lunges',
          sets: 4,
          reps: '10-12',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerWalkingLungesDark
              : Assets.fullBodyTrackerWalkingLunges,
        ),
        Exercise(
          name: 'Dumbbell Squat',
          sets: 4,
          reps: '10-12',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerDumbbellSquatDark
              : Assets.fullBodyTrackerDumbbellSquat,
        ),
        Exercise(
          name: 'Deadlift',
          sets: 4,
          reps: '12-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerDeadliftDark
              : Assets.fullBodyTrackerDeadlift,
        ),
        Exercise(
          name: 'Barbell Squat',
          sets: 3,
          reps: '12-15',
          iconPath: Get.isDarkMode
              ? Assets.fullBodyTrackerBarbellSquatDark
              : Assets.fullBodyTrackerBarbellSquat,
        ),
      ],
      expanded: false.obs,
    ),
  ];

  final count = 0.obs;



  void increment() => count.value++;
}

class Workout {
  final String name;
  final String day;
  final String description;
  final List<Exercise> exercises;
  final RxBool expanded;

  Workout({
    required this.name,
    required this.day,
    required this.description,
    required this.exercises,
    required this.expanded,
  });
}

class Exercise {
  final String name;
  final int sets;
  final String? reps; // Can be a range like "5-15" or "10-12"
  final String iconPath; // Optional path to exercise icon/illustration

  Exercise({
    required this.name,
    required this.sets,
    this.reps,
    required this.iconPath,
  });
}
