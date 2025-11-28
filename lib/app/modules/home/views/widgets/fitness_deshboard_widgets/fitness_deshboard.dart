import 'package:flutter/material.dart';

import 'heart_rate_card_widget.dart';
import 'hydration_card.dart';
import 'steps_card.dart';

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
