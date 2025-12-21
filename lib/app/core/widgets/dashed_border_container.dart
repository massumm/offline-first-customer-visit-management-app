import 'dart:ui';

import 'package:flutter/material.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final double dashLength;
  final double dashGap;
  final double strokeWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry padding;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.dashLength = 6.0,
    this.dashGap = 4.0,
    this.strokeWidth = 2.0,
    this.borderRadius = 12.0,
    this.borderColor = Colors.black,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // Using a painter for a rounded rectangle
      painter: _DashedRectPainter(
        dashLength: dashLength,
        dashGap: dashGap,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
        color: borderColor,
      ),
      child: Container(padding: padding, child: child),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final double dashLength;
  final double dashGap;
  final double strokeWidth;
  final double borderRadius;
  final Color color;

  _DashedRectPainter({
    required this.dashLength,
    required this.dashGap,
    required this.strokeWidth,
    required this.borderRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect outer = RRect.fromRectAndRadius(
      Offset(strokeWidth / 2, strokeWidth / 2) &
          Size(size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(outer);
    final PathMetrics pm = path.computeMetrics();
    for (PathMetric metric in pm) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        double len = (draw ? dashLength : dashGap);
        if (distance + len > metric.length) {
          len = metric.length - distance;
        }
        if (draw) {
          final Path dashPath = metric.extractPath(distance, distance + len);
          canvas.drawPath(dashPath, paint);
        }
        distance += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRectPainter oldDelegate) {
    return dashLength != oldDelegate.dashLength ||
        dashGap != oldDelegate.dashGap ||
        strokeWidth != oldDelegate.strokeWidth ||
        borderRadius != oldDelegate.borderRadius ||
        color != oldDelegate.color;
  }
}
