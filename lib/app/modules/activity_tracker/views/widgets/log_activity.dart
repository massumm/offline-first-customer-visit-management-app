import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../../core/extensions/app_extansions.dart';
import '../../controllers/activity_tracker_controller.dart';

class LogActivitySection extends GetView<ActivityTrackerController> {
  const LogActivitySection({
    super.key,
    required this.theme,
    required this.textTheme,
  });

  final ThemeData theme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, -2),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Activity', style: textTheme.titleMedium),
          14.height,
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _LogActivityButton(
                //   label: ,
                //   icon: Icons.fitness_center,
                //   theme: theme,
                //   onTap: controller.onWorkoutTap,
                //   isSelected: controller.isWorkoutBtnSelected.isTrue,
                // ),
                // _LogActivityButton(
                //   label: ,
                //   icon: Icons.monitor_heart,
                //   theme: theme,
                //   onTap: controller.onCardioTap,
                //   isSelected: controller.isCardioBtnSelected.isTrue,
                // ),
                // _LogActivityButton(
                //   label: ,
                //   icon: Icons.settings,
                //   theme: theme,
                //   onTap: controller.onRepairTap,
                //   isSelected: controller.isRepairBtnSelected.isTrue,
                // ),
              ],
            );
          }),
          14.height,
          // Workout Section
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutExpo,
              switchOutCurve: Curves.easeInExpo,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: controller.isWorkoutBtnSelected.isTrue
                  ? WorkoutSection(theme: theme)
                  : const SizedBox.shrink(),
            );
          }),

          // Cardio Section
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutExpo,
              switchOutCurve: Curves.easeInExpo,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: controller.isCardioBtnSelected.isTrue
                  ? CardioSection(theme: theme)
                  : const SizedBox.shrink(),
            );
          }),

          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutExpo,
              switchOutCurve: Curves.easeInExpo,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: controller.isRepairBtnSelected.isTrue
                  ? RepairSection(theme: theme)
                  : const SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }
}

class RepairSection extends StatelessWidget {
  const RepairSection({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quick Add', style: theme.textTheme.titleMedium),
              Icon(Icons.keyboard_arrow_right, color: theme.iconTheme.color),
            ],
          ),
        ),
        12.height,
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start Live Tracking', style: theme.textTheme.titleMedium),
              Icon(Icons.keyboard_arrow_right, color: theme.iconTheme.color),
            ],
          ),
        ),
      ],
    );
  }
}

class CardioSection extends StatelessWidget {
  const CardioSection({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quick Add', style: theme.textTheme.titleMedium),
              Icon(Icons.keyboard_arrow_right, color: theme.iconTheme.color),
            ],
          ),
        ),
        12.height,
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start Live Tracking', style: theme.textTheme.titleMedium),
              Icon(Icons.keyboard_arrow_right, color: theme.iconTheme.color),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkoutSection extends StatelessWidget {
  const WorkoutSection({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Start', style: theme.textTheme.titleMedium),
        Text(
          "Want to jump in without a plan? Start an empty session"
          " and build as you go.",
          style: theme.textTheme.labelLarge,
        ),
        12.height,
        Material(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Get.toNamed(Routes.START_WORKOUT);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Empty Workout',
                    style: theme.textTheme.titleMedium,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
        ),
        12.height,
        Text('Templates', style: theme.textTheme.titleMedium),
        Text(
          "Pick from your created workout templates",
          style: theme.textTheme.labelLarge,
        ),
        12.height,
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select workout template',
                style: theme.textTheme.titleMedium,
              ),
              Icon(Icons.keyboard_arrow_right, color: theme.iconTheme.color),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogActivityButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeData theme;
  final bool isSelected;
  final void Function() onTap;

  const _LogActivityButton({
    required this.label,
    required this.icon,
    required this.theme,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: isSelected
            ? colorScheme.secondary
            : theme.scaffoldBackgroundColor,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 95,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Icon(icon, size: 28, color: colorScheme.primary),
                  6.height,
                  Text(
                    label,
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: isSelected
                          ? AppColors.lightShapeColor
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
