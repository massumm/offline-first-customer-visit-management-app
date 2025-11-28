import 'package:flutter/material.dart';
import 'package:icon/app/modules/full_body_tracker/utils/theme_helpers.dart';

class WorkoutImageWidget extends StatelessWidget {
  final String imageAsset;
  final Color? color;

  const WorkoutImageWidget({super.key, required this.imageAsset, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      width: 76,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ?? ThemeHelpers.secondaryCardColor,
      ),
      child: Image.asset(imageAsset, fit: BoxFit.contain),
    );
  }
}
