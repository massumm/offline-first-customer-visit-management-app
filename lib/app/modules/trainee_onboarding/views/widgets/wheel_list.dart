import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class WheelListWidget extends StatefulWidget {
  const WheelListWidget({
    super.key,
    required this.items,
    required this.onNext,
    this.showCustomNumberField = false, // New parameter to control text field visibility
  });

  // The list of strings to display in the wheel.
  final List<String> items;

  // Callback that returns the selected value, converted to minutes.
  final ValueChanged<int> onNext;

  // If true, shows a text field for custom input.
  final bool showCustomNumberField;

  @override
  State<WheelListWidget> createState() => _WheelListWidgetState();
}

class _WheelListWidgetState extends State<WheelListWidget> {
  // Holds the index of the currently selected item.
  int _selectedIndex = 0;
  // Controller for the custom number input field.
  late final TextEditingController _customNumberController;

  @override
  void initState() {
    super.initState();
    _customNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _customNumberController.dispose();
    super.dispose();
  }

  /// Converts a time string (e.g., "30 min", "1 hour") into an integer of minutes.
  int _getMinutesFromString(String value) {
    if (value.contains('hour+')) {
      return 75; // Default value for '1 hour+'
    }
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
      height: widget.showCustomNumberField
          ? 340
          : 260, // Adjust height when text field is visible
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
                  // Update the state when the user scrolls to a new item.
                  setState(() {
                    _selectedIndex = index;
                  });
                  debugPrint('Selected: ${widget.items[index]}');
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.items.length,
                  builder: (context, index) {
                    if (index < 0 || index >= widget.items.length) return null;
                    // Pass the string item from the widget's list.
                    return _WheelItem(item: widget.items[index]);
                  },
                ),
              ),
            ),
            // Conditionally display the custom number input field.
            if (widget.showCustomNumberField)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: TextField(
                  controller: _customNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter custom number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            12.height,
            ElevatedButton(
                onPressed: () {
                  // Prioritize the custom number field if it's shown and has a value.
                  if (widget.showCustomNumberField &&
                      _customNumberController.text.isNotEmpty) {
                    final customValue =
                        int.tryParse(_customNumberController.text) ?? 0;
                    widget.onNext(customValue);
                  } else {
                    // Fallback to the wheel selection.
                    final selectedValue = widget.items[_selectedIndex];
                    final minutes = _getMinutesFromString(selectedValue);
                    widget.onNext(minutes);
                  }
                },
                child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  // The string to display in the list item.
  final String item;

  const _WheelItem({required this.item});

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
              item, // Display the string item.
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.7),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
