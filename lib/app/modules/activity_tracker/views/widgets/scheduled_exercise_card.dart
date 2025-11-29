import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/activity_tracker/views/widgets/routines_card.dart';
import 'package:icon/app/modules/activity_tracker/views/widgets/workout_image_widget.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/weekly_routine/utils/enums/equipment_type_enum.dart';

class ScheduledExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final bool showRoutinesCount;
  final bool showEquipmentType;

  const ScheduledExerciseCard({
    super.key,
    required this.exercise,
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
          WorkoutImageWidget(imageAsset: exercise.lightAsset),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: AppTextTheme.titleSmallSemiBold.copyWith(
                    color: Colors.black,
                  ),
                ),
                4.height,
                if (exercise.bodyAreaList != null &&
                    exercise.bodyAreaList!.isNotEmpty &&
                    !showRoutinesCount) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: exercise.bodyAreaList!
                        .map(
                          (bodyArea) => TagChip(
                            data: TagData(
                              bodyArea.displayName,
                              fg: AppColors.colorPrimary,
                              bg: ThemeHelpers.tagBackgroundColor,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

