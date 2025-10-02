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
    final backgroundColor = const Color(0xFFFFE5E2).withValues(alpha: 0.55);
    const height = 28.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step count label
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

        // Step segments
        Row(
          children: List.generate(totalSteps, (i) {
            final stepIndex = i + 1;
            final isActive = stepIndex == currentStep;

            return Expanded(
              child: Container(
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: isActive
                    ? Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Fill based on percent
                    FractionallySizedBox(
                      widthFactor: percentInStep.clamp(0, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),

                    // Percentage pill
                    Positioned(
                      left: 10,
                      child: _PercentPill(
                        percent: (percentInStep * 100).clamp(0, 100).round(),
                      ),
                    ),
                  ],
                )
                    : null,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),

        // Step title
        Text(
          stepTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: Colors.white,
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
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
