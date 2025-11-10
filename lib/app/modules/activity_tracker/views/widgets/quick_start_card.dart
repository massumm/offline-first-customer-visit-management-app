import 'package:flutter/material.dart';

import 'soft_button.dart';

class QuickStartCard extends StatelessWidget {
  const QuickStartCard({
    super.key,
    required this.onStartEmptyWorkout,
    required this.onNewRoutine,
    required this.onExplore,
  });

  final VoidCallback onStartEmptyWorkout;
  final VoidCallback onNewRoutine;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Start
          Text(
            'Quick Start',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Want to jump in without a plan? Start an empty session and build as you go.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 12),
          _TonalTileButton(
            label: 'Start Empty Workout',
            onTap: onStartEmptyWorkout,
          ),
          const SizedBox(height: 18),

          // Routines
          Text(
            'Routines',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick from your saved plans or create a new one.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SoftButton(
                  text: 'New Routine',
                  onPressed: onNewRoutine,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SoftButton(text: 'Explore', onPressed: onExplore),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TonalTileButton extends StatelessWidget {
  const _TonalTileButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bg = cs.surface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    label,
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 14,
                    )
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurface,),
            ],
          ),
        ),
      ),
    );
  }
}