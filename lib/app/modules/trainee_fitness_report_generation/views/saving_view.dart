import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';

import 'package:icon/app/modules/trainee_fitness_report_generation/controllers/trainee_fitness_report_generation_controller.dart';

class SavingView extends BaseView<TraineeFitnessReportGenerationController> {
  SavingView({super.key});

  @override
  Widget body(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFE6E1), Colors.white],
        ),
      ),
      // Use Obx to rebuild the child when the controller's error state changes.
      child: Obx(() {
        // The controller exposes a boolean `hasError` observable.
        // When an error occurs, the controller should set this to true.
        return controller.hasError.value
            ? _buildErrorView(context)
            : _buildProgressView();
      }),
    );
  }

  /// The view to display while data is being saved.
  Widget _buildProgressView() {
    return Column(
      children: [
        const SizedBox(height: 24),
        // const _TopStatusBarStub(),
        const Spacer(),
        // Ring + % text
        Obx(
              () => AnimatedProgressRing(
            value: controller.progress.value,
            size: 240,
            stroke: 12,
            ringColor: const Color(0xFFE94B35),
            trackColor: const Color(0x1AE94B35),
            segmentCount: 48,
            segmentGapFactor: 0.18,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Saving your data securely',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your Icon is learning about you, this only\n'
              'takes a moment',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            height: 1.3,
            color: Colors.black54,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  /// The view to display when a network error occurs.
  Widget _buildErrorView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFE94B35),
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Unable to Save',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // The controller exposes an `errorMessage` observable.
            Obx(
                  () => Text(
                // Use the new property name 'errorMessage'
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              // The controller has a method to retry the operation.
              onPressed: () => controller.retryReportGeneration(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A stateless widget that draws a segmented progress ring with text overlay.
class AnimatedProgressRing extends StatelessWidget {
  const AnimatedProgressRing({
    super.key,
    required this.value,
    required this.size,
    required this.stroke,
    required this.ringColor,
    required this.trackColor,
    required this.segmentCount,
    required this.segmentGapFactor,
  });

  final double value;
  final double size;
  final double stroke;
  final Color ringColor;
  final Color trackColor;
  final int segmentCount;
  final double segmentGapFactor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ProgressRingPainter(
              value: value,
              stroke: stroke,
              ringColor: ringColor,
              trackColor: trackColor,
              segmentCount: segmentCount,
              segmentGapFactor: segmentGapFactor,
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE94B35),
          ),
        ),
      ],
    );
  }
}

/// A custom painter for the segmented progress ring.
class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.value,
    required this.stroke,
    required this.ringColor,
    required this.trackColor,
    required this.segmentCount,
    required this.segmentGapFactor,
  });

  final double value;
  final double stroke;
  final Color ringColor;
  final Color trackColor;
  final int segmentCount;
  final double segmentGapFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    const startAngle = -math.pi / 2;

    final totalSweepAngle = 2 * math.pi;
    final segmentAngle =
        totalSweepAngle / segmentCount * (1 - segmentGapFactor);
    final gapAngle = totalSweepAngle / segmentCount * segmentGapFactor;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final ringPaint = Paint()
      ..color = ringColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressSegments = (segmentCount * value).ceil();

    for (int i = 0; i < segmentCount; i++) {
      final segmentStartAngle = startAngle + i * (segmentAngle + gapAngle);
      // Use the progress paint for segments up to the current progress,
      // otherwise use the background track paint.
      final paint = i < progressSegments ? ringPaint : trackPaint;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segmentStartAngle,
        segmentAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.stroke != stroke ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.segmentCount != segmentCount ||
        oldDelegate.segmentGapFactor != segmentGapFactor;
  }
}

/// A placeholder widget to mimic the top status bar.
class _TopStatusBarStub extends StatelessWidget {
  const _TopStatusBarStub();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.black54, size: 18),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.black54, size: 18),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.black54, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}