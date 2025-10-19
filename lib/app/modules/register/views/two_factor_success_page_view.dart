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
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 80,
                ),
              ),
              40.height,

              // Success Title
              Text(
                "Email Verified!",
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF241814),
                ),
                textAlign: TextAlign.center,
              ),
              16.height,

              // Success Message
              Text(
                "Your email has been successfully verified.\nYou can now log in to your account.",
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF5B5B5B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Go to Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: const Text(
                    "Go to Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
