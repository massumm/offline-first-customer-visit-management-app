import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class UnitsAndPreferencesView extends BaseView<AppSettingsController> {
  const UnitsAndPreferencesView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionPill(onTap: () => Get.back())),
      ),
      title: Text('Units & Preferences'),
      centerTitle: true,
    );
  }

  Widget _buildUnitSettingsCard({
    required String title,
    required String description,
    required RxString selectedValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.primaryCardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, //14px, semi bold, black
            style: AppTextTheme.bodyLargeSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          8.height,
          Text(
            description, //12px, medium, secondary text color
            style: AppTextTheme.bodyMediumMedium.copyWith(
              color: ThemeHelpers.secondaryTextColor,
            ),
          ),
          16.height,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            decoration: BoxDecoration(
              color: ThemeHelpers.primaryCardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Obx(
              () => Column(
                children: items.map((item) {
                  return RadioListTile<String>(
                    value: item,
                    groupValue: selectedValue.value,
                    onChanged: (value) {
                      onChanged(value);
                    },
                    title: Text(
                      item,
                      style: AppTextTheme.bodyLargeRegular.copyWith(
                        color: item == selectedValue.value
                            ? AppColors.colorPrimary
                            : ThemeHelpers.primaryTextColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Units & Preferences',
                    style: AppTextTheme.titleSmallSemiBold.copyWith(
                      color: ThemeHelpers.primaryTextColor,
                    ),
                  ),
                  8.height,
                  Text(
                    'Customize measurement units and display preferences',
                    style: AppTextTheme.bodyLargeRegular.copyWith(
                      color: ThemeHelpers.secondaryTextColor,
                    ),
                  ),

                  16.height,

                  ...controller.unitSettings.map((unitSetting) {
                    return Column(
                      children: [
                        _buildUnitSettingsCard(
                          title: unitSetting.title,
                          description: unitSetting.description,
                          selectedValue: unitSetting.selectedValue,
                          items: unitSetting.items,
                          onChanged: (value) {
                            unitSetting.selectedValue.value = value!;
                          },
                        ),
                        16.height,
                      ],
                    );
                  }),

                  16.height,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ThemeHelpers.primaryCardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'Time & Date format',
                            style: AppTextTheme.bodyLargeSemiBold.copyWith(
                              color: ThemeHelpers.primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Customize how time and dates are displayed',
                            style: AppTextTheme.bodyMediumRegular.copyWith(
                              color: ThemeHelpers.secondaryTextColor,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          title: Text(
                            '24-Hour time format',
                            style: AppTextTheme.bodyLargeSemiBold.copyWith(
                              color: ThemeHelpers.primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Display time in 24-hour format',
                            style: AppTextTheme.bodyMediumRegular.copyWith(
                              color: ThemeHelpers.secondaryTextColor,
                            ),
                          ),
                          trailing: Obx(
                            () => Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: controller.tempIs24HourFormat.value,
                                onChanged: (value) {
                                  controller.tempIs24HourFormat.value = value;
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          title: Text(
                            'Start week on Monday',
                            style: AppTextTheme.bodyLargeSemiBold.copyWith(
                              color: ThemeHelpers.primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            'Calendars will start on Monday',
                            style: AppTextTheme.bodyMediumRegular.copyWith(
                              color: ThemeHelpers.secondaryTextColor,
                            ),
                          ),
                          trailing: Obx(
                            () => Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: controller.tempIsWeekStartMonday.value,
                                onChanged: (value) {
                                  controller.tempIsWeekStartMonday.value =
                                      value;
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          16.height,
          LoadingButton(
            onPressed: () => controller.savePreferences(),
            label: 'Save Preferences',
          ),
        ],
      ),
    );
  }
}
