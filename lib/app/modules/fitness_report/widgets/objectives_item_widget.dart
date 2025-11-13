import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

class ObjectivesItemWidget extends StatelessWidget {
  const ObjectivesItemWidget({
    super.key,
    required this.title,
    this.icon = Icons.check,
    this.iconColor = AppColors.positiveBorderColor,
    this.backgroundColor,
    this.borderColor = AppColors.positiveBorderColor,
  });

  final titleFontSize = 14.0;

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        8.width,
        Expanded(
          child: Text(
            title,
            maxLines: null,
            overflow: TextOverflow.visible,
            style: Get.textTheme.bodySmall?.copyWith(
              color: borderColor,
              fontSize: titleFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
