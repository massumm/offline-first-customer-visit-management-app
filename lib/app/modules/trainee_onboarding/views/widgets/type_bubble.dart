import 'dart:math' as math;
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
    final fg = Theme.of(context).colorScheme.surfaceContainerHighest; // or onPrimary for stronger contrast

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
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value; // 0..1
            double wave(int i) {
              // Staggered sine wave (0..1)
              final s = math.sin(2 * math.pi * (t + i / 6));
              return (s + 1) / 2;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- 3 animated dots ---
                ...List.generate(3, (i) {
                  final w = wave(i);
                  final opacity = 0.35 + 0.65 * w;     // 0.35 → 1.0
                  final scale   = 0.85 + 0.35 * w;     // 0.85 → 1.20
                  final dy      = -2.0 * w;            // lift up slightly

                  return Padding(
                    padding: EdgeInsets.only(right: i == 2 ? 0 : 6),
                    child: Opacity(
                      opacity: opacity.clamp(0.35, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.scale(
                          scale: scale,
                          child: Icon(Icons.circle, size: 8, color: fg),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(width: 8),

                // --- "Mesh Typing" label ---
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
            );
          },
        ),
      ),
    );
  }
}
