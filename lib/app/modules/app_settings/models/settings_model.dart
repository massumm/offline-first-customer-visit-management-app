import 'dart:ui';


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
