import 'package:icon/app/modules/fitness_report/widgets/info_card_widget.dart';

class InfoCardData {
  final String icon;
  final String title;
  final String description;
  final bool isGradient;
  final IconType iconType;

  const InfoCardData({
    required this.icon,
    required this.title,
    required this.description,
    this.isGradient = false,
    this.iconType = IconType.asset,
  });
}
