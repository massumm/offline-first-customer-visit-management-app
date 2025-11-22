import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/asset_icon_container.dart';

class ObjectiveCardWidget extends StatelessWidget {
  final String? assetPath;
  final String title;
  final String description;
  final Color? bgColor;
  final Color? titleColor;
  final bool isCentered;

  final double? titleFontSize;
  final double? descriptionFontSize;
  final double? padding;

  const ObjectiveCardWidget({
    super.key,
    this.assetPath,
    required this.title,
    required this.description,
    this.bgColor,
    this.titleColor,
    this.isCentered = false,
    this.titleFontSize,
    this.descriptionFontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16),
      decoration: BoxDecoration(
        color: bgColor ?? Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: isCentered
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: isCentered
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (assetPath != null) AssetIconContainer(iconPath: assetPath!),
            if (assetPath != null) 8.height,
            Text(
              title,
              style: Get.textTheme.bodySmall?.copyWith(
                color: titleColor,
                fontSize: titleFontSize ?? 12.0,
              ),
            ),
            if (description.isNotEmpty) 8.height,
            if (description.isNotEmpty)
              Text(
                description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: descriptionFontSize ?? 18.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
