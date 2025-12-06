import 'package:flutter/material.dart';

class QandAProgressBar extends StatefulWidget {
  final int currentGroup;
  final int totalGroups;
  final int currentQuestion;
  final int totalQuestions;
  const QandAProgressBar({
    super.key,
    required this.currentGroup,
    required this.totalGroups,
    required this.currentQuestion,
    required this.totalQuestions,
  });
  @override
  State<QandAProgressBar> createState() => _QandAProgressBarState();
}

class _QandAProgressBarState extends State<QandAProgressBar> {
  double _oldProgress = 0.0;
  @override
  void didUpdateWidget(covariant QandAProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Store old values for animation
    _oldProgress = _calculateProgress(
      oldWidget.currentGroup,
      oldWidget.totalGroups,
      oldWidget.currentQuestion,
      oldWidget.totalQuestions,
    );
  }

  double _calculateProgress(
    int group,
    int totalGroups,
    int question,
    int totalQuestions,
  ) {
    double questionProgress = question / totalQuestions;
    double totalProgress =
        ((group - 1) / totalGroups) + (questionProgress / totalGroups);
    return totalProgress.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double totalProgress = _calculateProgress(
      widget.currentGroup,
      widget.totalGroups,
      widget.currentQuestion,
      widget.totalQuestions,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: _oldProgress, end: totalProgress),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withAlpha(30),
                      theme.colorScheme.primary.withAlpha(20),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.primary,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(46),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                      // Glowing effect
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(115),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
