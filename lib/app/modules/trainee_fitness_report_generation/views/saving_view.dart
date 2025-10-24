import 'dart:math' as math;

import 'package:flutter/material.dart';

class SavingView extends StatefulWidget {
  const SavingView({super.key});

  @override
  State<SavingView> createState() => _SavingViewState();
}

class _SavingViewState extends State<SavingView> {
  double progressTarget = 0.84; // 0.0 .. 1.0

  // Example: change progress dynamically (simulate backend updates)
  // In real use, call setProgress(value) whenever you get new progress.
  void setProgress(double v) {
    setState(() => progressTarget = v.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // subtle angled gradient background like the mock
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFFE6E1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const _TopStatusBarStub(), // optional, for the look
              const Spacer(),
              // Ring + % text
              AnimatedProgressRing(
                value: progressTarget,
                size: 240,
                stroke: 12,
                ringColor: const Color(0xFFE94B35),
                trackColor: const Color(0x1AE94B35),
                segmentCount: 48,
                segmentGapFactor: 0.18,
                // animation will auto-adjust based on delta
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
              // Demo controls (remove in production)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // simulate a server update
                          final next = (progressTarget + 0.07).clamp(0.0, 1.0);
                          setProgress(next);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94B35),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Advance'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setProgress(math.Random().nextDouble()),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: const BorderSide(color: Color(0xFFE94B35)),
                          foregroundColor: const Color(0xFFE94B35),
                        ),
                        child: const Text('Random'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A pretty circular progress with:
/// - segmented background ticks
/// - smooth animated sweep
/// - rounded head with a moving dot
/// - centered percentage text
class AnimatedProgressRing extends StatefulWidget {
  const AnimatedProgressRing({
    super.key,
    required this.value,
    this.size = 220,
    this.stroke = 12,
    this.segmentCount = 48,
    this.segmentGapFactor = 0.18, // 0..1 of each segment allocated to gap
    this.ringColor = const Color(0xFFE94B35),
    this.trackColor = const Color(0x1AE94B35),
  });

  final double value; // 0..1
  final double size;
  final double stroke;
  final int segmentCount;
  final double segmentGapFactor;
  final Color ringColor;
  final Color trackColor;

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  double _from = 0.0;
  double _to = 0.0;

  @override
  void initState() {
    super.initState();
    _to = widget.value.clamp(0.0, 1.0);
    _controller = AnimationController(vsync: this);
    _animateTo(_to, initial: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTo = widget.value.clamp(0.0, 1.0);
    if (newTo != _to) {
      _from = _anim.value;
      _to = newTo;
      _animateTo(_to);
    }
  }

  void _animateTo(double target, {bool initial = false}) {
    final delta = (target - (initial ? 0.0 : _from)).abs();
    final ms = (300 + (700 * delta))
        .clamp(280, 1400)
        .toInt(); // feel-good timing
    _controller.duration = Duration(milliseconds: ms);
    _anim = Tween<double>(begin: initial ? 0.0 : _from, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final v = _anim.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  progress: v,
                  stroke: widget.stroke,
                  segmentCount: widget.segmentCount,
                  segmentGapFactor: widget.segmentGapFactor,
                  ringColor: widget.ringColor,
                  trackColor: widget.trackColor,
                ),
              ),
              // Center % text
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${(v * 100).round()}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 44,
                        height: 1.0,
                      ),
                    ),
                    const TextSpan(
                      text: '%',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.segmentCount,
    required this.segmentGapFactor,
    required this.ringColor,
    required this.trackColor,
  });

  final double progress; // 0..1
  final double stroke;
  final int segmentCount;
  final double segmentGapFactor;
  final Color ringColor;
  final Color trackColor;

  static const double _startAngle = -math.pi / 2; // 12 o'clock

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    // Background segmented ticks
    final segAngle = (2 * math.pi) / segmentCount;
    final gap = segAngle * segmentGapFactor;
    final sweep = segAngle - gap;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    for (int i = 0; i < segmentCount; i++) {
      final start = _startAngle + i * segAngle + gap / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        trackPaint,
      );
    }

    // Progress arc (continuous for smoothness, rounded head)
    final progPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final sweepProgress = progress * 2 * math.pi;
    if (sweepProgress > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _startAngle,
        sweepProgress,
        false,
        progPaint,
      );
    }

    // Moving dot at the head
    final headAngle = _startAngle + sweepProgress;
    final dotRadius = stroke * 0.55;
    final dotCenter = Offset(
      center.dx + radius * math.cos(headAngle),
      center.dy + radius * math.sin(headAngle),
    );

    final dotPaint = Paint()..color = ringColor;
    final dotStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 0.35;

    canvas.drawCircle(dotCenter, dotRadius, dotPaint);
    canvas.drawCircle(dotCenter, dotRadius, dotStroke);

    // Inner white circle for the hollowed look
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - stroke * 0.9, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        stroke != oldDelegate.stroke ||
        segmentCount != oldDelegate.segmentCount ||
        ringColor != oldDelegate.ringColor ||
        trackColor != oldDelegate.trackColor ||
        segmentGapFactor != oldDelegate.segmentGapFactor;
  }
}

/// Just a tiny fake “status bar” spacing like the mock — safe to remove.
class _TopStatusBarStub extends StatelessWidget {
  const _TopStatusBarStub();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 0); // placeholder
  }
}
