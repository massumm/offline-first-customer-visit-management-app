import 'package:icon/app/core/enums/body_areas.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/weekly_routine/utils/enums/equipment_type_enum.dart';
import 'package:icon/generated/assets.dart';

class ExerciseData {
  static List<ExerciseModel> getSundayExercises() {
    return [
      ExerciseModel(
        bodyAreaList: [BodyAreas.quads, BodyAreas.glutes],
        name: 'Dumbbell Squats',
        lightAsset: Assets.fullBodyTrackerDumbbellSquat,
        darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 3,
        reps: '10-12',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.calves],
        name: 'Resistance Band',
        lightAsset: Assets.fullBodyTrackerResistanceBand,
        darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 6,
        reps: '5-15',
      ),
    ];
  }

  static List<ExerciseModel> getMondayExercises() {
    return []; // Rest day
  }

  static List<ExerciseModel> getTuesdayExercises() {
    return [
      ExerciseModel(
        bodyAreaList: [BodyAreas.quads, BodyAreas.hamstrings],
        name: 'Barbell Squats',
        lightAsset: Assets.fullBodyTrackerBarbellSquat,
        darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        routinesCount: 4,
        equipmentType: EquipmentTypeEnum.gym,
        sets: 4,
        reps: '10-12',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.glutes, BodyAreas.hamstrings],
        name: 'Deadlifts',
        lightAsset: Assets.fullBodyTrackerDeadlift,
        darkAsset: Assets.fullBodyTrackerDeadliftDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.gym,
        sets: 4,
        reps: '12-15',
      ),
    ];
  }

  static List<ExerciseModel> getWednesdayExercises() {
    return [
      ExerciseModel(
        bodyAreaList: [BodyAreas.chest, BodyAreas.triceps],
        name: 'Push-ups',
        lightAsset: Assets.fullBodyTrackerDumbbellSquat,
        darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 3,
        reps: '15-20',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.shoulders],
        name: 'Shoulder Press',
        lightAsset: Assets.fullBodyTrackerBarbellSquat,
        darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.gym,
        sets: 4,
        reps: '10-12',
      ),
    ];
  }

  static List<ExerciseModel> getThursdayExercises() {
    return [
      ExerciseModel(
        bodyAreaList: [BodyAreas.back, BodyAreas.biceps],
        name: 'Pull-ups',
        lightAsset: Assets.fullBodyTrackerDeadlift,
        darkAsset: Assets.fullBodyTrackerDeadliftDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 3,
        reps: '8-12',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.hamstrings, BodyAreas.glutes],
        name: 'Romanian Deadlifts',
        lightAsset: Assets.fullBodyTrackerBarbellSquat,
        darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.gym,
        sets: 4,
        reps: '12-15',
      ),
    ];
  }

  static List<ExerciseModel> getFridayExercises() {
    return [
      ExerciseModel(
        bodyAreaList: [BodyAreas.quads, BodyAreas.calves],
        name: 'Leg Press',
        lightAsset: Assets.fullBodyTrackerWalkingLunges,
        darkAsset: Assets.fullBodyTrackerWalkingLungesDark,
        routinesCount: 4,
        equipmentType: EquipmentTypeEnum.gym,
        sets: 4,
        reps: '10-12',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.abs],
        name: 'Plank',
        lightAsset: Assets.fullBodyTrackerResistanceBand,
        darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.noEquipment,
        sets: 3,
        reps: '30-60 seconds',
      ),
    ];
  }

  static List<ExerciseModel> getSaturdayExercises() {
    return [
      ExerciseModel(
        bodyAreaList: [BodyAreas.fullBody],
        name: 'Burpees',
        lightAsset: Assets.fullBodyTrackerDumbbellSquat,
        darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.noEquipment,
        sets: 3,
        reps: '10-15',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.cardio],
        name: 'Jump Rope',
        lightAsset: Assets.fullBodyTrackerResistanceBand,
        darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 5,
        reps: '1 minute',
      ),
    ];
  }

  static List<ExerciseModel> getAdditionalExercises() {
    return [
      ExerciseModel(
        name: 'Bench Press',
        bodyAreaList: [BodyAreas.chest, BodyAreas.triceps],
        sets: 4,
        reps: '8-12',
        lightAsset: Assets.fullBodyTrackerBarbellSquat,
        darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        equipmentType: EquipmentTypeEnum.gym,
        routinesCount: 3,
      ),
      ExerciseModel(
        name: 'Lat Pulldowns',
        bodyAreaList: [BodyAreas.back, BodyAreas.biceps],
        sets: 4,
        reps: '10-12',
        lightAsset: Assets.fullBodyTrackerDeadlift,
        darkAsset: Assets.fullBodyTrackerDeadliftDark,
        equipmentType: EquipmentTypeEnum.gym,
        routinesCount: 3,
      ),
      ExerciseModel(
        name: 'Mountain Climbers',
        bodyAreaList: [BodyAreas.cardio, BodyAreas.abs],
        sets: 3,
        reps: '30 seconds',
        lightAsset: Assets.fullBodyTrackerResistanceBand,
        darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        equipmentType: EquipmentTypeEnum.noEquipment,
        routinesCount: 3,
      ),
    ];
  }
}
