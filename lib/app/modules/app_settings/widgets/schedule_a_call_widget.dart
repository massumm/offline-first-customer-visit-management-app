import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class ScheduleACallWidget extends BaseView<AppSettingsController> {
  const ScheduleACallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeHelpers.cardColorWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        Assets.appSettingsSupportYou,
                        width: 90,
                        height: 90,
                      ),
                    ),
                    // 8.width,
                    Expanded(
                      child: Image.asset(
                        Assets.appSettingsSupportMish,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          16.height,
          Center(
            child: SizedBox(
              width: 300,
              child: Text(
                "We're here for you. If you'd like assistance, please book a time with us.",
                style: AppTextTheme.bodyLargeMedium.copyWith(
                  color: ThemeHelpers.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          16.height,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Schedule Now',
                style: AppTextTheme.bodyLargeSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
