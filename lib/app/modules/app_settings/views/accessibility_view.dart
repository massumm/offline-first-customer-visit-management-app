import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/app_settings/models/radio_button_option.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/app_settings/widgets/radio_button_selector.dart';
import 'package:icon/app/modules/app_settings/widgets/switch_button_selector.dart';

class AccessibilityView extends BaseView<AppSettingsController> {
  const AccessibilityView({super.key});

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
          RadioButtonSelector(
            textSizeList: controller.textSizeList,
            selectedTextSize: controller.tempSelectedTextSize,
          ),
          16.height,
          DisplayOptionsSelector(
            options: [
              SwitchButtonSelector(
                title: 'High contrast mode',
                subtitle: 'Increase color contrast for better visibility',
                hasSwitch: true,
                switchValue: controller.tempHighContrastMode,
                onChanged: (value) {
                  controller.tempHighContrastMode.value = value;
                },
              ),
              SwitchButtonSelector(
                title: 'Reduce motion',
                subtitle: 'Minimize animations and transitions',
                hasSwitch: true,
                switchValue: controller.tempReduceMotion,
                onChanged: (value) {
                  controller.tempReduceMotion.value = value;
                },
              ),
              SwitchButtonSelector(
                title: 'Bold text',
                subtitle: 'Use heavier font weight throughout the app',
                hasSwitch: true,
                switchValue: controller.tempBoldText,
                onChanged: (value) {
                  controller.tempBoldText.value = value;
                },
              ),
            ],
          ),
          Spacer(),
          LoadingButton(onPressed: () {}, label: 'Save Preferences'),
        ],
      ),
    );
  }
}
