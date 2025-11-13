import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrequencyBadge extends StatelessWidget {
  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  const FrequencyBadge({
    super.key,
    required this.label,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodySmall?.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
