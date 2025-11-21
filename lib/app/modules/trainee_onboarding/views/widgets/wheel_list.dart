import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class WheelListWidget extends StatelessWidget {
  const WheelListWidget({super.key, required this.range});

  final int range;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(7, (index) => index + 1);

    return SizedBox(
      height: 260,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          // mainAxisSize is no longer needed, as Expanded will fill the space.
          children: [
            // Wrap the ListWheelScrollView with an Expanded widget.
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 60,
                perspective: 0.003,
                diameterRatio: 2.5,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.4,
                onSelectedItemChanged: (index) {
                  // handle selection here if you want
                  debugPrint('Selected: ${items[index]}');
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 0 || index >= items.length) return null;
                    return _WheelItem(number: items[index]);
                  },
                ),
              ),
            ),
            12.height,
            ElevatedButton(onPressed: () {}, child: const Text('Next'))
          ],
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  final int number;

  const _WheelItem({required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text(
              number.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
