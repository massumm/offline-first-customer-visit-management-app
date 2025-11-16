import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/activity_tracker/views/widgets/routines_card.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/weekly_routine/controllers/weekly_routine_controller.dart';
import 'package:icon/generated/assets.dart';

class AddedExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final WeeklyRoutineController controller;
  final bool showEditAndDeleteIcons;
  final bool showRoutinesCount;
  final bool showEquipmentType;

  const AddedExerciseCard({
    super.key,
    required this.exercise,
    required this.controller,
    this.showEditAndDeleteIcons = true,
    this.showRoutinesCount = false,
    this.showEquipmentType = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ThemeHelpers.primaryCardColor,
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ThemeHelpers.secondaryCardColor,
            ),
            child: Image.asset(
              Get.isDarkMode ? exercise.darkAsset : exercise.lightAsset,
              fit: BoxFit.contain,
            ),
          ),
          16.width,
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exercise.name, style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),),
              if(exercise.bodyAreaList != null && exercise.bodyAreaList!.isNotEmpty && !showRoutinesCount)
                ...[
                  8.height,

                  Text(
                  exercise.bodyAreaList!.map((bodyArea) => bodyArea.displayName).join(', '),
                  style: AppTextTheme.bodyLargeRegular.copyWith(
                    color: ThemeHelpers.secondaryTextColor,
                  ),
                )],
              if(showRoutinesCount)
                Text('${exercise.routinesCount} routines', style: AppTextTheme.bodyLargeRegular.copyWith(
                  color: ThemeHelpers.secondaryTextColor,
                ),),
              if(showEquipmentType)
                ...[
                  8.height,
                  TagChip(
                    data: TagData(
                      exercise.equipmentType!.displayName,
                      fg: AppColors.colorPrimary,
                      bg: ThemeHelpers.tagBackgroundColor,
                    ),
                  ),
                ]
            ],
          ),

          if(showEditAndDeleteIcons)...[const Spacer(),
          Row(
            children: [
              InkWell(onTap: () => _editExercise(exercise), child: SvgPicture.asset(Assets.fullBodyTrackerEditIcon)),
              16.width,
              InkWell(
                  onTap: () => _deleteExercise(exercise),
                  child: SvgPicture.asset(Assets.fullBodyTrackerDeleteIcon)),
            ],
          )]
        ],
      ),
    );
  }

  void _editExercise(ExerciseModel exercise) {}

  void _deleteExercise(ExerciseModel exercise) {
    // Check which week is selected first
    if (controller.selectedWeek.value < 0 || controller.selectedWeek.value >= controller.weeks.length) {
      return;
    }

    final currentWeek = controller.weeks[controller.selectedWeek.value];
    final currentRoutine = currentWeek.routines.firstWhereOrNull(
      (routine) => routine.day == controller.selectedDay.value,
    );

    if (currentRoutine == null) {
      return;
    }

    // Remove the exercise from the current routine
    currentRoutine.workOuts.removeWhere((existingExercise) =>
    existingExercise.name == exercise.name
    );
  }
}
