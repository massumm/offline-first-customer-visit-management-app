import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../core/widgets/action_pill.dart';
import '../../../core/widgets/input_widgets/otp_digit_field.dart';
import '../controllers/otp_validation_controller.dart';

class OtpValidationView extends BaseView<OtpValidationController> {
  const OtpValidationView({super.key});

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionPill(onTap: Get.back),
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OtpDigitField(
                        controller: controller.otp1Controller,
                        focusNode: controller.otp1FocusNode,
                        autoFocus: true,
                        errorText: null,
                        isFirst: true,
                        onChanged: (_) => controller.emailOtpError.value = null,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: OtpDigitField(
                        controller: controller.otp2Controller,
                        focusNode: controller.otp2FocusNode,
                        errorText: null,
                        onChanged: (_) => controller.emailOtpError.value = null,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: OtpDigitField(
                        controller: controller.otp3Controller,
                        focusNode: controller.otp3FocusNode,
                        errorText: null,
                        onChanged: (_) => controller.emailOtpError.value = null,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: OtpDigitField(
                        controller: controller.otp4Controller,
                        focusNode: controller.otp4FocusNode,
                        errorText: null,
                        onChanged: (_) => controller.emailOtpError.value = null,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: OtpDigitField(
                        controller: controller.otp5Controller,
                        focusNode: controller.otp5FocusNode,
                        errorText: null,
                        onChanged: (_) => controller.emailOtpError.value = null,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: OtpDigitField(
                        controller: controller.otp6Controller,
                        focusNode: controller.otp6FocusNode,
                        errorText: null,
                        isLast: true,
                        onChanged: (_) {
                          controller.emailOtpError.value = null;
                          controller.otp6FocusNode.unfocus();
                          controller.verifyEmailOtp();
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          // Error Message
          12.height,
          Obx(() {
            return Visibility(
              visible: controller.emailOtpError.value?.isNotEmpty ?? false,
              child: Text(
                '${controller.emailOtpError.value}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.warningColor,
                ),
              ),
            );
          }),
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
              final canResend = controller.canResend.value;
              if (canResend) {
                // Enabled state with "Resend" highlighted
                return TextButton(
                  onPressed: controller.resendEmailOtp,
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive OTP? ",
                      style: Get.textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(color: Get.theme.primaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Disabled state with countdown timer
                return TextButton(
                  onPressed: null, // Button is disabled
                  child: Text(
                    "Didn't receive OTP? Resend in ${_formatTime(controller.resendTimer.value)} sec",
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
