import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Activity Log', style: textTheme.titleMedium),
                      Text(
                        '12 min ago',
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                      )
                    ],
                  ),
                  8.height,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedLiftTruck,
                        color: colorScheme.primary,
                        size: 30.0,
                      ),
                    ),
                    title: const Text('Morning Run'),
                    subtitle: const Text('Workout - 25 min - 7:30 pm'),
                    trailing: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowUpRight01,
                      color: theme.iconTheme.color,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
