import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'super_icon_source.dart';

class SuperIcon extends StatelessWidget {
  final SuperIconSource source;
  final double size;
  final Color? color;
  final BoxFit fit;

  const SuperIcon({
    super.key,
    required this.source,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    switch (source.type) {
      case SuperIconType.iconData:
        return Icon(source.iconData, size: size, color: color);

      case SuperIconType.svgAsset:
        return SvgPicture.asset(
          source.path!,
          width: size,
          height: size,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          fit: fit,
        );

      case SuperIconType.svgNetwork:
        return SvgPicture.network(
          source.path!,
          width: size,
          height: size,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          fit: fit,
        );

      case SuperIconType.imageAsset:
        return Image.asset(
          source.path!,
          width: size,
          height: size,
          fit: fit,
          color: color,
        );

      case SuperIconType.imageNetwork:
        return Image.network(
          source.path!,
          width: size,
          height: size,
          fit: fit,
          color: color,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator(color: color));
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, size: size, color: color);
          },
        );
    }
  }
}
