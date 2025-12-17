import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_button.dart';
import 'package:icon/app/core/widgets/input_widgets/adaptive_text_field.dart';
import 'package:icon/app/modules/forgot_password/controllers/forgot_password_controller.dart';

class ForgotPasswordPageView extends BaseView<ForgotPasswordController> {
  const ForgotPasswordPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: Get.size.height,
          width: Get.size.width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionButton(
                  onTap: controller.currentPageIndex.value == 0
                      ? Get.back
                      : controller.gotToPreviousPage,
                ),
                controller.forgotPasswordDefaultHeight,
                Text("Forgot Password", style: Get.textTheme.titleLarge),
                10.height,
                Text(
                  "Just enter the Email address associated with your account",
                  style: Get.textTheme.bodyMedium,
                ),
                20.height,
                Text(
                  "Email",
                  style: Get.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.height,

                // Email TextField
                Obx(() {
                  return AdaptiveSuperTextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: controller.emailError.value,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (value) {
                      if (controller.emailError.value != null) {
                        controller.emailError.value = null;
                      }
                    },
                  );
                }),
                20.height,

                // Send OTP Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.isSendingOtp.value
                          ? null
                          : controller.gotToNextPage,

                      child: controller.isSendingOtp.value
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Send OTP"),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
