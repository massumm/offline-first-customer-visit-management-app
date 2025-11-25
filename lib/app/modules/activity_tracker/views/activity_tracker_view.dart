import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/enums/body_areas.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/weekly_routine/controllers/weekly_routine_controller.dart';
import 'package:icon/app/modules/weekly_routine/utils/enums/equipment_type_enum.dart';
import 'widgets/scheduled_exercise_card.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/activity_tracker_controller.dart';
import 'widgets/activities_card.dart';
import 'widgets/health_dashboard_card.dart';
import 'widgets/muscle_heat_map_card.dart';
import 'widgets/quick_start_card.dart';
import 'widgets/routines_card.dart';
import 'widgets/workout_recomendation_card.dart';

class ActivityTrackerView extends BaseView<ActivityTrackerController> {
  ActivityTrackerView({super.key});
  final isDropDownButtonPressed = false.obs;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(
          child: ActionPill(onTap: () => Navigator.maybePop(context)),
        ),
      ),
      title: Text('Activity Tracker'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HealthDashboardCard()),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(
            child: WorkoutRecommendationCard(
              coachName: 'Coach Mish',
              coachAvatarUrl: Assets.imagesMishIcon,
              title: 'Tip from Mish',
              description: 'You went heavy yesterday, take it easy today!',
              whyNow:
                  'After two upper-body sessions, it\'s time to balance with a lower-body focus to support compound strength.',
              estimatedMinutes: 20,
              exerciseName: 'Dumbbell Squat',
              totalVolumeKg: 850,
              sets: 5,
              repsPerSetLabel: '8/10',
            ),
          ),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(child: scheduledWorkout()),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(
            child: QuickStartCard(
              onStartEmptyWorkout: () {},
              onNewRoutine: () {},
              onExplore: () {},
            ),
          ),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(child: RoutinesCard()),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(child: MuscleHeatMapCard()),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(child: ActivitiesCard()),
          SliverToBoxAdapter(child: 12.height),
        ],
      ),
    );
  }

  scheduledWorkout() {
    // dummy workout list
    final workoutList = [
      ExerciseModel(
        bodyAreaList: [BodyAreas.quads, BodyAreas.glutes],
        name: 'Dumbbell Squats',
        lightAsset: Assets.fullBodyTrackerDumbbellSquat,
        darkAsset: Assets.fullBodyTrackerDumbbellSquatDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 3,
        reps: '10-12',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.calves],
        name: 'Resistance Band',
        lightAsset: Assets.fullBodyTrackerResistanceBand,
        darkAsset: Assets.fullBodyTrackerResistanceBandDark,
        routinesCount: 3,
        equipmentType: EquipmentTypeEnum.home,
        sets: 6,
        reps: '5-15',
      ),
      ExerciseModel(
        bodyAreaList: [BodyAreas.quads, BodyAreas.hamstrings],
        name: 'Barbell Squats',
        lightAsset: Assets.fullBodyTrackerBarbellSquat,
        darkAsset: Assets.fullBodyTrackerBarbellSquatDark,
        routinesCount: 4,
        equipmentType: EquipmentTypeEnum.gym,
        sets: 4,
        reps: '10-12',
      ),
    ].obs;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.chartGradientEnd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scheduled Workout',
                style: AppTextTheme.titleSmallSemiBold.copyWith(
                  color: Colors.black,
                ),
              ), //16 px semi bold, black
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightWarningColorBG,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Leg Day',
                    style: AppTextTheme.bodyMediumSemiBold.copyWith(
                      color: AppColors.informationColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              Text('View Exercise'),
              8.width,
              Text('(3)'),
              const Spacer(),

              Obx(
                () => InkWell(
                  onTap: () {
                    isDropDownButtonPressed.value =
                        !isDropDownButtonPressed.value;
                    debugPrint('New value: ${isDropDownButtonPressed.value}');
                  },
                  child: SvgPicture.asset(
                    isDropDownButtonPressed.value
                        ? Assets.activityTrackerDropdownIcon
                        : Assets.activityTrackerDropdownUpIcon,
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              sizeCurve: Curves.easeInOut,
              crossFadeState: isDropDownButtonPressed.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ...workoutList
                        .expand(
                          (exercise) => [
                            ScheduledExerciseCard(exercise: exercise),
                            const Divider(height: 1),
                          ],
                        )
                        .take(workoutList.length * 2 - 1)
                        .toList(),
                  ],
                ),
              ),
              secondChild: const SizedBox(width: double.infinity, height: 0),
            );
          }),

          8.height,
          LoadingButton(
            onPressed: () {},
            label: 'Start Workout',
            backgroundColor: AppColors.chartGradientEnd,
          ),
        ],
      ),
    );
  }
}
