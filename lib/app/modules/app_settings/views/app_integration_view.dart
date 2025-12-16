import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/models/wearable_device.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_button.dart';
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
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('App integrations'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    // Initialize integration states if not already done
    if (controller.integrationConnectionStates.isEmpty) {
      controller.initializeIntegrationStates();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(
        () => Column(
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
            ...controller.integrationConnectionStates.keys.map((
              integrationName,
            ) {
              final isConnected =
                  controller.integrationConnectionStates[integrationName] ??
                  false;
              final isLoading =
                  controller.integrationLoadingStates[integrationName] ?? false;
              final device = deviceList.firstWhere(
                (d) => d.title.toLowerCase().contains(
                  integrationName.toLowerCase().split(' ')[0],
                ),
                orElse: () => deviceList.first,
              );

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
                    integrationName,
                    style: AppTextTheme.bodyLargeSemiBold.copyWith(
                      color: ThemeHelpers.primaryTextColor,
                    ),
                  ), //14px, semi bold, black
                  subtitle: Text(
                    isConnected
                        ? 'Connected and syncing'
                        : device.description ?? '',
                    style: AppTextTheme.bodyLargeRegular.copyWith(
                      color: ThemeHelpers.secondaryTextColor,
                    ),
                  ), //14px, regular, secondary text color
                  trailing: LoadingButton(
                    onPressed: isLoading
                        ? null
                        : () => controller.toggleIntegrationConnection(
                            integrationName,
                          ),
                    isLoading: isLoading,
                    label: isConnected ? 'Disconnect' : 'Connect',
                    width: 125,
                    borderColor: Get.isDarkMode
                        ? AppColors.darkStockColor
                        : Colors.transparent,
                    // height: 40,
                    borderRadius: 16,
                    backgroundColor: isConnected
                        ? Get.isDarkMode
                              ? AppColors.darkShapeColor
                              : Colors.white
                        : AppColors.colorPrimary,
                    textColor: isConnected ? Colors.black : Colors.white,
                    textStyle: AppTextTheme.bodyLargeRegular,
                    loadingColor: Colors.black,
                    loadingSize: 16,
                    loadingStrokeWidth: 2,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
