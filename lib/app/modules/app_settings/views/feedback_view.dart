import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/loading_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/app_settings/widgets/radio_button_selector.dart';
import 'package:icon/app/modules/app_settings/widgets/feedback_widget.dart';
import 'package:icon/app/modules/app_settings/widgets/what_happens_next_widget.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class FeedbackView extends BaseView<AppSettingsController> {
  const FeedbackView({super.key});
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('Feedback'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedback',
              style: AppTextTheme.titleSmallSemiBold.copyWith(
                color: ThemeHelpers.primaryTextColor,
              ),
            ), //16px, semi bold, black

            8.height,
            Text(
              'Submit issues or share your feature ideas',
              style: AppTextTheme.bodyLargeRegular,
            ), // 14px, regular, secondary text color

            16.height,
            RadioButtonSelector(
              textSizeList: controller.feedbackTypeList,
              selectedTextSize: controller.selectedFeedbackType,
              title: 'What type of feedback do you have?',
              description: 'Help us categorize your feedback',
            ),
            16.height,
            FeedBackWidget(),
            16.height,
            LoadingButton(onPressed: () {}, label: 'Submit feedback'),
            16.height,
            WhatHappensNextWidget(),
          ],
        ),
      ),
    );
  }
}
