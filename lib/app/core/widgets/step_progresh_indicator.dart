import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep; // 1-based
  final int totalSteps;
  final double percentInStep; // 0.0 - 1.0 for the active segment
  final String stepTitle;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.percentInStep,
    required this.stepTitle,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFFF6A5E); // soft red outline
    final fillColor = const Color(0xFFFFE5E2).withValues(alpha: 0.55); // pale pink
    final segments = List.generate(totalSteps, (i) {
      final isActive = (i + 1) == currentStep;

      return Expanded(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 2),
              ),
            ),

            // Little white "10%" pill only on the active segment
            if (isActive)
              Positioned(
                left: 10,
                child: _PercentPill(
                  percent: (percentInStep * 100).clamp(0, 100).round(),
                ),
              ),
          ],
        ),
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Step $currentStep of $totalSteps',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Segments
        Row(children: segments),
        const SizedBox(height: 12),

        // Centered step title
        Text(
          stepTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: Colors.white
          ),
        ),
      ],
    );
  }
}

class _PercentPill extends StatelessWidget {
  final int percent;
  const _PercentPill({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$percent%',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
