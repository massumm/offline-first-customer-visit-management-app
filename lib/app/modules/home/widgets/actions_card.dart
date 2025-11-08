import 'package:flutter/material.dart';
import 'progress_ring.dart';

class ActionsCard extends StatelessWidget {
  const ActionsCard({
    super.key,
    required this.title,
    required this.color,
    required this.percent,
    this.gradient,
  });

  final String title;
  final Color color;
  final double percent;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
