import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';
import 'package:icon/generated/assets.dart';

class ConfirmAccountDeleteWidget extends BaseView<AppSettingsController> {
  const ConfirmAccountDeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelpers.warningBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.redProgressColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Account Deletion', //16px, semi bold, black
              style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),
            ),
            8.height,
            Text(
              'To confirm, please type "DELETE" in the field below:', //14px, regular, secondary text color
              style: AppTextTheme.bodyMediumRegular.copyWith(
                color: ThemeHelpers.secondaryTextColor,
              ),
            ),
            16.height,
            TextField(
              onChanged: (value) => controller.updateDeleteConfirmation(value),
              decoration: InputDecoration(
                hintText: 'Type "DELETE" here', //14px, regular
                hintStyle: AppTextTheme.bodyLargeRegular.copyWith(
                  color: AppColors.warningColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: ThemeHelpers.secondaryTextColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.redProgressColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            16.height,
            InkWell(
              onTap: () => controller.toggleDeleteAccountAcknowledgment(),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(
                      controller.deleteAccountAcknowledged.value
                          ? Assets.appSettingsExportCheck
                          : Assets.appSettingsExportUncheck,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        controller.deleteAccountAcknowledged.value
                            ? AppColors.warningColor
                            : ThemeHelpers.primaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: Text(
                      'I understand that this action will permanently delete all my data', //12px, medium
                      style: AppTextTheme.bodyMediumRegular.copyWith(
                        color: ThemeHelpers.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.height,
            LoadingButton(
              onPressed: controller.canDeleteAccount.value
                  ? () {
                      showDeleteAccountDialogue(context);
                    }
                  : null,
              label: 'Delete My Account', //14px, semi bold
              textStyle: AppTextTheme.bodyLargeSemiBold,
              backgroundColor: AppColors.warningColor,
              textColor: Colors.white,
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteAccountDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeHelpers.cardColorWhite,
          icon: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeHelpers.cardColorWhite,
            ),
            child: Center(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeHelpers.warningBgColor,
                ),
                child: Center(
                  child: Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeHelpers.warningBgColor,
                    ),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeHelpers.warningBgColor,
                        ),
                        child: Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeHelpers.cardColorWhite,
                            ),
                            child: Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ThemeHelpers.warningBgColor,
                                ),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeHelpers.cardColorWhite,
                                  ),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ThemeHelpers.warningBgColor,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.svgDeleteDialoguleIcon,
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            'Are you absolutely sure?',
            style: AppTextTheme.headlineMediumSemiBold.copyWith(
              color: ThemeHelpers.primaryTextColor,
            ),
          ),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  "This will permanently delete your account and remove all your data from our servers. you have 3D days to cancel this action by contacting support",
                  style: AppTextTheme.bodyLargeRegular,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ), //14px, regular
          actions: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ThemeHelpers.cardColorWhite,
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextTheme.titleSmallSemiBold.copyWith(
                          color: ThemeHelpers.primaryTextColor,
                        ),
                        // 16px, semi bold, black
                      ),
                    ),
                  ),
                ),
                16.width,
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.warningColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Show loading and perform account deletion
                        Get.dialog(
                          const AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 16),
                                Text('Deleting your account...'),
                              ],
                            ),
                          ),
                          barrierDismissible: false,
                        );

                        // Perform actual account deletion
                        controller.deleteAccount().then((success) {
                          Get.back(); // Close loading dialog
                          if (success) {
                            Get.snackbar(
                              'Account Deleted',
                              'Your account has been permanently deleted.',
                              backgroundColor: AppColors.warningColor,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 3),
                            );
                            // Navigate to login screen and clear all routes
                            Get.offAllNamed('/login'); // Adjust route as needed
                          } else {
                            Get.snackbar(
                              'Error',
                              'Failed to delete account. Please try again.',
                              backgroundColor: AppColors.warningColor,
                              colorText: Colors.white,
                            );
                          }
                        });
                      },
                      child: Text(
                        'Delete',
                        style: AppTextTheme.titleSmallSemiBold.copyWith(
                          color: Colors.white,
                        ), //16 px, semi bold, white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
