import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key});

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.primary;
    final fg = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              child: CustomPaint(
                size: const Size(28, 10),
                painter: _TypingDotsPainter(
                  color: fg,
                  animation: _controller,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Mish typing...',
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDotsPainter extends CustomPainter {
  _TypingDotsPainter({
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  final Color color;
  final Animation<double> animation;

  static const double _r = 3.0;
  static const double _gap = 5.0;
  static const double _lift = 1.6;
  static const double _phase = 0.18;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final totalW = (2 * _r) * 3 + _gap * 2;
    final startX = (size.width - totalW) / 2 + _r;
    final centerY = size.height / 2;

    // 0..1 looping time
    final t = animation.value;

    // smooth 0..1..0 wave (cosine ease)
    double wave(double x) => 0.5 - 0.5 * math.cos(2 * math.pi * x);

    for (int i = 0; i < 3; i++) {
      final phase = (t + i * _phase) % 1.0;
      final w = wave(phase);

      final alpha = lerpDouble(0.35, 1.0, w)!;
      final scale = lerpDouble(0.85, 1.20, w)!;
      final dy = -_lift * w;

      paint.color = color.withValues(alpha: alpha);

      final x = startX + i * ((2 * _r) + _gap);
      canvas.save();
      canvas.translate(x, centerY + dy);
      canvas.drawCircle(Offset.zero, _r * scale, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _TypingDotsPainter oldDelegate) {
    // color changes should repaint; animation handled by `repaint:`
    return oldDelegate.color != color;
  }
}
