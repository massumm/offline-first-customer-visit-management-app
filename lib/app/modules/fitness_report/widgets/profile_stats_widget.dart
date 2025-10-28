import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class ProfileStatsWidget extends StatelessWidget {
  const ProfileStatsWidget({
    super.key,
    required this.title,
    required this.stats,
    this.dividerColor = const Color(0xFFE8E4E2),
  });

  final String title;
  final List<StatItem> stats;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          4.height,
          ...List.generate(
            stats.length,
            (index) => Column(
              children: [
                12.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stats[index].label,
                      style: Get.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stats[index].value,
                      style: Get.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                if (index < stats.length - 1) ...[
                  8.height,
                  Divider(height: 1, color: dividerColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatItem {
  final String label;
  final String value;

  StatItem({required this.label, required this.value});
}
