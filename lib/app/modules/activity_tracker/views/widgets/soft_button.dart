import 'package:flutter/material.dart';

class SoftButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SoftButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Center(
        child: Text(
          'Update Steps',
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}