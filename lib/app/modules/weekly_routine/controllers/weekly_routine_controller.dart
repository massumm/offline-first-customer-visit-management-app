import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/enums/body_areas.dart';
import 'package:icon/app/core/enums/week_days.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/weekly_routine/models/workout_model.dart';
import 'package:icon/generated/assets.dart';

class WeeklyRoutineController extends BaseController {
  //TODO: Implement WeeklyRoutineController

  late final RoutineModel sunday;
  late final RoutineModel monday;
  late final RoutineModel tuesday;
  final routines = RxList<RoutineModel>([]);
  final availableExercises = RxList<ExerciseModel>([]);

  final selectedDay = WeekDays.sunday.obs;

  @override
  void onInit() {
    super.onInit();

    sunday = RoutineModel(
      day: WeekDays.sunday,
      workOuts: RxList<ExerciseModel>([
        ExerciseModel(
          bodyAreaList: [BodyAreas.quads, BodyAreas.glutes],
          name: 'Dumbbell Squats',
          lightAsset: Assets.fullBodyTrackerDumbbellSquat,
          darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
          routinesCount: 3,
          isGymEquipmentNeeded: true,
          sets: 3,
          reps: '10-12',
        ),
        ExerciseModel(
          bodyAreaList: [BodyAreas.calves],
          name: 'Resistance Band',
          lightAsset: Assets.fullBodyTrackerResistanceBand,
          darkAsset: Assets.fullBodyTrackerResistanceBandDark,
          routinesCount: 3,
          isGymEquipmentNeeded: false,
          sets: 6,
          reps: '5-15',
        ),
      ]),
      isRestDay: false,
    );

    monday = RoutineModel(
      day: WeekDays.monday,
      workOuts: RxList<ExerciseModel>([]),
      isRestDay: true,
    );

    tuesday = RoutineModel(
      day: WeekDays.tuesday,
      workOuts: RxList<ExerciseModel>([
        ExerciseModel(
          bodyAreaList: [BodyAreas.quads, BodyAreas.hamstrings],
          name: 'Barbell Squats',
          lightAsset: Assets.fullBodyTrackerBarbellSquat,
          darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
          routinesCount: 4,
          isGymEquipmentNeeded: true,
          sets: 4,
          reps: '10-12',
        ),
        ExerciseModel(
          bodyAreaList: [BodyAreas.glutes, BodyAreas.hamstrings],
          name: 'Deadlifts',
          lightAsset: Assets.fullBodyTrackerDeadlift,
          darkAsset: Assets.fullBodyTrackerDeadliftDark,
          routinesCount: 3,
          isGymEquipmentNeeded: true,
          sets: 4,
          reps: '12-15',
        ),
      ]),
      isRestDay: false,
    );

    routines.addAll([sunday, monday, tuesday]);
    
    // Store all exercises in the exercises list
    availableExercises.addAll(sunday.workOuts);
    availableExercises.addAll(monday.workOuts);
    availableExercises.addAll(tuesday.workOuts);
    
    // Add exercises from FullBodyTrackerController
    availableExercises.addAll([
      ExerciseModel(
        name: 'Barbell Squat',
        sets: 1,
        reps: '5-8',
        lightAsset: Assets.fullBodyTrackerBarbellSquat,
        darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        isGymEquipmentNeeded: true,
      ),
      ExerciseModel(
        name: 'Resistance Band',
        sets: 6,
        reps: '5-15',
        lightAsset: Assets.fullBodyTrackerResistanceBand,
        darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        isGymEquipmentNeeded: true,
      ),
      ExerciseModel(
        name: 'Walking Lunges',
        sets: 4,
        reps: '10-12',
        lightAsset: Assets.fullBodyTrackerWalkingLunges,
        darkAsset: Assets.fullBodyTrackerWalkingLungesDark,
        isGymEquipmentNeeded: true,
      ),
      ExerciseModel(
        name: 'Dumbbell Squat',
        sets: 4,
        reps: '10-12',
        lightAsset: Assets.fullBodyTrackerDumbbellSquat,
        darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        isGymEquipmentNeeded: true,
      ),
      ExerciseModel(
        name: 'Deadlift',
        sets: 4,
        reps: '12-15',
        lightAsset: Assets.fullBodyTrackerDeadlift,
        darkAsset: Assets.fullBodyTrackerDeadliftDark,
        isGymEquipmentNeeded: true,
      ),
    ]);
  }
}
