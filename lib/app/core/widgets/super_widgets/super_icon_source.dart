import 'package:flutter/material.dart';

enum SuperIconType { iconData, svgAsset, svgNetwork, imageAsset, imageNetwork }

class SuperIconSource {
  final SuperIconType type;
  final IconData? iconData;
  final String? path;

  const SuperIconSource.icon(this.iconData)
      : type = SuperIconType.iconData,
        path = null;

  const SuperIconSource.svgAsset(this.path)
      : type = SuperIconType.svgAsset,
        iconData = null;

  const SuperIconSource.svgNetwork(this.path)
      : type = SuperIconType.svgNetwork,
        iconData = null;

  const SuperIconSource.imageAsset(this.path)
      : type = SuperIconType.imageAsset,
        iconData = null;

  const SuperIconSource.imageNetwork(this.path)
      : type = SuperIconType.imageNetwork,
        iconData = null;
}
