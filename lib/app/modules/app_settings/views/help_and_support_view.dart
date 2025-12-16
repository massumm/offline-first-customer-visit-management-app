import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/modules/app_settings/controllers/app_settings_controller.dart';
import 'package:icon/app/modules/app_settings/widgets/email_us_widget.dart';
import 'package:icon/app/modules/app_settings/widgets/faq_widget.dart';

import '../widgets/schedule_a_call_widget.dart';

class HelpAndSupportView extends BaseView<AppSettingsController> {
  const HelpAndSupportView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(child: ActionButton(onTap: () => Get.back())),
      ),
      title: Text('Help & Support'),
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
            ScheduleACallWidget(),
            16.height,
            EmailUsWidget(),
            16.height,
            FaqWidget(),
          ],
        ),
      ),
    );
  }
}
