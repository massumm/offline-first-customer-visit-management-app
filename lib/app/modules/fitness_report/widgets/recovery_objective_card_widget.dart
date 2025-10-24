import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class RecoveryObjectiveCardWidget extends StatelessWidget {
  final String assetPath;
  final String title;
  final String description;

  const RecoveryObjectiveCardWidget({
    super.key,
    required this.assetPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: Get.width * 0.45,
      height: Get.height * 0.25,
      decoration: BoxDecoration(
        color: Get.theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(assetPath),
          8.height,
          Text(title, style: Get.textTheme.bodySmall),
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
