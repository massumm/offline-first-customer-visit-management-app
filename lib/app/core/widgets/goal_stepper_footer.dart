import 'package:flutter/material.dart';

class GoalStepperFooter extends StatelessWidget {
  final int stepIndex;
  final VoidCallback onPressed;
  final String buttonText;
  const GoalStepperFooter({
    super.key,
    required this.stepIndex,
    required this.onPressed,
    this.buttonText = 'Next',
  });
  @override
  Widget build(BuildContext context) {
    const kAccent = Color(0xFFE44933);
    return Container(
      // 1. Set the background color to transparent
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              // 2. Use AnimatedContainer to animate changes
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 6,
                // The height will animate when stepIndex changes
                height: i == stepIndex ? 26 : 18,
                decoration: BoxDecoration(
                  // The color will animate as well
                  color: i == stepIndex ? kAccent : Colors.white,
                  borderRadius: BorderRadius.circular(48),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
