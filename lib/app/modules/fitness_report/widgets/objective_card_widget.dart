import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

class ObjectiveCardWidget extends StatelessWidget {
  final String? assetPath;
  final String title;
  final String description;
  final Color? bgColor;
  final Color? titleColor;

  const ObjectiveCardWidget({
    super.key,
    this.assetPath,
    required this.title,
    required this.description,
    this.bgColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: Get.width * 0.45,
      height: Get.height * 0.25,
      decoration: BoxDecoration(
        color: bgColor ?? Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetPath != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? AppColors.iconBgColorDark
                    : AppColors.iconBgColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(assetPath!),
            ),
          if (assetPath != null) 8.height,
          Text(
            title,
            style: Get.textTheme.bodySmall?.copyWith(
              color: titleColor,
            ),
          ),
          8.height,
          Text(
            description,
            maxLines: null,
            overflow: TextOverflow.visible,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
