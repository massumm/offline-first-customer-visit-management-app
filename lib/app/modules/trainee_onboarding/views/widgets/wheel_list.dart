import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class WheelListWidget extends StatefulWidget {
  const WheelListWidget({
    super.key,
    required this.items,
    required this.onNext,
    this.showCustomNumberField = false,
    this.showCustomTextField = false, // New parameter
  });

  final List<String> items;
  final ValueChanged<String> onNext;
  final bool showCustomNumberField;
  final bool showCustomTextField; // New parameter

  @override
  State<WheelListWidget> createState() => _WheelListWidgetState();
}

class _WheelListWidgetState extends State<WheelListWidget> {
  // Holds the index of the currently selected item.
  int _selectedIndex = 0;

  // Controllers for the custom input fields.
  late final TextEditingController _customNumberController;
  late final TextEditingController _customTextController;

  @override
  void initState() {
    super.initState();
    _customNumberController = TextEditingController();
    _customTextController = TextEditingController();
  }

  @override
  void dispose() {
    _customNumberController.dispose();
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate height based on which fields are visible.
    double height = 260;
    if (widget.showCustomNumberField) height += 80;
    if (widget.showCustomTextField) height += 80;

    return SizedBox(
      height: height,
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
            // Conditionally display the custom text input field.
            if (widget.showCustomTextField)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: TextField(
                  controller: _customTextController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter custom value',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            12.height,
            ElevatedButton(
              onPressed: () {
                // Prioritize the custom text field if it's shown and has a value.
                if (widget.showCustomTextField &&
                    _customTextController.text.isNotEmpty) {
                  widget.onNext(_customTextController.text);
                }
                // Then, prioritize the custom number field if it's shown and has a value.
                else if (widget.showCustomNumberField &&
                    _customNumberController.text.isNotEmpty) {
                  widget.onNext(_customNumberController.text);
                } else {
                  // Fallback to the wheel selection.
                  final selectedValue = widget.items[_selectedIndex];
                  widget.onNext(selectedValue);
                }
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
              item,
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
