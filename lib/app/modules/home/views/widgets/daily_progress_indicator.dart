import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/values/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../../models/utils_models.dart';
import '../../widgets/progress_ring.dart';

class DailyProgressIndicators extends GetView<HomeController> {
  const DailyProgressIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => DayCard(item: controller.week[i]),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemCount: controller.week.length,
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.item});

  final DayItem item;

  @override
  Widget build(BuildContext context) {
    final isToday = item.isToday;
    final theme = Theme.of(context);


    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(16),
        border: isToday
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : Border.all(color: theme.colorScheme.surface, width: 2),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ProgressRing(
                value: item.progress,
                thickness: 4,
                trackColor: theme.colorScheme.onPrimaryContainer,
                valueColor: AppColors.redProgressColor,
                valueGradient: AppColors.redGradient,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              style: isToday
                  ? AppTextTheme.bodyLargeBold
                  : AppTextTheme.bodyMediumRegular,
            ),
            const SizedBox(height: 2),
            Text(
              '${item.date}',
              style: isToday
                  ? AppTextTheme.bodyLargeSemiBold
                  : AppTextTheme.bodyMediumSemiBold,
            ),
          ],
        ),
      ),
    );
  }
}
