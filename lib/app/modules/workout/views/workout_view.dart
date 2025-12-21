import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';
import '../controllers/workout_controller.dart';
import 'widgets/workout_set_card.dart';
import 'widgets/workout_summary_widget.dart';

class WorkoutView extends BaseView<WorkoutController> {
  const WorkoutView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: Text('Start Workout'),
    leading: Padding(
      padding: EdgeInsetsGeometry.all(6),
      child: ActionButton.compact(onTap: Get.back),
    ),
    centerTitle: true,
    actions: [
      ActionButton(
        onTap: () => controller.onClockTap(context),
        height: 40,
        width: 40,
        icon: SuperIconSource.icon(Icons.alarm),
        iconSize: 20,
      ),
      8.width,
      ActionButton(
        onTap: controller.onSettingTap,
        height: 40,
        width: 40,
        icon:SuperIconSource.icon( Icons.settings_outlined),
        iconSize: 20,
      ),
      8.width,
    ],
  );

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: WorkoutSetCard()),
        // ADD BUTTON
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.activityPrimaryColor,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.activityPrimaryColor.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: OutlinedButton(
                onPressed: controller.onAddExerciseTap,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.activityPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide.none,
                  ),
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  overlayColor: AppColors.activityPrimaryColor.withValues(
                    alpha: 0.06,
                  ),
                ),
                child: Text('Add Exercise'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return WorkoutSummaryWidget();
  }
}
