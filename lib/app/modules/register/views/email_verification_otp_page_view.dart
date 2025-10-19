import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/input_widgets/otp_digit_field.dart';
import 'package:icon/app/modules/register/controllers/register_controller.dart';

class EmailVerificationOtpPageView extends BaseView<RegisterController> {
  EmailVerificationOtpPageView({super.key});

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
                BackPill(onTap: Get.back),
                60.height,
                Text("Enter OTP Code", style: Get.textTheme.titleLarge),
                10.height,
                Text(
                  "We just sent you an Email with 6-digit code. Please enter it below to verify your email.",
                  style: Get.textTheme.bodyMedium,
                ),
                40.height,

                // OTP Input Fields
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Obx(() {
                      final error = controller.emailOtpError.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OtpDigitField(
                              controller: controller.otp1Controller,
                              focusNode: controller.otp1FocusNode,
                              autoFocus: true,
                              errorText: error,
                              isFirst: true,
                              onChanged: (_) =>
                                  controller.emailOtpError.value = null,
                            ),
                          ),
                          8.width,
                          Expanded(
                            child: OtpDigitField(
                              controller: controller.otp2Controller,
                              focusNode: controller.otp2FocusNode,
                              errorText: error,
                              onChanged: (_) =>
                                  controller.emailOtpError.value = null,
                            ),
                          ),
                          8.width,
                          Expanded(
                            child: OtpDigitField(
                              controller: controller.otp3Controller,
                              focusNode: controller.otp3FocusNode,
                              errorText: error,
                              onChanged: (_) =>
                                  controller.emailOtpError.value = null,
                            ),
                          ),
                          8.width,
                          Expanded(
                            child: OtpDigitField(
                              controller: controller.otp4Controller,
                              focusNode: controller.otp4FocusNode,
                              errorText: error,
                              onChanged: (_) =>
                                  controller.emailOtpError.value = null,
                            ),
                          ),
                          8.width,
                          Expanded(
                            child: OtpDigitField(
                              controller: controller.otp5Controller,
                              focusNode: controller.otp5FocusNode,
                              errorText: error,
                              onChanged: (_) =>
                                  controller.emailOtpError.value = null,
                            ),
                          ),
                          8.width,
                          Expanded(
                            child: OtpDigitField(
                              controller: controller.otp6Controller,
                              focusNode: controller.otp6FocusNode,
                              errorText: error,
                              isLast: true,
                              onChanged: (_) =>
                                  controller.emailOtpError.value = null,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                20.height,

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.isLoading.isTrue
                          ? null
                          : controller.verifyEmailOtp,
                      child: controller.isLoading.isTrue
                          ? const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Verify"),
                    );
                  }),
                ),
                20.height,

                // Resend OTP
                Center(
                  child: Obx(() {
                    return TextButton(
                      onPressed: controller.canResend.value
                          ? controller.resendEmailOtp
                          : null,
                      child: Text(
                        controller.canResend.value
                            ? "Didn't receive OTP? Resend"
                            : "Didn't receive OTP? Resend in ${_formatTime(controller.resendTimer.value)} sec",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: controller.canResend.value
                              ? Get.theme.primaryColor
                              : Colors.grey,
                        ),
                      ),
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
