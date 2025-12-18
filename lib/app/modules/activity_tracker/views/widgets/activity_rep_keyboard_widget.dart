import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityRepKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onDone;
  final VoidCallback? onRPE;
  final double? initialValue;
  final List<double>? quickValues;

  const ActivityRepKeyboard({
    super.key,
    required this.controller,
    this.onDone,
    this.onRPE,
    this.initialValue,
    this.quickValues,
  });

  @override
  State<ActivityRepKeyboard> createState() => _ActivityRepKeyboardState();
}

class _ActivityRepKeyboardState extends State<ActivityRepKeyboard> {
  double? selectedQuickValue;

  @override
  void initState() {
    super.initState();
    selectedQuickValue = widget.initialValue;
  }

  void _onKeyPress(String value) {
    final currentText = widget.controller.text;
    
    if (value == '⌫') {
      if (currentText.isNotEmpty) {
        widget.controller.text = currentText.substring(0, currentText.length - 1);
      }
    } else if (value == '.') {
      if (!currentText.contains('.')) {
        widget.controller.text = currentText.isEmpty ? '0.' : '$currentText.';
      }
    } else {
      widget.controller.text = currentText + value;
    }
  }

  void _onQuickValuePress(double value) {
    setState(() {
      selectedQuickValue = value;
      widget.controller.text = value.toString();
    });
  }

  void _increment() {
    final currentValue = double.tryParse(widget.controller.text) ?? 0;
    widget.controller.text = (currentValue + 1).toString();
  }

  void _decrement() {
    final currentValue = double.tryParse(widget.controller.text) ?? 0;
    if (currentValue > 0) {
      widget.controller.text = (currentValue - 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFF2C2C2E);
    final keyBgColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFF3A3A3C);
    final keyTextColor = Colors.white;
    final primaryColor = const Color(0xFFE9522B);

    final quickVals = widget.quickValues ?? 
        [6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick value selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickVals.length + 1,
              itemBuilder: (context, index) {
                if (index == quickVals.length) {
                  // Info button
                  return Container(
                    width: 50,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: keyBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.info_outline, color: primaryColor, size: 24),
                      onPressed: () {
                        // Show info dialog
                      },
                    ),
                  );
                }
                
                final value = quickVals[index];
                final isSelected = selectedQuickValue == value;
                
                return GestureDetector(
                  onTap: () => _onQuickValuePress(value),
                  child: Container(
                    width: 60,
                    margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : keyBgColor,
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
          ),
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
                  _buildIconKey(Icons.keyboard_arrow_down, keyBgColor, keyTextColor, () {
                    Navigator.pop(context);
                  }),
                ],
              ),
              const SizedBox(height: 12),
              
              // Row 2: 4, 5, 6, - +
              Row(
                children: [
                  _buildKey('4', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('5', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('6', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildIconKey(Icons.remove, keyBgColor, keyTextColor, _decrement),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildIconKey(Icons.add, keyBgColor, keyTextColor, _increment),
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
                  _buildActionKey('RPE', primaryColor, keyTextColor, widget.onRPE),
                ],
              ),
              const SizedBox(height: 12),
              
              // Row 4: comma, 0, backspace, NEXT
              Row(
                children: [
                  _buildKey(',', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildKey('0', keyBgColor, keyTextColor),
                  const SizedBox(width: 12),
                  _buildIconKey(Icons.backspace_outlined, keyBgColor, keyTextColor, () => _onKeyPress('⌫')),
                  const SizedBox(width: 12),
                  _buildActionKey('NEXT', primaryColor, keyTextColor, widget.onDone),
                ],
              ),
            ],
          ),
          
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildKey(String label, Color bgColor, Color textColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onKeyPress(label),
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

  Widget _buildIconKey(IconData icon, Color bgColor, Color iconColor, VoidCallback? onTap) {
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
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(String label, Color bgColor, Color textColor, VoidCallback? onTap) {
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

// Helper function to show the keyboard
void showActivityRepKeyboard(
  BuildContext context, {
  required TextEditingController controller,
  VoidCallback? onDone,
  VoidCallback? onRPE,
  double? initialValue,
  List<double>? quickValues,
}) {
  // Dismiss system keyboard
  FocusScope.of(context).unfocus();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ActivityRepKeyboard(
      controller: controller,
      onDone: () {
        Navigator.pop(context);
        onDone?.call();
      },
      onRPE: () {
        Navigator.pop(context);
        onRPE?.call();
      },
      initialValue: initialValue,
      quickValues: quickValues,
    ),
  );
}
