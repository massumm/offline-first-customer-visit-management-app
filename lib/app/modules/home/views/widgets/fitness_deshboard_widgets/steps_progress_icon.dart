import 'dart:math';

import 'package:flutter/material.dart';

class StepsProgressIcon extends StatefulWidget {
  const StepsProgressIcon({super.key});

  @override
  State<StepsProgressIcon> createState() => _StepsProgressIconState();
}

class _StepsProgressIconState extends State<StepsProgressIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: curve,
      builder: (_, _) => CustomPaint(
        size: const Size(120, 120),
        painter: StepIconPainter(progress: curve.value),
      ),
    );
  }
}

class StepIconPainter extends CustomPainter {
  final double progress;
  StepIconPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // REVERSE ANIMATION
    final double rev = 1 - progress;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.46;

    // ---------- RED ARC ----------
    final arcPaint = Paint()
      ..color = const Color(0xffB60015)
      ..strokeWidth = size.width * 0.12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = 1.15 * pi;
    const sweepAngle = 1.55 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // ---------- ROAD ----------
    final roadWidth = size.width * 0.22;
    final roadHeight = size.height * 0.60;
    final roadTop = center.dy - roadHeight / 2;

    final roadRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - roadWidth / 2, roadTop, roadWidth, roadHeight),
      Radius.circular(roadWidth * 0.5),
    );

    canvas.drawRRect(roadRect, Paint()..color = const Color(0xffE5E5E5));

    // ---------- DASHED LINE (REVERSED) ----------
    final dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = roadWidth * 0.13
      ..strokeCap = StrokeCap.round;

    final dashLength = roadHeight * 0.13;
    final gapLength = dashLength * 0.85;
    final totalLength = dashLength + gapLength;

    // REVERSE OFFSET
    final offset = rev * totalLength * 6;

    double y = roadTop - offset;

    for (int i = 0; i < 12; i++) {
      final yStart = y;
      final yEnd = y + dashLength;

      if (yEnd > roadTop && yStart < roadTop + roadHeight) {
        canvas.drawLine(
          Offset(center.dx, yStart.clamp(roadTop, roadTop + roadHeight)),
          Offset(center.dx, yEnd.clamp(roadTop, roadTop + roadHeight)),
          dashPaint,
        );
      }
      y += totalLength;
    }

    // ---------- WALKING FOOT ----------
    const double footSize = 32;

    final footStart = roadTop + dashLength;
    final footEnd = roadTop + roadHeight - dashLength;

    // REVERSE MOVEMENT
    final footY = footStart + (footEnd - footStart) * rev;

    // SHADOW
    final shadow = TextPainter(
      text: const TextSpan(
        text: "👣",
        style: TextStyle(fontSize: footSize, color: Colors.black26),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    shadow.paint(
      canvas,
      Offset(center.dx - shadow.width / 2 + 2, footY - shadow.height / 2 + 5),
    );

    // FOOT
    final painter = TextPainter(
      text: const TextSpan(
        text: "👣",
        style: TextStyle(fontSize: footSize, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, footY - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant StepIconPainter oldDelegate) => true;
}
