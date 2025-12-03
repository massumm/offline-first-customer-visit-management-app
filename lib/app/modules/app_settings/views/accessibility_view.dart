import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class TextSizeOption {
  final String title;
  final TextStyle textStyle;

  const TextSizeOption({required this.title, required this.textStyle});
}

class AccessibilityView extends BaseView<AppSettingsController> {
  const AccessibilityView({super.key});

  static final textSizeList = [
    TextSizeOption(
      title: 'Small',
      textStyle: AppTextTheme.bodyMediumRegular, //12px medium, black
    ),
    TextSizeOption(
      title: 'Medium (Default)',
      textStyle: AppTextTheme.bodyLargeRegular, //14px medium, black
    ),
    TextSizeOption(
      title: 'Large',
      textStyle: AppTextTheme.titleSmallRegular, //16px medium, black
    ),
    TextSizeOption(
      title: 'Extra Large',
      textStyle: AppTextTheme.titleMediumRegular, //18px medium, black
    ),
  ];

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionPill(onTap: () => Get.back())),
      ),
      title: Text('Accessibility'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    final selectedTextSize = "Medium (Default)".obs;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accessibility',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ), //16px, semi bold, black

          8.height,
          Text(
            'Adjust text size and display options for better readability',
            style: AppTextTheme.bodyLargeRegular,
          ), // 14px, regular, secondary text color

          16.height,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: ThemeHelpers.primaryCardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Text size',
                    style: AppTextTheme.titleSmallSemiBold.copyWith(
                      color: ThemeHelpers.primaryTextColor,
                    ),
                  ),
                ), //16px, semi bold, black
                8.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Choose a comfortable text size for reading',
                    style: AppTextTheme.bodyMediumRegular,
                  ),
                ), //12px, regular, secondary text color
                8.height,
                ...textSizeList.map((textSize) {
                  return Obx(
                    () => RadioListTile<String>(
                      value: textSize.title,
                      groupValue: selectedTextSize.value,
                      onChanged: (value) {
                        selectedTextSize.value = value!;
                      },
                      title: Text(
                        textSize.title,
                        style: selectedTextSize.value == textSize.title
                            ? textSize.textStyle.copyWith(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.w600,
                              )
                            : textSize.textStyle,
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          16.height,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: ThemeHelpers.primaryCardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Display options',
                    style: AppTextTheme.titleSmallSemiBold,
                  ), //16 px, semi bold, black
                  subtitle: Text(
                    'Customize the visual experience',
                    style: AppTextTheme.bodyMediumRegular,
                  ), //12 px, regular, secondary text color
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  title: Text(
                    'High contrast mode',
                    style: AppTextTheme.titleSmallSemiBold,
                  ),
                  subtitle: Text(
                    'Increase color contrast for better visibility',
                    style: AppTextTheme.bodyMediumRegular,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: Obx(
                    () => Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: controller.tempHighContrastMode.value,
                        onChanged: (value) {
                          controller.tempHighContrastMode.value = value;
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Reduce motion',
                    style: AppTextTheme.titleSmallSemiBold,
                  ),
                  subtitle: Text(
                    'Minimize animations and transitions',
                    style: AppTextTheme.bodyMediumRegular,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: Obx(
                    () => Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: controller.tempReduceMotion.value,
                        onChanged: (value) {
                          controller.tempReduceMotion.value = value;
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Bold text',
                    style: AppTextTheme.titleSmallSemiBold,
                  ),
                  subtitle: Text(
                    'Use heavier font weight throughout the app',
                    style: AppTextTheme.bodyMediumRegular,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: Obx(
                    () => Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: controller.tempBoldText.value,
                        onChanged: (value) {
                          controller.tempBoldText.value = value;
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          LoadingButton(onPressed: () {}, label: 'Save Preferences'),
        ],
      ),
    );
  }
}
