import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/full_body_tracker/models/workout_model.dart';
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
        ExerciseModel(
          name: 'Barbell Squat',
          sets: 1,
          reps: '5-8',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        ),
        ExerciseModel(
          name: 'Resistance Band',
          sets: 6,
          reps: '5-15',
          lightAsset: Assets.fullBodyTrackerResistanceBand,
          darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        ),
        ExerciseModel(
          name: 'Walking Lunges',
          sets: 4,
          reps: '10-12',
          lightAsset: Assets.fullBodyTrackerWalkingLunges,
          darkAsset: Assets.fullBodyTrackerWalkingLungesDark,
        ),
        ExerciseModel(
          name: 'Dumbbell Squat',
          sets: 4,
          reps: '10-12',
          lightAsset: Assets.fullBodyTrackerDumbbellSquat,
          darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        ),
        ExerciseModel(
          name: 'Deadlift',
          sets: 4,
          reps: '12-15',
          lightAsset: Assets.fullBodyTrackerDeadlift,
          darkAsset: Assets.fullBodyTrackerDeadliftDark,
        ),
        ExerciseModel(
          name: 'Barbell Squat',
          sets: 3,
          reps: '12-15',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
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
        ExerciseModel(
          name: 'Barbell Squat',
          sets: 1,
          reps: '5-8',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        ),
        ExerciseModel(
          name: 'Resistance Band',
          sets: 6,
          reps: '5-15',
          lightAsset: Assets.fullBodyTrackerResistanceBand,
          darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        ),
        ExerciseModel(
          name: 'Walking Lunges',
          sets: 4,
          reps: '10-12',
          lightAsset: Assets.fullBodyTrackerWalkingLunges,
          darkAsset: Assets.fullBodyTrackerWalkingLungesDark,
        ),
        ExerciseModel(
          name: 'Dumbbell Squat',
          sets: 4,
          reps: '10-12',
          lightAsset: Assets.fullBodyTrackerDumbbellSquat,
          darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        ),
        ExerciseModel(
          name: 'Deadlift',
          sets: 4,
          reps: '12-15',
          lightAsset: Assets.fullBodyTrackerDeadlift,
          darkAsset: Assets.fullBodyTrackerDeadliftDark,
        ),
        ExerciseModel(
          name: 'Barbell Squat',
          sets: 3,
          reps: '12-15',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
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
        ExerciseModel(
          name: 'Barbell Squat',
          sets: 1,
          reps: '5-8',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        ),
        ExerciseModel(
          name: 'Resistance Band',
          sets: 6,
          reps: '5-15',
          lightAsset: Assets.fullBodyTrackerResistanceBand,
          darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        ),
        ExerciseModel(
          name: 'Walking Lunges',
          sets: 4,
          reps: '10-12',
          lightAsset: Assets.fullBodyTrackerWalkingLunges,
          darkAsset: Assets.fullBodyTrackerWalkingLungesDark,
        ),
        ExerciseModel(
          name: 'Dumbbell Squat',
          sets: 4,
          reps: '10-12',
          lightAsset: Assets.fullBodyTrackerDumbbellSquat,
          darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        ),
        ExerciseModel(
          name: 'Deadlift',
          sets: 4,
          reps: '12-15',
          lightAsset: Assets.fullBodyTrackerDeadlift,
          darkAsset: Assets.fullBodyTrackerDeadliftDark,
        ),
        ExerciseModel(
          name: 'Barbell Squat',
          sets: 3,
          reps: '12-15',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        ),
      ],
      expanded: false.obs,
    ),
  ];
}
