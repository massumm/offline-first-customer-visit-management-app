import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/base_view.dart';
import '../../../workout/controllers/workout_controller.dart';

class ActivityRepKeyboard extends BaseView<WorkoutController> {
  final TextEditingController textEditingCtl;
  final VoidCallback? onDone;
  final VoidCallback? onRPE;
  final double? initialValue;
  final List<double>? quickValues;

  const ActivityRepKeyboard({
    super.key,
    required this.textEditingCtl,
    this.onDone,
    this.onRPE,
    this.initialValue,
    this.quickValues,
  });

  void _onKeyPress(String value) {
    final currentText = textEditingCtl.text;
    if (value == '⌫') {
      if (currentText.isNotEmpty) {
        textEditingCtl.text = currentText.substring(0, currentText.length - 1);
      }
    } else {
      textEditingCtl.text = currentText + value;
    }

    // else if (value == ',') {
    //   // Only add a dot if not already present
    //   final hasDot = currentText.contains('.');
    //   if (!hasDot) {
    //     textEditingCtl.text = currentText.isEmpty ? '0.' : '$currentText.';
    //   }
    // }
  }

  void _onQuickValuePress(double value) {
    controller.repValue.value = value;
  }

  void _increment() {
    final int currentValue = int.tryParse(textEditingCtl.text) ?? 0;
    textEditingCtl.text = (currentValue + 1).toString();
  }

  void _decrement() {
    final int currentValue = int.tryParse(textEditingCtl.text) ?? 0;
    if (currentValue > 0) {
      textEditingCtl.text = (currentValue - 1).toString();
    }
  }

  @override
  Widget body(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = Colors.black;
    final keyBgColor = isDark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFF3A3A3C);
    final keyTextColor = Colors.white;
    final primaryColor = const Color(0xFFE9522B);

    final List<double> quickVals =
        quickValues ?? [6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Quick value selector
          Obx(() {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              height: controller.repSectionHeight.value,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: quickVals.length + 1,
                itemBuilder: (context, index) {
                  if (index == quickVals.length) {
                    // Info button
                    return Container(
                      width: 30,
                      margin: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: primaryColor,
                          size: 24,
                        ),
                        onPressed: () {
                          // Show info dialog
                        },
                      ),
                    );
                  }

                  final value = quickVals[index];
                  final isSelected = controller.selectedQuickValue == value;

                  return GestureDetector(
                    onTap: () => {_onQuickValuePress(value)},
                    child: Container(
                      width: 40,
                      margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                          color: keyTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16),

          // Keyboard grid
          Column(
            children: [
              // Row 1: 1, 2, 3, dropdown
              Row(
                children: [
                  _buildKey('1', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('2', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('3', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildIconKey(
                    Icons.keyboard_arrow_down,
                    keyBgColor,
                    keyTextColor,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: 4, 5, 6, - and + (side by side, no Expanded nesting)
              Row(
                children: [
                  _buildKey('4', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('5', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('6', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  // - and + as a sub-row, fixed width box
                  SizedBox(
                    width: 95,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildIconKey(
                            Icons.remove,
                            keyBgColor,
                            keyTextColor,
                            _decrement,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildIconKey(
                            Icons.add,
                            keyBgColor,
                            keyTextColor,
                            _increment,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 3: 7, 8, 9, RPE
              Row(
                children: [
                  _buildKey('7', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('8', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('9', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildActionKey('RPE', primaryColor, keyTextColor, onRPE),
                ],
              ),
              const SizedBox(height: 12),

              // Row 4: comma (,), 0, backspace, NEXT
              Row(
                children: [
                  _buildKey('0', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildIconKey(
                    Icons.backspace_outlined,
                    keyBgColor,
                    keyTextColor,
                    () => _onKeyPress('⌫'),
                  ),
                  const SizedBox(width: 12),
                  _buildActionKey('NEXT', primaryColor, keyTextColor, onDone),
                ],
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildKey(String label, Color bgColor, Color textColor) {
    return Expanded(
      child: GestureDetector(
        // onTap: () => _onKeyPress(label),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconKey(
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 95,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }

  Widget _buildActionKey(
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback? onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
