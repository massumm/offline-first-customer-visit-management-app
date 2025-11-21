import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
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
        child: Center(child: ActionPill(onTap: () => Get.back())),
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
              if (controller.currentWeekRoutines.isEmpty) {
                return _buildEmptyState();
              }
              return Column(
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
                      .map((workout) => _buildWorkoutItem(workout))
                      .expand((item) => [item, const Divider()])
                      .take(routine.workOuts.length * 2 - 1),
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

  Widget _buildWorkoutItem(ExerciseModel workout) {
    return Row(
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
    );
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
