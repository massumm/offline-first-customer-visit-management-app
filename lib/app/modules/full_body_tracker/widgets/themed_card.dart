import 'package:flutter/material.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool isPrimary;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.isPrimary = true,
  });

  const ThemedCard.primary({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
  }) : isPrimary = true;

  const ThemedCard.secondary({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
  }) : isPrimary = false;

  Color get _cardColor => isPrimary 
      ? ThemeHelpers.primaryCardColor 
      : ThemeHelpers.secondaryCardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor,
      ),
      child: child,
    );
  }
}
