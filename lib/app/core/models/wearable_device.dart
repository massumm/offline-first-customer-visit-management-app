class WearableDevice {
  final String icon;
  final String title;
  final String connectionStatus;
  final String iconColor;
  final String? description;

  const WearableDevice({
    required this.icon,
    required this.title,
    required this.connectionStatus,
    required this.iconColor,
    this.description,
  });
}
