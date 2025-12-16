import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class WhatHappensNextWidget extends BaseView<AppSettingsController> {
  const WhatHappensNextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.warningBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // What happens next?
          // Our team reviews all feedback submissions -> ul icon
          // You'll receive an email confirmation of your submission -> ul icon
          // Popular requests are prioritized in our development roadmap -> ul icon
          // may reach out for additional information if needed -> ul icon
          Text(
            'What happens next?',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: AppColors.informationColor,
            ),
          ), //16px, semi bold, black

          16.height,
          _buildListItem('Our team reviews all feedback submissions'),
          16.height,
          _buildListItem(
            'You\'ll receive an email confirmation of your submission',
          ),
          16.height,
          _buildListItem(
            'Popular requests are prioritized in our development roadmap',
          ),
          16.height,
          _buildListItem(
            'We may reach out for additional information if needed',
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String subtitle) {
    return Row(
      children: [
        Center(
          child: SvgPicture.asset(
            Assets.appSettingsWarningUlIcon,
            width: 20,
            height: 20,
          ),
        ),
        12.width,
        Expanded(
          child: Text(
            subtitle, //14px regular, black
            style: AppTextTheme.bodyLargeRegular.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
