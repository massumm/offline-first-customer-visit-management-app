import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class RegionAndLanguageView extends BaseView<AppSettingsController> {
  const RegionAndLanguageView({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('Region & Language'),
      centerTitle: true,
    );
  }

  Widget _buildSettingsSectionCard({
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
            title,
            style: AppTextTheme.bodyLargeSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          8.height,
          Text(
            description,
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
              () => DropdownButton<String>(
                value: selectedValue.value,
                isExpanded: true,
                underline: SizedBox(),
                icon: SvgPicture.asset(
                  Assets.activityTrackerDropdownIcon,
                  colorFilter: ColorFilter.mode(
                    ThemeHelpers.primaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                // style: AppTextTheme.bodyLargeRegular.copyWith(
                //   color: ThemeHelpers.primaryTextColor,
                // ),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextTheme.bodyLargeMedium.copyWith(
                        color: ThemeHelpers.secondaryTextColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Region & Language',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          8.height,
          Text(
            'Set your timezone and language preferences',
            style: AppTextTheme.bodyLargeRegular.copyWith(
              color: ThemeHelpers.secondaryTextColor,
            ),
          ),

          16.height,

          _buildSettingsSectionCard(
            title: 'Timezone',
            description: 'Select your timezone region',
            selectedValue: controller.selectedTimezone,
            items: controller.timeZoneList,
            onChanged: (value) {
              controller.selectedTimezone.value = value!;
            },
          ),
          16.height,
          _buildSettingsSectionCard(
            title: 'Language',
            description: 'Choose your preferred language for the app interface',
            selectedValue: controller.selectedLanguage,
            items: controller.languageList,
            onChanged: (value) {
              controller.selectedLanguage.value = value!;
            },
          ),
        ],
      ),
    );
  }
}
