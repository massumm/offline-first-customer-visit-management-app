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
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            double dot(int i) => 0.3 + 0.7 * ((t + i / 3) % 1.0);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                    (i) => Padding(
                  padding: EdgeInsets.only(right: i == 2 ? 0 : 6),
                  child: Opacity(
                    opacity: [dot(0), dot(1), dot(2)][i].clamp(0.3, 1.0),
                    child: Icon(Icons.circle, size: 8, color: fg),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}