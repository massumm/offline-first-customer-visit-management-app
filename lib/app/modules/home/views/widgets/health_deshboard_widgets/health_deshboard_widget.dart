import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _caloriesCard(),
              const SizedBox(height: 8),

              _proteinCard(),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: _sleepCard()),
      ],
    );
  }

  // --------------------------------------------------
  // Calories Card
  Widget _caloriesCard() {
    return _card(
      borderColor: Color(0xff098C26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Calories",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          Row(
            children: [
              const Text(
                "1,420",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "kcal",
                style: TextStyle(
                  color: Color(0xff098C26),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              CircularPercentIndicator(
                radius: 26,
                lineWidth: 7,
                percent: 0.72,
                progressColor: Color(0xff098C26),
                backgroundColor: Color(0xffEBFFF0),

                center: const Text(
                  "72%",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  "Stay fueled — Dinner planned 600 kcal.",
                  maxLines: 2,

                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Protein Card
  Widget _proteinCard([double progress = 0.57]) {
    final cardColor = Color(0xff098C26);
    return _card(
      borderColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Protein",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "On track!",
                      style: TextStyle(
                        color: cardColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              CustomPaint(
                painter: GaugePainter(progress),
                child: SizedBox(
                  width: 72,
                  height: 36,
                  child: Center(
                    child: Text(
                      "${(progress * 100).round()}%",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Sleep Card
  Widget _sleepCard() {
    return _card(
      borderColor: Color(0xff0064A7),
      child: SizedBox(
        height: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sleep",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            const Text(
              "7h 20m",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Last Night",
              style: TextStyle(
                color: Color(0xff0064A7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Row(
              children: [
                const Icon(Icons.bedtime, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                const Text("Bedtime: 11:15 PM", style: TextStyle(fontSize: 10)),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                const Text("Wake-up:  6:35 AM", style: TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Shared Card UI
  Widget _card({required Widget child, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GaugePainter extends CustomPainter {
  final double progress;

  GaugePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    final backgroundPaint = Paint()
      ..color = Color(0xffF1FEF4)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Color(0xff098C26)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    /// Draw background arc (full half circle)
    canvas.drawArc(
      rect,
      math.pi, // start
      math.pi, // sweep (180°)
      false,
      backgroundPaint,
    );

    /// Draw progress arc
    canvas.drawArc(rect, math.pi, math.pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
