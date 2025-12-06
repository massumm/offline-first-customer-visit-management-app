import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/app_settings/widgets/switch_button_selector.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class PrivacyView extends BaseView<AppSettingsController> {
  const PrivacyView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionPill(onTap: () => Get.back())),
      ),
      title: Text('Privacy'),
      centerTitle: true,
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
                    'Privacy',
                    style: AppTextTheme.titleSmallSemiBold.copyWith(
                      color: ThemeHelpers.primaryTextColor,
                    ),
                  ), //16px, semi bold, black

                  8.height,
                  Text(
                    'Control what information is visible and shared',
                    style: AppTextTheme.bodyLargeRegular,
                  ), // 14px, regular, secondary text color

                  16.height,

                  DisplayOptionsSelector(
                    title: 'Profile visibility',
                    description:
                        'Manage who can see your profile and activities',
                    options: [
                      SwitchButtonSelector(
                        title: 'Public profile',
                        subtitle: 'Allow others to view your profile',
                        hasSwitch: true,
                        switchValue: controller.tempPublicProfile,
                        onChanged: (value) {
                          controller.tempPublicProfile.value = value;
                        },
                      ),
                      SwitchButtonSelector(
                        title: 'Show activities',
                        subtitle: 'Display your workouts publicly',
                        hasSwitch: true,
                        switchValue: controller.tempShowActivities,
                        onChanged: (value) {
                          controller.tempShowActivities.value = value;
                        },
                      ),
                      SwitchButtonSelector(
                        title: 'Show statistics',
                        subtitle: 'Share your fitness statistics',
                        hasSwitch: true,
                        switchValue: controller.tempShowStatistics,
                        onChanged: (value) {
                          controller.tempShowStatistics.value = value;
                        },
                      ),
                    ],
                  ),

                  16.height,

                  DisplayOptionsSelector(
                    title: 'Communication',
                    description: 'Control how others can contact you',
                    options: [
                      SwitchButtonSelector(
                        title: 'Allow messages',
                        subtitle: 'Let other users send you messages',
                        hasSwitch: true,
                        switchValue: controller.tempAllowMessages,
                        onChanged: (value) {
                          controller.tempAllowMessages.value = value;
                        },
                      ),
                    ],
                  ),

                  16.height,

                  DisplayOptionsSelector(
                    title: 'Data & Location',
                    description: 'Manage location and data sharing preferences',
                    options: [
                      SwitchButtonSelector(
                        title: 'Share location data',
                        subtitle: 'Allow location tracking for workouts',
                        hasSwitch: true,
                        switchValue: controller.tempShareLocationData,
                        onChanged: (value) {
                          controller.tempShareLocationData.value = value;
                        },
                      ),
                      SwitchButtonSelector(
                        title: 'Analytics data',
                        subtitle: 'Help improve the app with usage data',
                        hasSwitch: true,
                        switchValue: controller.tempAnalyticsData,
                        onChanged: (value) {
                          controller.tempAnalyticsData.value = value;
                        },
                      ),
                    ],
                  ),
                  16.height,
                ],
              ),
            ),
          ),
          16.height,
          LoadingButton(onPressed: () {}, label: 'Save Privacy Settings'),
        ],
      ),
    );
  }
}
