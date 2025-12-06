import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/enums/body_areas.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/models/wearable_device.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/integration_icon_container.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/models/exercise_model.dart';
import 'package:icon/app/modules/weekly_routine/utils/enums/equipment_type_enum.dart';
import 'package:intl/intl.dart';
import 'widgets/scheduled_exercise_card.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/activity_tracker_controller.dart';
import 'widgets/health_dashboard_card.dart';
import 'widgets/workout_image_widget.dart';
import 'widgets/workout_recomendation_card.dart';

class ActivityTrackerView extends BaseView<ActivityTrackerController> {
  ActivityTrackerView({super.key});
  final isDropDownButtonPressed = false.obs;
  final selectedActivity = Rx<String?>(null);

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours hour${hours != 1 ? 's' : ''} $minutes min';
    } else {
      return '$minutes min';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  List<Widget> _buildActivityDetails(
    List<BodyAreas> bodyAreas,
    ActivityLogModel activityLog,
  ) {
    final List<Widget> widgets = [];

    // Add body areas with separators
    for (int i = 0; i < bodyAreas.length; i++) {
      widgets.add(
        Text(bodyAreas[i].displayName, style: AppTextTheme.bodyMediumMedium),
      ); // 12px, medium

      if (i < bodyAreas.length - 1) {
        widgets.add(4.width);
        widgets.add(SvgPicture.asset(Assets.svgDotIcon));
        widgets.add(4.width);
      }
    }

    // Add duration
    widgets.add(4.width);
    widgets.add(SvgPicture.asset(Assets.svgDotIcon));
    widgets.add(4.width);
    widgets.add(Text(_formatDuration(activityLog.duration)));

    // Add datetime
    widgets.add(4.width);
    widgets.add(SvgPicture.asset(Assets.svgDotIcon));
    widgets.add(4.width);
    widgets.add(Text(_formatDateTime(activityLog.datetime)));

    return widgets;
  }

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

    final activityLogList = [
      ActivityLogModel(
        datetime: DateTime.now(),
        exercise: workoutList[0],
        duration: const Duration(minutes: 25),
      ),
      ActivityLogModel(
        datetime: DateTime.now(),
        exercise: workoutList[1],
        duration: const Duration(minutes: 30),
      ),
    ].obs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthDashboardCard(),

          12.height,
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: WorkoutRecommendationCard(
                    coachName: 'Coach Mish',
                    coachAvatarUrl: Assets.imagesMishIcon,
                    title: 'Tip from Mish',
                    description:
                        'You went heavy yesterday, take it easy today!',
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
                SliverToBoxAdapter(child: scheduledWorkout(workoutList)),
                SliverToBoxAdapter(child: 12.height),
                SliverToBoxAdapter(child: activityLog(activityLogList)),
                SliverToBoxAdapter(child: 12.height),
                SliverToBoxAdapter(child: wearableIntegrationWidget()),
                SliverToBoxAdapter(child: 12.height),
                // SliverToBoxAdapter(
                //   child: QuickStartCard(
                //     onStartEmptyWorkout: () {},
                //     onNewRoutine: () {},
                //     onExplore: () {},
                //   ),
                // ),
                // SliverToBoxAdapter(child: 12.height),
                // SliverToBoxAdapter(child: RoutinesCard()),
                // SliverToBoxAdapter(child: 12.height),
                // SliverToBoxAdapter(child: MuscleHeatMapCard()),
                // SliverToBoxAdapter(child: 12.height),
                // SliverToBoxAdapter(child: ActivitiesCard()),
                // SliverToBoxAdapter(child: 12.height),
              ],
            ),
          ),
          12.height,
          logActivity(),
        ],
      ),
    );
  }

  Container scheduledWorkout(List<ExerciseModel> workoutList) {
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
              Text(
                'View Exercise',
                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                  color: Colors.black,
                ),
              ),
              8.width,
              Text(
                '(3)',
                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                  color: AppColors.bgColorRed,
                ),
              ),
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

  Widget? activityLog(List<ActivityLogModel> activityLogList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Log',
                style: AppTextTheme.titleSmallSemiBold.copyWith(
                  color: Colors.black,
                ),
              ),

              Text(
                '12 min ago',
                style: AppTextTheme.bodyMediumRegular.copyWith(
                  color: AppColors.colorPrimary,
                ),
              ),
            ],
          ),
          16.height,
          ...activityLogList.asMap().entries.map((entry) {
            final isLast = entry.key == activityLogList.length - 1;
            return Column(
              children: [
                activityLogTrackCard(entry.value),
                if (!isLast) 8.height,
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget activityLogTrackCard(ActivityLogModel activityLog) {
    final workout = activityLog.exercise;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          WorkoutImageWidget(
            imageAsset: workout.lightAsset,
            color: Colors.white,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.name,
                style: AppTextTheme.bodyLargeSemiBold.copyWith(
                  color: Colors.black,
                ),
              ), //14 px, semi bold, black
              8.height,
              if (workout.bodyAreaList != null &&
                  workout.bodyAreaList!.isNotEmpty)
                Row(
                  children: _buildActivityDetails(
                    workout.bodyAreaList!,
                    activityLog,
                  ),
                ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset(Assets.activityTrackerDiagonalArrow),
          8.width,
        ],
      ),
    );
  }

  Widget? wearableIntegrationWidget() {
    final deviceList = [
      const WearableDevice(
        icon: Assets.imagesApple,
        title: 'Apple Watch',
        connectionStatus: 'Connected',
        iconColor: 'FFEFEFEF',
      ),
      const WearableDevice(
        icon: Assets.imagesFitbit,
        title: 'Fitbit',
        connectionStatus: 'Not Connected',
        iconColor: 'FFE9FEFF',
      ),
      const WearableDevice(
        icon: Assets.imagesGoogle,
        title: 'Google',
        connectionStatus: 'Connected',
        iconColor: 'FFE6FFEF',
      ),
      const WearableDevice(
        icon: Assets.imagesGarmin,
        title: 'Garmin',
        connectionStatus: 'Not Connected',
        iconColor: 'FFDFF2FF',
      ),
    ];

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wearable Integration',
            style: AppTextTheme.titleMediumSemiBold.copyWith(
              color: Colors.black,
            ),
          ), //18px, Semi Bold, Black
          16.height,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: deviceList.length,
            itemBuilder: (context, index) {
              final device = deviceList[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: device.connectionStatus == 'Connected'
                        ? AppColors.positiveBorderColor
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    IntegrationIconContainer(
                      icon: device.icon,
                      iconColor: device.iconColor,
                    ),
                    8.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            device.title,
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          2.height,
                          Text(
                            device.connectionStatus == 'Connected'
                                ? 'Connected'
                                : 'Connect',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: device.connectionStatus == 'Connected'
                                  ? AppColors.positiveBorderColor
                                  : AppColors.colorPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget logActivity() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Activity',
            style: AppTextTheme.titleMediumSemiBold.copyWith(
              color: Colors.black,
            ),
          ), //18px, Semi Bold, Black
          16.height,
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => ActivityButton(
                    icon: SvgPicture.asset(
                      Assets.activityTrackerLogWorkout,
                      colorFilter: ColorFilter.mode(
                        AppColors.colorPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'Workout',
                    isSelected: selectedActivity.value == 'workout',
                    onTap: () {
                      selectedActivity.value =
                          selectedActivity.value == 'workout'
                          ? null
                          : 'workout';
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => ActivityButton(
                    icon: SvgPicture.asset(Assets.activityTrackerCardioLog),
                    label: 'Cardio',
                    isSelected: selectedActivity.value == 'cardio',
                    onTap: () {
                      selectedActivity.value =
                          selectedActivity.value == 'cardio' ? null : 'cardio';
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => ActivityButton(
                    icon: SvgPicture.asset(Assets.activityTrackerRepairLog),
                    label: 'Repair',
                    isSelected: selectedActivity.value == 'repair',
                    onTap: () {
                      selectedActivity.value =
                          selectedActivity.value == 'repair' ? null : 'repair';
                    },
                  ),
                ),
              ),
            ],
          ),
          // Expanded Content based on selection
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Obx(() {
              if (selectedActivity.value != null) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildExpandedContent(),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    switch (selectedActivity.value) {
      case 'workout':
        return _WorkoutOptions();
      case 'cardio':
        return _CardioOptions();
      case 'repair':
        return _RepairOptions();
      default:
        return const SizedBox.shrink();
    }
  }
}

class ActivityLogModel {
  final DateTime datetime;
  final ExerciseModel exercise;
  final Duration duration;

  ActivityLogModel({
    required this.datetime,
    required this.exercise,
    required this.duration,
  });
}

class ActivityButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ActivityButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        width: 126,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.chartGradientEnd
              : AppColors.lightBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.iconBgColorRed : Colors.white,
                shape: BoxShape.circle,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                child: icon,
              ),
            ),
            8.width,
            Text(
              label,
              style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ), // 16px, semi bold, black
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Start',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Want to jump in without a plan? Start an empty session and build as you go.',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Start Empty Workout Button
          _OptionButton(
            label: 'Start Empty Workout',
            onTap: () {
              // Navigate to empty workout screen
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'Routines',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pick from your saved plans or create a new one.',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Routine Buttons
          Row(
            children: [
              Expanded(
                child: _OptionButton(
                  label: 'New Routine',
                  onTap: () {
                    // Navigate to create routine
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OptionButton(
                  label: 'Explore',
                  onTap: () {
                    // Navigate to explore routines
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Cardio Options
class _CardioOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Log Cardio Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _OptionButton(
            label: 'Running',
            icon: Icons.directions_run,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _OptionButton(
            label: 'Cycling',
            icon: Icons.directions_bike,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _OptionButton(label: 'Swimming', icon: Icons.pool, onTap: () {}),
        ],
      ),
    );
  }
}

// Repair Options
class _RepairOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recovery & Repair',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _OptionButton(
            label: 'Stretching',
            icon: Icons.accessibility_new,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _OptionButton(
            label: 'Yoga',
            icon: Icons.self_improvement,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _OptionButton(label: 'Foam Rolling', icon: Icons.spa, onTap: () {}),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _OptionButton({required this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
