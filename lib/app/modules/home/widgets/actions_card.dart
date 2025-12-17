import 'package:flutter/material.dart';
import 'progress_ring.dart';

class ActionsCard extends StatelessWidget {
  const ActionsCard({
    super.key,
    required this.title,
    required this.color,
    required this.percent,
    this.gradient,
    this.onTap,
  });

  final String title;
  final Color color;
  final double percent;
  final LinearGradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 126,
        width: 126,
        child: ProgressRing(
          value: percent,
          thickness: 12,
          trackColor: Colors.white10,
          valueColor: color,
          valueGradient: gradient,
          title: title,
          size: 126,
        ),
      ),
    );
  }
}

