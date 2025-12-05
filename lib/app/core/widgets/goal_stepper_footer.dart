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
      color: Color(0xFF0F0F0F),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 6,
                height: i == stepIndex ? 26 : 18,
                decoration: BoxDecoration(
                  color: i == stepIndex ? kAccent : Colors.white,
                  borderRadius: BorderRadius.circular(48),
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
