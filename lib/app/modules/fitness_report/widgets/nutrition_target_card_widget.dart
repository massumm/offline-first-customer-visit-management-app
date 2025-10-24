import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class NutritionTargetCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;

  const NutritionTargetCardWidget({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          8.height,
          Text(
            value,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            4.height,
            Text(
              subtitle!,
              style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
