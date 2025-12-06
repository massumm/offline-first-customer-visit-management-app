import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:icon/generated/assets.dart';

class SettingsModel {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onTap;

  SettingsModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
  });
}
