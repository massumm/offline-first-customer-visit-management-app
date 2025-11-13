import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/generated/assets.dart';

class PasswordChangeSuccessView extends StatelessWidget {
  const PasswordChangeSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Icon
              SvgPicture.asset(
                Assets.svgPasswordSuccess,
                width: 120,
                height: 120,
              ),
              40.height,

              // Title
              Text(
                "New password confirmed successful",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              16.height,

              // Description
              Text(
                "Yau have successfully confirm your new password, Please, use your new password when logging in",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),

              // Go to Home Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to home/login page
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: const Text("Go to home"),
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
