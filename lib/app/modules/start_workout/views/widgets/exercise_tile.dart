import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../generated/assets.dart';
import '../../../../core/widgets/super_widgets/super_icon.dart';
import '../../../../core/widgets/super_widgets/super_icon_source.dart';
import '../../controllers/start_workout_controller.dart';
import '../../services/start_workout_services_index.dart';

class ExerciseTile extends GetView<StartWorkoutController> {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final isSelected = exercise.isSelected;
      return Card(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected.value
                  ? theme.colorScheme.secondary
                  : Colors.transparent,
              width: 1,
            ),
          ),
          onTap: () {
            controller.exerciseSelectionService.toggleExercise(exercise);
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SuperIcon(source: SuperIconSource.icon(exercise.icon)),
          ),
          title: Text(
            exercise.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(exercise.subtitle),
          trailing: isSelected.value
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
