import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/core/widgets/input_widgets/otp_digit_field.dart';
import 'package:icon/app/modules/forgot_password/controllers/forgot_password_controller.dart';

class OtpPageView extends BaseView<ForgotPasswordController> {
  const OtpPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, _) {
        if (result == true) {
          controller.gotToPreviousPage();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: Get.size.height,
            width: Get.size.width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActionPill(onTap: controller.gotToPreviousPage),
                  controller.forgotPasswordDefaultHeight,
                  Text("Enter OTP Code", style: Get.textTheme.titleLarge),
                  10.height,
                  Text(
                    "We just sent you an Email with 6-digit code. looks like very soon you will be logged in!",
                    style: Get.textTheme.bodyMedium,
                  ),
                  40.height,

                  // OTP Input Fields
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Obx(() {
                        final error = controller.otpError.value;
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
                                    controller.otpError.value = null,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                              ),
                            ),
                            8.width,
                            Expanded(
                              child: OtpDigitField(
                                controller: controller.otp2Controller,
                                focusNode: controller.otp2FocusNode,
                                errorText: error,
                                onChanged: (_) =>
                                    controller.otpError.value = null,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                              ),
                            ),
                            8.width,
                            Expanded(
                              child: OtpDigitField(
                                controller: controller.otp3Controller,
                                focusNode: controller.otp3FocusNode,
                                errorText: error,
                                onChanged: (_) =>
                                    controller.otpError.value = null,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                              ),
                            ),
                            8.width,
                            Expanded(
                              child: OtpDigitField(
                                controller: controller.otp4Controller,
                                focusNode: controller.otp4FocusNode,
                                errorText: error,
                                onChanged: (_) =>
                                    controller.otpError.value = null,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                              ),
                            ),
                            8.width,
                            Expanded(
                              child: OtpDigitField(
                                controller: controller.otp5Controller,
                                focusNode: controller.otp5FocusNode,
                                errorText: error,
                                onChanged: (_) =>
                                    controller.otpError.value = null,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
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
                                    controller.otpError.value = null,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.verifyOtp,
                      child: const Text("Verify"),
                    ),
                  ),
                  20.height,

                  // Resend OTP
                  Center(
                    child: Obx(() {
                      return TextButton(
                        onPressed: controller.canResend.value
                            ? controller.resendOtp
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
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
