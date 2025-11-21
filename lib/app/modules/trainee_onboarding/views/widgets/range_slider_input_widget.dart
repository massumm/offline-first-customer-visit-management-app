import 'package:flutter/material.dart';

class NumericRangeInputWidget extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String minTitle;
  final String maxTitle;
  final ValueChanged<double> onChanged;
  final VoidCallback onNext;

  const NumericRangeInputWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onNext,
    this.min = 1,
    this.max = 10,
    this.minTitle = 'Light',
    this.maxTitle = 'Hard',
  });

  @override
  Widget build(BuildContext context) {
    final numbers = List<int>.generate(
      (max - min + 1).toInt(),
      (i) => i + min.toInt(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minTitle, style: const TextStyle(color: Colors.white)),
                Text(maxTitle, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Slider with gradient track
          Stack(
            alignment: Alignment.center,
            children: [
              // gradient track background
              Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFE1DE), // light
                      Color(0xFFE53935), // hard
                    ],
                  ),
                ),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                  inactiveTrackColor: Colors.transparent,
                  activeTrackColor: Colors.transparent,
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  value: value.clamp(min, max),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Numbers under the slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: numbers
                .map(
                  (n) => Text(
                    '$n',
                    style: TextStyle(
                      color: n.toDouble() == value
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 16),

          // Next button
          ElevatedButton(
            onPressed: onNext,
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
