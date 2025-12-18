import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon.dart';
import 'package:icon/app/core/widgets/super_widgets/super_icon_source.dart';

import '../../../../generated/assets.dart';
import '../../../core/enums/fav_enum.dart';
import '../../../core/widgets/fab_widgets/animated_fab.dart';
import '../../../core/widgets/fab_widgets/animated_fab_card.dart';
import '../../../core/widgets/fab_widgets/fab_card_item.dart';
import '../controllers/activity_tracker_controller.dart';

class ActivityTrackerView extends BaseView<ActivityTrackerController> {
  const ActivityTrackerView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      title: Text('Activity Tracker', style: appBarTheme.titleTextStyle),
      centerTitle: true,

      leading: Padding(
        padding: EdgeInsets.all(6),
        child: ActionButton.compact(onTap: Get.back),
      ),
    );
  }

  @override
  Widget? floatingActionButton() => AnimatedFab(
    actionType: FabActionType.activityRecoverLog,
    isOpen: controller.isOpened,
  );

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: 12.height),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Activity Log',
                                  style: textTheme.titleMedium,
                                ),
                                Text(
                                  '12 min ago',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            12.height,

                            /// Activity Card 1
                            _ActivityCard(
                              iconSource: const SuperIconSource.icon(
                                Icons.directions_run,
                              ),
                              title: "Morning Run",
                              subtitle: "Workout • 25 min • 8:10 am",
                              theme: theme,
                            ),

                            12.height,

                            /// Activity Card 2
                            _ActivityCard(
                              iconSource: SuperIconSource.svgAsset(
                                Assets.iconsUpperBody,
                              ),
                              title: "Upper Body Strength",
                              subtitle: "Cardio • 25 min • 7:30 am",
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //LogActivitySection(theme: theme, textTheme: textTheme),
          ],
        ),
        AnimatedFabCard(
          height: controller.height,
          cardContainerHeight: controller.cardContainerHeight,
          fabCards: [
            const Text(
              "Log Recovery",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            12.height,
            Row(
              spacing: 8,
              children: [
                FabCardItem(
                  title: "Workout",
                  source: SuperIconSource.imageAsset(
                    Assets.activityTrackerWorkout,
                  ),
                ),
                FabCardItem(
                  title: "Cardio",
                  source: SuperIconSource.svgAsset(Assets.iconsCardiogram),
                ),
                FabCardItem(
                  title: "Repair",
                  source: SuperIconSource.svgAsset(Assets.appSettingsRepair),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ThemeData theme;
  final SuperIconSource iconSource;

  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.iconSource,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SuperIcon(
              source: iconSource,
              size: 26,
              color: theme.textTheme.titleSmall?.color,
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                4.height,
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          SuperIcon(
            source: SuperIconSource.svgAsset(Assets.iconsArrowUpLeft),
            color: theme.iconTheme.color,
            size: 20,
          ),
        ],
      ),
    );
  }
}
