import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/models/wearable_device.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/integration_icon_container.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class AppIntegrationView extends BaseView<AppSettingsController> {
  const AppIntegrationView({super.key});

  static final deviceList = [
    const WearableDevice(
      icon: Assets.imagesApple,
      title: 'Apple Watch',
      connectionStatus: 'Connected',
      iconColor: 'FFEFEFEF',
      description: 'Sync workouts, heart rate, and activity data',
    ),
    const WearableDevice(
      icon: Assets.imagesFitbit,
      title: 'Fitbit',
      connectionStatus: 'Not Connected',
      iconColor: 'FFE9FEFF',
      description: 'Import steps, sleep, ard exercise data from fitbit',
    ),
    const WearableDevice(
      icon: Assets.imagesGoogle,
      title: 'Google',
      connectionStatus: 'Connected',
      iconColor: 'FFE6FFEF',
      description: "Connect your google fit activities ard health data",
    ),
    const WearableDevice(
      icon: Assets.imagesGarmin,
      title: 'Garmin',
      connectionStatus: 'Not Connected',
      iconColor: 'FFDFF2FF',
      description: 'Sync with your garmin devices',
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
      title: Text('App integrations'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App integrations',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ), //16px, semi bold, black

          8.height,
          Text(
            'Connect with your favorite health and fitness apps',
            style: AppTextTheme.bodyLargeRegular,
          ), // 14px, regular, secondary text color

          16.height,
          ...deviceList.map((device) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: ThemeHelpers.primaryCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.transparent),
              ),
              child: ListTile(
                leading: IntegrationIconContainer(
                  icon: device.icon,
                  iconColor: device.iconColor,
                ),
                title: Text(
                  device.title,
                  style: AppTextTheme.bodyLargeSemiBold.copyWith(
                    color: ThemeHelpers.primaryTextColor,
                  ),
                ), //14px, semi bold, black
                subtitle: Text(
                  device.description ?? '',
                  style: AppTextTheme.bodyLargeRegular.copyWith(
                    color: ThemeHelpers.secondaryTextColor,
                  ),
                ), //14px, regular, secondary text color
                trailing: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: device.connectionStatus == 'Connected'
                          ? Colors.white
                          : AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: device.connectionStatus == 'Connected'
                            ? AppColors.lightStockColor
                            : Colors.transparent,
                      ),
                    ),
                    width: 120,
                    child: Text(
                      device.connectionStatus == 'Connected'
                          ? 'Disconnect'
                          : 'Connect',
                      style: AppTextTheme.bodyLargeRegular.copyWith(
                        color: device.connectionStatus == 'Connected'
                            ? Colors.black
                            : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ), //14px, regular, white
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
