import 'package:flutter/material.dart';

class ActionPill extends StatelessWidget {
  const ActionPill({
    super.key,
    required this.onTap,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.height = 32,
    this.width = 32,
    this.iconSize = 16,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double height;
  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: theme.iconTheme.color),
      ),
    );
  }
}
