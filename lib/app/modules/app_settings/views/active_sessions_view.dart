import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/asset_icon_container.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/modules/app_settings/models/active_device_model.dart';
import 'package:icon/generated/assets.dart';

class ActiveSessionsView extends BaseView<AppSettingsController> {
  const ActiveSessionsView({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionPill(onTap: () => Get.back())),
      ),
      title: Text('Active devices'),
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
            'Active devices',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ), //16px, semi bold, black

          8.height,
          Text(
            'Manage devices and sessions accessing your account',
            style: AppTextTheme.bodyLargeRegular,
          ), // 14px, regular, secondary text color

          16.height,
          Obx(
            () => Column(
              children: controller.activeDeviceList.map((device) {
                return _buildDeviceCard(device, context);
              }).toList(),
            ),
          ),
          16.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? AppColors.darkShapeColor
                  : AppColors.lightWarningColorBG,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(Assets.appSettingsWarningIcon),
                8.width,
                Expanded(
                  child: Text(
                    'You can link up to 3 devices with your account. currently using ${controller.activeDeviceList.length} of 3.', //14px, medium, black

                    style: AppTextTheme.bodyLargeMedium.copyWith(
                      color: ThemeHelpers.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.height,
          LoadingButton(onPressed: () {}, label: 'Upgrade plan'),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(ActiveDevice device, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AssetIconContainer(
                  width: 28,
                  height: 28,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  iconPath: device.deviceType == DeviceTypeEnum.mobile
                      ? Assets.appSettingsMobileIcon
                      : Assets.appSettingsLaptopIcon,
                  shape: BoxShape.rectangle,
                ),
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          device.deviceName, //14px, semi bold, black
                          style: AppTextTheme.bodyLargeSemiBold.copyWith(
                            color: ThemeHelpers.primaryTextColor,
                          ),
                        ),
                      ),
                      8.width,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                device.sessionStatus == SessionStatusEnum.active
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            device.sessionStatus.status, //12px, medium
                            style: AppTextTheme.bodySmallMedium.copyWith(
                              color:
                                  device.sessionStatus ==
                                      SessionStatusEnum.active
                                  ? Colors.green
                                  : AppColors.lightHintTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Text(
                    device.osType.os, //14px, regular, secondary text color
                    style: AppTextTheme.bodyLargeRegular.copyWith(
                      color: ThemeHelpers.secondaryTextColor,
                    ),
                  ),
                  8.height,
                  Text(
                    'Last active: ${_formatLastActive(device.lastActive)}', //12px, medium, secondary text color
                    style: AppTextTheme.bodySmallMedium.copyWith(
                      color: ThemeHelpers.secondaryTextColor,
                    ),
                  ),
                ],
              ),

              // 6.width,
              Spacer(),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => controller.removeDevice(device),
                      child: Text(
                        'Remove',
                        style: AppTextTheme.bodyLargeMedium.copyWith(
                          color: AppColors.colorPrimary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastActive(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }
}
