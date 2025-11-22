import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class MinutesWheelList extends StatefulWidget {
  const MinutesWheelList({
    super.key,
    required this.onNext,
  });

  final ValueChanged<int> onNext;

  @override
  State<MinutesWheelList> createState() => _MinutesWheelListState();
}

class _MinutesWheelListState extends State<MinutesWheelList> {
  final List<String> _items = [
    '5 min',
    '15 min',
    '30 min',
    '40 min',
    '1 hour',
    '1 hour+',
  ];

  int _selectedIndex = 0;

  /// into an integer value in minutes.
  int _getMinutesFromString(String value) {
    if (value.contains('hour+')) return 75; // Default value for '1 hour+'
    if (value.contains('hour')) {
      final parts = value.split(' ');
      final hours = int.tryParse(parts[0]) ?? 1;
      return hours * 60;
    }
    final parts = value.split(' ');
    return int.tryParse(parts[0]) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    _selectedIndex = index;
                  });
                  debugPrint('Selected: ${_items[index]}');
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _items.length,
                  builder: (context, index) {
                    if (index < 0 || index >= _items.length) return null;
                    return _WheelItem(number: _items[index]);
                  },
                ),
              ),
            ),
            12.height,
            ElevatedButton(
              onPressed: () {
                final selectedValue = _items[_selectedIndex];
                final minutes = _getMinutesFromString(selectedValue);
                widget.onNext(minutes);
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  final String number;

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
