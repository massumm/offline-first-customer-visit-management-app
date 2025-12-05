import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';

class WheelListWidget extends StatefulWidget {
  const WheelListWidget({
    super.key,
    required this.items,
    required this.onNext,
    this.showCustomNumberField = false,
    this.showCustomTextField = false,
  });

  final List<String> items;
  final ValueChanged<String> onNext;
  final bool showCustomNumberField;
  final bool showCustomTextField;

  @override
  State<WheelListWidget> createState() => _WheelListWidgetState();
}

class _WheelListWidgetState extends State<WheelListWidget> {
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
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Dynamic height
    double height = 260;
    if (widget.showCustomNumberField) height += 90;
    if (widget.showCustomTextField) height += 90;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            // Wheel
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 60,
                perspective: 0.003,
                diameterRatio: 2.5,
                physics: const FixedExtentScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                overAndUnderCenterOpacity: 0.4,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.items.length,
                  builder: (context, index) {
                    if (index < 0 || index >= widget.items.length) return null;
                    return _WheelItem(item: widget.items[index]);
                  },
                ),
              ),
            ),
            // Custom Number Field
            if (widget.showCustomNumberField)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: isIOS
                    ? CupertinoTextField(
                        controller: _customNumberController,
                        keyboardType: TextInputType.number,
                        placeholder: 'Enter custom number',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      )
                    : TextField(
                        controller: _customNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter custom number',
                          border: OutlineInputBorder(),
                        ),
                      ),
              ),
            // Custom Text Field
            if (widget.showCustomTextField)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: isIOS
                    ? CupertinoTextField(
                        controller: _customTextController,
                        keyboardType: TextInputType.text,
                        placeholder: 'Enter custom value',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      )
                    : TextField(
                        controller: _customTextController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Enter custom value',
                          border: OutlineInputBorder(),
                        ),
                      ),
              ),
            12.height,
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
              color: colorScheme.onSurface.withAlpha(179),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
