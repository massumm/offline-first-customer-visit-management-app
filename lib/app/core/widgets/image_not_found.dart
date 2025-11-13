import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({
    super.key,
    required this.height,
    this.width,
  });

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: width ?? double.infinity,
    decoration: const BoxDecoration(
      color: AppColors.errorImageBgColor,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: height * 0.3,
          color: AppColors.imageErrorColor,
        ),
        const SizedBox(height: 8),
        Text(
          'Image Not Found',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.imageErrorColor,
            wordSpacing: 2.0,
            fontSize: width != null ? width! * 0.05 : 14,
          ),
        ),
      ],
    ),
  );
}
