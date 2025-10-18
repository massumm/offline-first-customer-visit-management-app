import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/modules/register/controllers/register_controller.dart';

class EmailVerificationPageView extends BaseView<RegisterController> {
  EmailVerificationPageView({super.key});

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
                
                // Email Icon
                Center(
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBE5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(24, 24),
                        painter: EmailIconPainter(),
                      ),
                    ),
                  ),
                ),
                24.height,
                
                // Title
                Center(
                  child: Text(
                    "Add an Extra Layer of\nSecurity",
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
                12.height,
                
                // Subtitle
                Center(
                  child: Text(
                    "Protect your account with two-factor\nauthentication.",
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
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

// Custom painter for the email icon
class EmailIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE9522B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Scale factor to fit the icon in the given size
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;

    // Draw envelope flap
    final flapPath = Path();
    flapPath.moveTo(4.8359 * scaleX, 6.583 * scaleY);
    flapPath.lineTo(7.2876 * scaleX, 8.0325 * scaleY);
    flapPath.cubicTo(
      8.717 * scaleX, 8.8776 * scaleY,
      9.2883 * scaleX, 8.8776 * scaleY,
      10.7176 * scaleX, 8.0325 * scaleY,
    );
    flapPath.lineTo(13.1693 * scaleX, 6.583 * scaleY);
    canvas.drawPath(flapPath, paint);

    // Draw envelope body
    final bodyPath = Path();
    bodyPath.moveTo(0.6772 * scaleX, 10.73 * scaleY);
    bodyPath.cubicTo(
      0.7317 * scaleX, 13.2846 * scaleY,
      0.7589 * scaleX, 14.5619 * scaleY,
      1.7015 * scaleX, 15.5081 * scaleY,
    );
    bodyPath.cubicTo(
      2.6441 * scaleX, 16.4543 * scaleY,
      3.956 * scaleX, 16.4873 * scaleY,
      6.5798 * scaleX, 16.5532 * scaleY,
    );
    bodyPath.cubicTo(
      8.1968 * scaleX, 16.5938 * scaleY,
      9.798 * scaleX, 16.5938 * scaleY,
      11.415 * scaleX, 16.5532 * scaleY,
    );
    bodyPath.cubicTo(
      14.0388 * scaleX, 16.4873 * scaleY,
      15.3507 * scaleX, 16.4543 * scaleY,
      16.2933 * scaleX, 15.5081 * scaleY,
    );
    bodyPath.cubicTo(
      17.2359 * scaleX, 14.5619 * scaleY,
      17.2631 * scaleX, 13.2846 * scaleY,
      17.3176 * scaleX, 10.73 * scaleY,
    );
    bodyPath.cubicTo(
      17.3351 * scaleX, 9.9086 * scaleY,
      17.3351 * scaleX, 9.0921 * scaleY,
      17.3176 * scaleX, 8.2707 * scaleY,
    );
    bodyPath.cubicTo(
      17.2631 * scaleX, 5.716 * scaleY,
      17.2359 * scaleX, 4.4387 * scaleY,
      16.2933 * scaleX, 3.4925 * scaleY,
    );
    bodyPath.cubicTo(
      15.3507 * scaleX, 2.5463 * scaleY,
      14.0388 * scaleX, 2.5134 * scaleY,
      11.415 * scaleX, 2.4475 * scaleY,
    );
    bodyPath.cubicTo(
      9.798 * scaleX, 2.4068 * scaleY,
      8.1968 * scaleX, 2.4068 * scaleY,
      6.5797 * scaleX, 2.4475 * scaleY,
    );
    bodyPath.cubicTo(
      3.956 * scaleX, 2.5134 * scaleY,
      2.6441 * scaleX, 2.5463 * scaleY,
      1.7015 * scaleX, 3.4925 * scaleY,
    );
    bodyPath.cubicTo(
      0.7589 * scaleX, 4.4387 * scaleY,
      0.7317 * scaleX, 5.716 * scaleY,
      0.6772 * scaleX, 8.2706 * scaleY,
    );
    bodyPath.cubicTo(
      0.6597 * scaleX, 9.092 * scaleY,
      0.6597 * scaleX, 9.9086 * scaleY,
      0.6772 * scaleX, 10.73 * scaleY,
    );
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}