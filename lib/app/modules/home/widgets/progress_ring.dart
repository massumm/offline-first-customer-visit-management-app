import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart' show AppColors;

class ProgressRing extends StatelessWidget {
  final double value; // 0..1
  final double size;
  final double thickness;
  final Color trackColor;
  final Color valueColor;
  final LinearGradient? valueGradient;
  final String? title;
  final bool showPercentage;
  final int? percentageFontSize;

  const ProgressRing({
    super.key,
    required this.value,
    this.size = 72,
    this.thickness = 4,
    this.trackColor = AppColors.ligthBorderGrayColor,
    this.valueColor = AppColors.gradientRedStart,
    this.valueGradient,
    this.title,
    this.showPercentage = false,
    this.percentageFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_ProgressRingController>(
      init: _ProgressRingController(targetValue: value),
      tag: hashCode.toString(),
      builder: (controller) {
        return Obx(
          () => SizedBox(
            height: size,
            width: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(size, size),
                  painter: _RingPainter(
                    value: controller.animatedValue.value.clamp(0.0, 1.0),
                    thickness: thickness,
                    track: trackColor,
                    fill: valueColor,
                    gradient: valueGradient,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showPercentage || title != null) ...[
                      Text(
                        '${(controller.animatedValue.value * 100).toInt()}%',
                        style: AppTextTheme.headlineMediumBold.copyWith(
                          fontSize: percentageFontSize?.toDouble(),
                        ),
                      ),
                    ],
                    if (title != null) ...[
                      Text(title!),
                      Icon(Icons.arrow_outward, color: valueColor),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressRingController extends GetxController {
  final double targetValue;
  final animatedValue = 0.0.obs;

  _ProgressRingController({required this.targetValue});

  @override
  void onInit() {
    super.onInit();
    _animateToValue();
  }

  void _animateToValue() {
    final steps = 60;
    final stepDuration = const Duration(milliseconds: 25);
    var currentStep = 0;

    Future.doWhile(() async {
      await Future.delayed(stepDuration);
      currentStep++;
      animatedValue.value = (targetValue / steps) * currentStep;
      return currentStep < steps;
    });
  }

}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.thickness,
    required this.track,
    required this.fill,
    this.gradient,
  });

  final double value;
  final double thickness;
  final Color track;
  final Color fill;
  final LinearGradient? gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final valuePaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    if (gradient != null) {
      valuePaint.shader = gradient!.createShader(rect);
    }

    // Track
    canvas.drawArc(
      rect.deflate(thickness / 2),
      -math.pi / 2,
      2 * math.pi,
      false,
      trackPaint,
    );

    // Progress arc
    canvas.drawArc(
      rect.deflate(thickness / 2),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.value != value ||
      old.fill != fill ||
      old.track != track ||
      old.thickness != thickness ||
      old.gradient != gradient;
}
