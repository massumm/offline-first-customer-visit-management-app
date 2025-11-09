import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/register/controllers/register_controller.dart';
import 'package:icon/app/routes/app_pages.dart';

class TwoFactorSuccessPageView extends BaseView<RegisterController> {
  TwoFactorSuccessPageView({super.key});

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Get.textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Success Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: theme.iconTheme.color,
              size: 80,
            ),
          ),
          40.height,

          // Success Title
          Text(
            "Email Verified!",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          16.height,

          // Success Message
          Text(
            "Your email has been successfully verified.\nYou can now log in to your account.",
            style: textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          //Login Button
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text(
              "Go to Login",
            ),
          ),
          20.height,
        ],
      ),
    );
  }
}
