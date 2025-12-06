import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class FeedBackWidget extends BaseView<AppSettingsController> {
  const FeedBackWidget({super.key});

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
          Text(
            'Tell us more',
            style: AppTextTheme.titleSmallSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ), //16px, semi bold, black

          8.height,
          Text(
            'Provide details about your feedback',
            style: AppTextTheme.bodyLargeRegular,
          ), // 14px, regular, secondary text color

          16.height,
          Text(
            'Title',
            style: AppTextTheme.bodyLargeRegular.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          8.height,
          TextField(
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Brief summary of your feedback',
              hintStyle: AppTextTheme.bodyLargeRegular.copyWith(
                color: ThemeHelpers.secondaryTextColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.colorPrimary),
              ),
            ),
          ),
          16.height,
          Text(
            'Description',
            style: AppTextTheme.bodyLargeRegular.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          8.height,
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Provide as much detail as possible.',
              hintStyle: AppTextTheme.bodyLargeRegular.copyWith(
                color: ThemeHelpers.secondaryTextColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.colorPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
