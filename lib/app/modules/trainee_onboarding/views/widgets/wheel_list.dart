import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class WheelListWidget extends StatelessWidget {
  const WheelListWidget({super.key, required this.range});

  final int range;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(range, (index) => index + 1);

    return SizedBox(
      height: 260,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 60,
                perspective: 0.003,
                diameterRatio: 2.5,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.4,
                onSelectedItemChanged: (index) {
                  debugPrint('Selected: ${items[index]}');
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: items.length,
                  builder: (context, index) {
                    if (index < 0 || index >= items.length) return null;
                    return _WheelItem(number: items[index]);
                  },
                ),
              ),
            ),
            12.height,
            ElevatedButton(onPressed: () {}, child: const Text('Next')),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text(
              number.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
