import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class SelectDataToExportWidget extends BaseView<AppSettingsController> {
  const SelectDataToExportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    // Initialize export selection states
    controller.initializeExportSelectionStates();

    // Profile information
    // Personal details, settings, and preferences

    // Workout history
    // All your logged workouts and activities

    // Nutrition data
    // Meal logs and dietary information

    // Body measurements
    // Weight body composition, and other metrics

    // Goals & Progress
    // Your fitness goals and tracking data

    // Achievements & Badges
    // Earned achievements and milestones
    final exportCategories = [
      {
        "title": "Profile information",
        "description": "Personal details, settings, and preferences",
        "icon": Assets.appSettingsExportUncheck,
      },
      {
        "title": "Workout history",
        "description": "All your logged workouts and activities",
        "icon": Assets.appSettingsWarningUlIcon,
      },
      {
        "title": "Nutrition data",
        "description": "Meal logs and dietary information",
        "icon": Assets.appSettingsWarningUlIcon,
      },
      {
        "title": "Body measurements",
        "description": "Weight body composition, and other metrics",
        "icon": Assets.appSettingsWarningUlIcon,
      },
      {
        "title": "Goals & Progress",
        "description": "Your fitness goals and tracking data",
        "icon": Assets.appSettingsWarningUlIcon,
      },
      {
        "title": "Achievements & Badges",
        "description": "Earned achievements and milestones",
        "icon": Assets.appSettingsWarningUlIcon,
      },
    ];

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelpers.cardColorWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Data to Export', //16px, semi bold, black
                  style: AppTextTheme.titleSmallSemiBold.copyWith(
                    color: ThemeHelpers.primaryTextColor,
                  ),
                ),
                InkWell(
                  onTap: () => controller.toggleAllExportSelections(),
                  child: Text(
                    controller.allExportSelected.value
                        ? 'Deselect All'
                        : 'Select All',
                    style: AppTextTheme.bodyMediumRegular.copyWith(
                      color: AppColors.colorPrimary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            8.height,
            Text(
              'Choose which data you want to include in your export', //14px, medium, secondary text color
              style: AppTextTheme.bodyMediumRegular.copyWith(
                color: ThemeHelpers.secondaryTextColor,
              ),
            ), //14px, medium, secondary text color
            16.height,
            ...exportCategories.asMap().entries.map(
              (entry) => Column(
                children: [
                  _buildExportCategoryItem(
                    entry.value["title"] ?? "",
                    entry.value["description"] ?? "",
                    entry.value["icon"] ?? "",
                    entry.key,
                    controller.exportSelectionStates[entry.key],
                  ),
                  if (entry.key != exportCategories.length - 1) 8.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportCategoryItem(
    String title,
    String description,
    String icon,
    int index,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: !isSelected
            ? ThemeHelpers.cardColorGrey2
            : Get.isDarkMode
            ? AppColors.black
            : AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.colorPrimary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => controller.toggleExportSelection(index),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Center(
              child: SvgPicture.asset(
                isSelected
                    ? Assets.appSettingsExportCheck
                    : Assets.appSettingsExportUncheck,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? AppColors.colorPrimary
                      : ThemeHelpers.primaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextTheme.bodyLargeMedium.copyWith(
                      color: ThemeHelpers.primaryTextColor,
                    ),
                  ),
                  4.height,
                  Text(
                    description,
                    style: AppTextTheme.bodySmallRegular.copyWith(
                      color: ThemeHelpers.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
