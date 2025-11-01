import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

class StrategySectionWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final List<dynamic>? cardItems;
  final String? tagSectionTitle;
  final List<String>? tagItems;
  final Widget Function(dynamic) cardBuilder;
  final double? childAspectRatio;

  const StrategySectionWidget({
    super.key,
    this.title,
    this.description,
    this.cardItems,
    required this.cardBuilder,
    this.tagSectionTitle,
    this.tagItems,
    this.childAspectRatio,
  });

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
          if (title != null) ...[
            Text(
              title!,
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
          ],
          if (description != null) ...[
            Text(description!, style: Get.textTheme.bodyMedium),
            8.height,
          ],
          if (cardItems != null) ...[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: childAspectRatio ?? 1.3,
              children: cardItems!.map(cardBuilder).toList(),
            ),
            16.height,
          ],
          if (tagSectionTitle != null && tagItems != null) ...[
            SizedBox(height: 0, width: double.infinity),
            Text(
              tagSectionTitle!,
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            Wrap(
              children: tagItems!
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : AppColors.iconBgColorLight,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Get.theme.primaryColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
