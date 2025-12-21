
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_button.dart';

import '../controllers/workout_controller.dart';
import '../services/workout_settings_service.dart';

class WorkoutSettingsView extends BaseView<WorkoutController> {
  const WorkoutSettingsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: Text('Workout Settings'),
    centerTitle: true,
    leading: Padding(
      padding: EdgeInsetsGeometry.all(12),

      child: ActionButton(onTap: Get.back),
    ),
  );

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final WorkoutSettingsService settingsService = controller.settingsService;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CustomScrollView(
        slivers: [
          // Rest timer.
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: Row(
                children: [
                  Text(
                    'Default Rest Timer',
                    style: theme.textTheme.titleMedium,
                  ),
                  Spacer(),
                  Text('25s', style: theme.textTheme.bodyLarge),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Keep Awake During Workout',
                      style: theme.textTheme.titleMedium,
                    ),
                    Obx(() {
                      return Switch(
                        value: settingsService.keepAwakeOnWorkout.value,
                        onChanged: settingsService.toggleKeepAwakeOnWorkout,
                      );
                    }),
                  ],
                ),
                Text(
                  "Enter this if you don't want your phone to sleep while you're in a workout",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          _buildDivider(),
          // Plate Calculator
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plate Calculator',
                      style: theme.textTheme.titleMedium,
                    ),
                    Obx(() {
                      return Switch(
                        value: settingsService.plateCalculator.value,
                        onChanged: settingsService.togglePlateCalculator,
                      );
                    }),
                  ],
                ),
                Text(
                  "A plate calculator calculates the plates needed on"
                  " a bar to achieve a specific weight. When enabled, a Calculator button will appear when inputting weight"
                  " for barbell exercises.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          _buildDivider(),
          // RPE Tracker
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RPE Tracker', style: theme.textTheme.titleMedium),
                    Obx(() {
                      return Switch(
                        value: settingsService.rpeTracker.value,
                        onChanged: settingsService.toggleRpeTracker,
                      );
                    }),
                  ],
                ),
                Text(
                  "RPE (Rated Perceived Exertion) is a measure of the"
                  "intensity an exercise. Enabling RPE tracking will"
                  "allow you to log it for each set in your workouts.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          _buildDivider(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Smart Superset Scrolling',
                      style: theme.textTheme.titleMedium,
                    ),
                    Obx(() {
                      return Switch(
                        value: settingsService.smartSetScrolling.value,
                        onChanged: settingsService.toggleSmartSetScrolling,
                      );
                    }),
                  ],
                ),
                Text(
                  "When you complete a set. it'll automatically scroll to"
                  "the next exercise in the superset.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          _buildDivider(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Inline Tracker', style: theme.textTheme.titleMedium),
                    Obx(() {
                      return Switch(
                        value: settingsService.inlineTimer.value,
                        onChanged: settingsService.toggleInlineTimer,
                      );
                    }),
                  ],
                ),
                Text(
                  "Duration exercises have a built-in stopwatch for"
                  "tracking time for each set",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          _buildDivider(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Personal Record Notification',
                      style: theme.textTheme.titleMedium,
                    ),
                    Obx(() {
                      return Switch(
                        value:
                            settingsService.personalRecordNotifications.value,
                        onChanged:
                            settingsService.togglePersonalRecordNotifications,
                      );
                    }),
                  ],
                ),
                Text(
                  "When enabled, it'll notify you when you achieve a"
                  "Personal Record upon checking the set.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDivider() {
    return SliverToBoxAdapter(
      child: Column(children: [8.height, Divider(), 8.height]),
    );
  }
}
