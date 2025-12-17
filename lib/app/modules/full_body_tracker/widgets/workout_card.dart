import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/modules/full_body_tracker/models/workout_model.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/full_body_tracker/widgets/exercise_card.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ThemeHelpers.primaryCardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => workout.expanded.toggle(),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      workout.name,
                      style: AppTextTheme.titleSmallMedium.copyWith(
                        color: ThemeHelpers.primaryTextColor,
                      ),
                    ),
                    16.width,
                    // TagChip(
                    //   data: TagData(
                    //     workout.day,
                    //     fg: AppColors.colorPrimary,
                    //     bg: ThemeHelpers.tagBackgroundColor,
                    //   ),
                    // ),
                    Spacer(),
                    Obx(
                      () => workout.expanded.value
                          ? Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: ThemeHelpers.primaryTextColor,
                            )
                          : Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: ThemeHelpers.primaryTextColor,
                            ),
                    ),
                  ],
                ),
                8.height,
                Text(
                  workout.description,
                  style: AppTextTheme.bodyLargeRegular.copyWith(
                    color: ThemeHelpers.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => workout.expanded.value
                ? Column(
                    children: [
                      16.height,
                      ...workout.exercises.map(
                        (exercise) => ExerciseCard(exercise: exercise),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    ));
  }
}
