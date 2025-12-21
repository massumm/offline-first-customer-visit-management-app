import 'package:flutter/material.dart';
import 'package:icon/app/core/values/app_colors.dart';

class RestTimerBottomSheet extends StatelessWidget {
  final int selectedMinute;
  final int selectedSecond;
  final ValueChanged<int>? onMinuteChanged;
  final ValueChanged<int>? onSecondChanged;
  final VoidCallback? onStart;

  const RestTimerBottomSheet({
    super.key,
    required this.selectedMinute,
    required this.selectedSecond,
    this.onMinuteChanged,
    this.onSecondChanged,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> minutes = List.generate(60, (index) => index);
    final List<int> seconds = List.generate(60, (index) => index);

    final minController = FixedExtentScrollController(
      initialItem: selectedMinute,
    );
    final secController = FixedExtentScrollController(
      initialItem: selectedSecond,
    );

    const double wheelHeight = 110;
    const double itemExtent = 35;

    // theme
    final theme = Theme.of(context);

    Widget buildWheel({
      required List<int> values,
      required int selected,
      required FixedExtentScrollController controller,
      required ValueChanged<int>? onChanged,
      required String unit,
    }) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: wheelHeight,
            child: ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: itemExtent,
              perspective: 0.005,
              magnification: 1.2,
              useMagnifier: true,
              onSelectedItemChanged: onChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) => Center(
                  child: Text(
                    '${values[index]}$unit',
                    style: TextStyle(
                      color: selected == index
                          ? AppColors.darkTextSecondaryColor
                          : AppColors.darkTextSecondaryColor.withValues(
                              alpha: 0.65,
                            ),
                      fontSize: 20,
                      fontWeight: selected == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                childCount: values.length,
              ),
            ),
          ),
          // Highlighted rounded border for selected item
          IgnorePointer(
            child: Container(
              width: 120,
              height: itemExtent + 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline, width: 2.5),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rest Timer',
                  style: TextStyle(
                    color: AppColors.darkTextPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.darkTextPrimaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            // Wheels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildWheel(
                  values: minutes,
                  selected: selectedMinute,
                  controller: minController,
                  onChanged: onMinuteChanged,
                  unit: 'm',
                ),
                SizedBox(width: 20),
                buildWheel(
                  values: seconds,
                  selected: selectedSecond,
                  controller: secController,
                  onChanged: onSecondChanged,
                  unit: 's',
                ),
              ],
            ),

            SizedBox(height: 28),
            // Start button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
              ),
              onPressed: () {
                if (onStart != null) onStart!();
                Navigator.of(context).pop();
              },
              child: Text('Start', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
