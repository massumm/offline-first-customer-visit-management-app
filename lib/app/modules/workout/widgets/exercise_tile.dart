import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/network/dio_provider.dart';

import '../../../../../generated/assets.dart';
import '../../../core/widgets/super_image.dart';
import '../../../core/widgets/super_widgets/super_icon.dart';
import '../../../core/widgets/super_widgets/super_icon_source.dart';
import '../controllers/workout_controller.dart';
import '../models/exercises_response_model.dart';

class ExerciseTile extends GetView<WorkoutController> {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      return Card(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: controller.isExerciseSelected(exercise)
                  ? theme.colorScheme.secondary
                  : Colors.transparent,
              width: 1,
            ),
          ),
          onTap: () {
            controller.toggleExercise(exercise);
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SuperImage(
              DioProvider.baseUrl + exercise.exerciseImage.toString(),
            ),
          ),
          title: Text(
            exercise.name ?? "",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(exercise.muscleGroup![0].name ?? ""),
          trailing: controller.isExerciseSelected(exercise)
              ? SuperIcon(
                  source: SuperIconSource.svgAsset(
                    Assets.iconsCheckmarkSelected,
                  ),
                )
              : SuperIcon(
                  source: SuperIconSource.svgAsset(Assets.iconsCheckmark),
                ),
        ),
      );
    });
  }
}
