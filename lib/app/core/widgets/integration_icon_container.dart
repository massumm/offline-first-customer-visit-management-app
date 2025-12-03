import 'package:flutter/material.dart';

class IntegrationIconContainer extends StatelessWidget {
  final String icon;
  final String iconColor;
  final double width;
  final double height;
  final double padding;

  const IntegrationIconContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    this.width = 28,
    this.height = 28,
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Color(int.parse(iconColor, radix: 16)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        icon,
        width: width,
        height: height,
      ),
    );
  }
}
