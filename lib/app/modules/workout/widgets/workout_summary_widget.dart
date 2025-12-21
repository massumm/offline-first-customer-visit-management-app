import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../controllers/workout_controller.dart';

class WorkoutSummaryWidget extends GetView<WorkoutController> {
  const WorkoutSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                return _SummaryValue(
                  label: 'Total Volume',
                  value: '${controller.totalVolume.toStringAsFixed(1)} kg',
                  theme: theme,
                );
              }),
              Obx(() {
                return _SummaryValue(
                  label: 'Duration',
                  value: controller.onWorkoutDuration,
                  theme: theme,
                );
              }),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.workoutOnDiscard,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    'Discard',
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: AppColors.darkTextPrimaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.workoutOnSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.activityPrimaryColor,
                    textStyle: theme.textTheme.titleSmall,
                  ),
                  child: const Text('Save Workout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _SummaryValue({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.darkTextPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
