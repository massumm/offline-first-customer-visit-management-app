import 'package:flutter/material.dart';

class AnimatedOnboardingStepper extends StatefulWidget {
  final int totalSteps;
  final int currentStep;        // 0-indexed
  final double stepProgress;    // NEW: 0..1 progress inside current step

  const AnimatedOnboardingStepper({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.stepProgress = 0.0,    // default none
  });

  @override
  State<AnimatedOnboardingStepper> createState() => _AnimatedOnboardingStepperState();
}

class _AnimatedOnboardingStepperState extends State<AnimatedOnboardingStepper> with TickerProviderStateMixin {
  late AnimationController _progressCtrl;
  late Animation<double> _progress; // 0..1 across the whole track
  late AnimationController _pulseCtrl;

  double _targetFor(int step, double stepProgress) {
    if (widget.totalSteps <= 1) return 0;
    // map (currentStep + stepProgress) over (totalSteps-1)
    final segs = (widget.totalSteps - 1).toDouble();
    final frac = (step.clamp(0, widget.totalSteps - 1) + stepProgress.clamp(0, 1)) / segs;
    return frac.clamp(0, 1);
  }

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _progress = CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOutCubic);

    _progressCtrl.value = _targetFor(widget.currentStep, widget.stepProgress);
  }

  @override
  void didUpdateWidget(covariant AnimatedOnboardingStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    final to = _targetFor(widget.currentStep, widget.stepProgress);
    if ((_progressCtrl.value - to).abs() > 0.001) {
      _progressCtrl.animateTo(to, curve: Curves.easeInOutCubic);
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.totalSteps <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final barHeight = 6.0;
          final dotSize = 18.0;

          return AnimatedBuilder(
            animation: Listenable.merge([_progress, _pulseCtrl]),
            builder: (context, _) {
              final progressX = _progress.value * width;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // background
                  Container(
                    height: barHeight,
                    width: width,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  // foreground progress
                  Container(
                    height: barHeight,
                    width: progressX,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft, end: Alignment.centerRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.85),
                          theme.colorScheme.primary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.35),
                          blurRadius: 8, spreadRadius: 0.5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),

                  // moving thumb (tiny circle riding the progress)
                  Positioned(
                    left: (progressX - 6).clamp(0, width - 12),
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.45),
                            blurRadius: 10, spreadRadius: 1,
                          ),
                        ],
                        border: Border.all(color: theme.colorScheme.onPrimary, width: 2),
                      ),
                    ),
                  ),

                  // step dots
                  ...List.generate(widget.totalSteps, (i) {
                    final t = widget.totalSteps == 1 ? 0.0 : i / (widget.totalSteps - 1);
                    final dx = t * width;
                    final isActive = i == widget.currentStep;
                    final isCompleted = i < widget.currentStep ||
                        (i == widget.currentStep && widget.stepProgress >= 1.0);

                    final baseScale = isCompleted ? 1.0 : 0.92;
                    final activePulse = isActive
                        ? (0.95 + 0.05 * (0.5 - (0.5 - _pulseCtrl.value).abs()) * 2)
                        : 1.0;
                    final scale = baseScale * activePulse;

                    final dotColor = (isActive || isCompleted)
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.25);
                    final dotBorder = isActive
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.surface;

                    final List<BoxShadow> glow = isActive
                        ? <BoxShadow>[
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.45),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                        : const <BoxShadow>[];


                    return Positioned(
                      left: dx - (dotSize / 2),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: dotSize, height: dotSize,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: dotBorder, width: 2),
                            boxShadow: glow,
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              switchInCurve: Curves.easeOutBack,
                              switchOutCurve: Curves.easeIn,
                              child: isCompleted
                                  ? Icon(Icons.check, key: ValueKey('check_$i'),
                                  size: 12, color: theme.colorScheme.onPrimary)
                                  : isActive
                                  ? Container(key: ValueKey('active_$i'))
                                  : Icon(Icons.circle, key: ValueKey('idle_$i'),
                                  size: 6, color: theme.colorScheme.onSurface),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
