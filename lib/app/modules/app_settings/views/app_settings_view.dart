import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/asset_icon_container.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/app_settings_controller.dart';
import '../models/settings_model.dart';

class AppSettingsView extends BaseView<AppSettingsController> {
  const AppSettingsView({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionPill(onTap: () => Get.back())),
      ),
      title: Text('App Settings'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    final settingsList = [
      SettingsModel(
        title: "Region & Languages",
        subtitle: "Set time zone and language",
        iconPath: Assets.appSettingsRegionAndLanguage,
        onTap: () => Get.toNamed(Routes.REGION_AND_LANGUAGE),
      ),
      SettingsModel(
        title: "Units & Preferences",
        subtitle: "Change units and preferences",
        iconPath: Assets.appSettingsUnitsAndPreference,
        onTap: () => Get.toNamed(Routes.UNITS_AND_PREFERRENCES),
      ),
      SettingsModel(
        title: "Accessibility",
        subtitle: "Adjust text size and display",
        iconPath: Assets.appSettingsAccessibility,
        onTap: () => Get.toNamed(Routes.ACCESSIBILITY),
      ),
      SettingsModel(
        title: "Two-factor authentication",
        subtitle: "Add an Extra Layer of Security",
        iconPath: Assets.appSettingsTwoFactorAuthentication,
        onTap: () => Get.toNamed(Routes.TWO_FACTOR_AUTHENTICATION),
      ),
      SettingsModel(
        title: "App integrations",
        subtitle: "Manage health app connections",
        iconPath: Assets.appSettingsAppIntegration,
        onTap: () => Get.toNamed(Routes.APP_INTEGRATION),
      ),
      SettingsModel(
        title: "Active sessions",
        subtitle: "View devices and sessions",
        iconPath: Assets.appSettingsActiveSessions,
        onTap: () => Get.toNamed(Routes.ACTIVE_SESSIONS),
      ),
      SettingsModel(
        title: "Feedback",
        subtitle: "Submit issues or ideas",
        iconPath: Assets.appSettingsFeedback,
        onTap: () => Get.toNamed(Routes.FEEDBACK),
      ),
      SettingsModel(
        title: "Privacy",
        subtitle: "Control what info is shared",
        iconPath: Assets.appSettingsPrivacy,
        onTap: () => Get.toNamed(Routes.PRIVACY),
      ),
      SettingsModel(
        title: "Help & Support",
        subtitle: "Connect with support team",
        iconPath: Assets.appSettingsHelpAndSupport,
        onTap: () => Get.toNamed(Routes.HELP_AND_SUPPORT),
      ),
      SettingsModel(
        title: "Export data",
        subtitle: "Download your personal data",
        iconPath: Assets.appSettingsExportData,
        onTap: () => Get.toNamed(Routes.EXPORT_DATA),
      ),
      SettingsModel(
        title: "Delete account",
        subtitle: "Permanently delete account",
        iconPath: Assets.appSettingsDeleteAccount,
        onTap: () => Get.toNamed(Routes.DELETE_ACCOUNT),
      ),
    ];

    return ListView.builder(
      itemCount: settingsList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final setting = settingsList[index];
        return Container(
          decoration: BoxDecoration(
            color: ThemeHelpers.cardColorWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: AssetIconContainer(iconPath: setting.iconPath),
            title: Text(
              setting.title,
              style: AppTextTheme.bodyLargeSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),
            ),
            subtitle: Text(
              setting.subtitle,
              style: AppTextTheme.bodyMediumRegular.copyWith(
                color: ThemeHelpers.secondaryTextColor,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: setting.onTap,
          ),
        );
      },
    );
  }
}
