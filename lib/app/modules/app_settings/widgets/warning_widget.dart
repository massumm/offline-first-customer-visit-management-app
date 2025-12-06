import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.cardColorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Warning: ', //16px, semi bold, yellow
                        style: AppTextTheme.bodyLargeSemiBold.copyWith(
                          color: AppColors.informationColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            'This action cannot be undone', //16px, semi bold, black
                        style: AppTextTheme.bodyLargeSemiBold.copyWith(
                          color: ThemeHelpers.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                4.height,
                Text(
                  'Deleting your account will remove ail your data from our servers.',
                  style: AppTextTheme.bodyLargeRegular.copyWith(
                    //14px, regular
                    color: ThemeHelpers.secondaryTextColor,
                  ),
                ),
                16.height,
                _whatWillBeDeletedWidget(),
                16.height,
                _beforeYouProceedWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _whatWillBeDeletedWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.warningColor,

        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What will be deleted:', //14px, semi bold, black
            style: AppTextTheme.bodyLargeSemiBold.copyWith(
              color: AppColors.warningColor,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.warningColor,
            ),
          ),
          12.height,
          _buildDeletionItem('Your profile and account information'),
          _buildDeletionItem('All workout history and activity data'),
          _buildDeletionItem('Progress photos and measurements'),
          _buildDeletionItem('Goals, achievements, and badges'),
          _buildDeletionItem('App integrations and connections'),
        ],
      ),
    );
  }

  Widget _buildDeletionItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.appSettingsWarningUlIcon,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              AppColors.warningColor,
              BlendMode.srcIn,
            ),
          ),

          8.width,
          Expanded(
            child: Text(
              item,
              style: AppTextTheme.bodyLargeRegular.copyWith(
                color: AppColors.warningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _beforeYouProceedWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.informationColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Before you proceed:', //14px, semi bold, black
            style: AppTextTheme.bodyLargeSemiBold.copyWith(
              color: AppColors.informationColor,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.informationColor,
            ),
          ),
          12.height,
          // Export your data if you wart to keep a copy
          // Cancel any active subscriptions
          // Note that this action has a 30-day grace period
          _buildWarningItem('Export your data if you want to keep a copy'),
          8.height,
          _buildWarningItem('Cancel any active subscriptions'),
          8.height,
          _buildWarningItem('Note that this action has a 30-day grace period'),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              Assets.appSettingsWarningUlIcon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                AppColors.informationColor,
                BlendMode.srcIn,
              ),
            ),
            8.width,
            Expanded(
              child: Text(
                description,
                style: AppTextTheme.bodyLargeRegular.copyWith(
                  color: ThemeHelpers.secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
