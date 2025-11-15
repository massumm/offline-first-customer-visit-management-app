import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ThemeHelpers.secondaryCardColor,
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ThemeHelpers.primaryCardColor,
            ),
            child: Image.asset(
              Get.isDarkMode ? exercise.darkAsset : exercise.lightAsset, 
              fit: BoxFit.contain,
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: AppTextTheme.titleSmallSemiBold.copyWith(
                    color: ThemeHelpers.primaryTextColor,
                  ),
                ),
                8.height,
                Row(
                  children: [
                    Text(
                      '${exercise.sets.toString()} ${exercise.sets == 1 ? 'Set' : 'Sets'}',
                      style: AppTextTheme.bodyLargeRegular.copyWith(
                        color: ThemeHelpers.secondaryTextColor,
                      ),
                    ),
                    if (exercise.reps != null) ...[
                      Text(
                        ' • ${exercise.reps} Reps',
                        style: AppTextTheme.bodyLargeRegular.copyWith(
                          color: ThemeHelpers.secondaryTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
