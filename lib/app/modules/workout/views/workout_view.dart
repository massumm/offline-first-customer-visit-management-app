import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';
import 'package:icon/generated/assets.dart';

import '../../activity_tracker/models/workout_response_model.dart';
import '../controllers/workout_controller.dart';
import '../widgets/workout_exercise_card.dart';
import '../widgets/workout_summary_widget.dart';

class WorkoutView extends BaseView<WorkoutController> {
  const WorkoutView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: Text('Start Workout'),
    leading: Padding(
      padding: EdgeInsets.all(6),
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
        icon: SuperIconSource.icon(Icons.settings_outlined),
        iconSize: 20,
      ),
      8.width,
    ],
  );

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          // loading indicator
          SliverToBoxAdapter(
            child: Obx(() {
              return Visibility(
                visible: controller.workoutService.isLoading.value,
                replacement: SizedBox.shrink(),
                child: LinearProgressIndicator(),
              );
            }),
          ),
          Obx(() {
            if (controller.workoutService.exerciseData.isNotEmpty) {
              // Data State
              return SliverList.builder(
                itemCount: controller.workoutService.exerciseData.length,
                itemBuilder: (context, index) {
                  final ExerciseElement exercise =
                      controller.workoutService.exerciseData[index];
                  return WorkoutExerciseCard(exercise: exercise);
                },
              );
            }
            // Loading State (NO DATA YET)
            final isLoading = controller.workoutService.isLoading.value;
            if (isLoading) {
              return SliverToBoxAdapter(child: SizedBox.shrink());
            }
            // Empty State
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 24),
                child: Center(
                  child: Column(
                    children: [
                      SuperIcon(
                        source: SuperIconSource.imageAsset(
                          Assets.activityTrackerWorkout,
                        ),
                        size: 56,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'No exercises yet',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.disabledColor.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap on "Add Exercise" below to get started!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.disabledColor.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // Add Exercise button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                  child: const Text('Add Exercise'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return WorkoutSummaryWidget();
  }
}
