import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart'; 
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/asset_icon_container.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/weekly_routine_controller.dart';
import '../models/workout_model.dart';
import '../widgets/week_card.dart';
import 'package:icon/app/models/exercise_model.dart';

class WeeklyRoutineView extends BaseView<WeeklyRoutineController> {
  const WeeklyRoutineView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('Weekly Routine'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      CustomToast.showWarningToast('Add week functionality coming soon!');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.lightBorderGrayColor),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.add, color: AppColors.colorPrimary),
                          Text('Add', style: AppTextTheme.bodyMediumSemiBold.copyWith(color: AppColors.colorPrimary)),
                        ],
                      ),
                    ),
                  ),
                  8.width,
                  ...controller.weeks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final week = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: WeekCard(
                        weekName: week.weekName,
                        isSelected: controller.selectedWeek.value == index,
                        onTap: () => controller.selectedWeek.value = index,
                        weekIndex: index,
                      ),
                    );
                  }),
                  16.width, // Add trailing padding
                ],
              ),
            )),
            // Text(
            //   'Tap a day to add or edit your workout plan.',
            //   style: AppTextTheme.titleSmallSemiBold.copyWith(
            //     color: AppColors.black,
            //   ),
            // ),
            16.height,
            Obx(() {
              return controller.currentWeekRoutines.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      key: ValueKey(controller.selectedWeek.value),
                      children: controller.currentWeekRoutines
                          .map((routine) => _buildRoutineCard(routine))
                          .toList(),
                    );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      key: ValueKey('empty-${controller.selectedWeek.value}'),
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'No routines found. Add your first workout!',
        style: AppTextTheme.bodyLargeRegular.copyWith(color: AppColors.black),
      ),
    );
  }

  Widget _buildRoutineCard(RoutineModel routine) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _buildDayHeader(routine),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Column(
              children: [
                if (routine.workOuts.isEmpty)
                  ...[]
                else
                  ...routine.workOuts
                      .map((workout) => _buildWorkoutItem(workout, routine, routine.workOuts.indexOf(workout) < routine.workOuts.length - 1)),
                if (!routine.isRestDay) ...[
                  8.height,
                  _buildAddWorkoutButton(routine),
                  8.height,
                ] else ...[
                  8.height,
                  _buildRestDayItem(),
                  8.height,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(RoutineModel routine) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgColorRed,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Text(
        routine.day.displayName,
        style: AppTextTheme.titleSmallSemiBold.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWorkoutItem(ExerciseModel workout, RoutineModel routine, bool showDivider) {
    return Obx(() {
      final workoutId = identityHashCode(workout).toString();
      final isDeleting = controller.deletingWorkouts.contains(workoutId);

      if(isDeleting){
        debugPrint('Deleting workout: $workoutId');
      }
      
      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: isDeleting 
          ? const SizedBox.shrink()
          : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slidable(
                  key: ValueKey(workoutId),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.20,
                    children: [
                      CustomSlidableAction(
                        onPressed: (context) {
                          controller.selectedDay.value = routine.day;
                          _handleDeleteWorkout(workout);
                        },
                        autoClose: true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.redProgressColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                color: AppColors.warningBgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                  Assets.activityTrackerDeleteIcon,
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(AppColors.redProgressColor, BlendMode.srcIn),
                                ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bgColorRed, width: 3),
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout.name,
                                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                workout.bodyAreaList?.map((e) => e.displayName).join(', ') ?? 'No body areas specified',
                                style: AppTextTheme.bodyLargeRegular,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (showDivider) const Divider(),
            ],
          ),
      );
    });
  }

  Widget _buildAddWorkoutButton(RoutineModel routine) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.add, color: AppColors.bgColorRed),
        8.width,
        GestureDetector(
          onTap: () => {
            controller.selectedDay.value = routine.day,
            _goToAddExerciseScreen(),
          },
          child: Text(
            'Add Workout',
            style: AppTextTheme.bodyLargeSemiBold.copyWith(
              color: AppColors.bgColorRed,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.bgColorRed,
            ),
          ),
        ),
      ],
    );
  }

  void _handleDeleteWorkout(ExerciseModel workout) {
    final workoutId = identityHashCode(workout).toString();
    
    // Prevent duplicate deletions
    if (controller.deletingWorkouts.contains(workoutId)) return;
    
    // Mark workout as deleting to trigger animation
    controller.deletingWorkouts.add(workoutId);
    
    // Delay actual deletion until animation completes
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.deleteWorkout(workout);
      // Remove from deleting set after controller deletion
      controller.deletingWorkouts.remove(workoutId);
    });
  }

  void _goToAddExerciseScreen() {
    Get.toNamed(Routes.ADD_EXERCISE_TO_ROUTINE);
  }

  Widget _buildRestDayItem() {
    return Column(
      children: [
        AssetIconContainer(iconPath: Assets.activityTrackerRestRecovery),
        8.height,
        SizedBox(
          width: 250,
          child: Column(
            children: [
              Text(
                'Rest & Recovery',
                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                  color: AppColors.black,
                ),
              ),
              8.height,
              Text(
                'Today\'s about recovery. Stay hydrated, stretch, and get ready for tomorrow.',
                style: AppTextTheme.bodyMediumRegular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
