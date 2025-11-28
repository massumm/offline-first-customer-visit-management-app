import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/modules/home/views/widgets/fitness_deshboard_widgets/steps_progress_icon.dart';

import 'heart_rate_card_widget.dart';
import 'hydration_card.dart';

class FitnessDashboard extends StatefulWidget {
  const FitnessDashboard({super.key});

  @override
  State<FitnessDashboard> createState() => _FitnessDashboardState();
}

class _FitnessDashboardState extends State<FitnessDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController waveController;

  @override
  void initState() {
    super.initState();
    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: IntrinsicWidth(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: StepsCard()),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HydrationWaveProvider(
                        child: SizedBox(
                          // width: cardWidth,
                          child: HydrationCard(
                            onAddWater: () {},
                            remainingLiters: 3.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        // width: cardWidth,
                        child: HeartRateCard(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// STEPS CARD

class StepsCard extends StatelessWidget {
  const StepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.35),
          width: 1.1,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xffFDE8E8), Color(0xffF9D6D6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "8,450",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Steps",
                      style: textTheme.titleSmall?.copyWith(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Out of 10,000",
                  style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
              ],
            ),
            12.height,
            StepsProgressIcon(),
          ],
        ),
      ),
    );
  }
}

//  HEART RATE CARD
