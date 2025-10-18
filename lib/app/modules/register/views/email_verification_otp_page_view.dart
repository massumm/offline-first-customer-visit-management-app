import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildOtpField(
                            context,
                            controller.otp1Controller,
                            true,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: _buildOtpField(
                            context,
                            controller.otp2Controller,
                            false,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: _buildOtpField(
                            context,
                            controller.otp3Controller,
                            false,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: _buildOtpField(
                            context,
                            controller.otp4Controller,
                            false,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: _buildOtpField(
                            context,
                            controller.otp5Controller,
                            false,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: _buildOtpField(
                            context,
                            controller.otp6Controller,
                            false,
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildOtpField(
    BuildContext context,
    TextEditingController textController,
    bool autoFocus,
  ) {
    return Center(
      child: TextField(
        controller: textController,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: Get.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        onSubmitted: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
