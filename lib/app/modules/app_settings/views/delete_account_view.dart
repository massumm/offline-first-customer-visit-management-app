import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/app_settings/widgets/confirm_account_delete_widget.dart';
import 'package:icon/app/modules/app_settings/widgets/warning_widget.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class DeleteAccountView extends BaseView<AppSettingsController> {
  const DeleteAccountView({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('Delete Account'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accessibility',
              style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),
            ), //16px, semi bold, black

            8.height,
            Text(
              'Adjust text size and display options for better readability',
              style: AppTextTheme.bodyLargeRegular,
            ),

            16.height,
            WarningWidget(),
            16.height,
            ConfirmAccountDeleteWidget(),
          ],
        ),
      ),
    );
  }
}
