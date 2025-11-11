import 'package:flutter/material.dart';
import 'package:icon/app/core/values/app_colors.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    this.isLoading,
    required this.label,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.loadingSize = 20,
    this.loadingStrokeWidth = 2,
    this.loadingColor = Colors.white,
    this.gradient,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final bool? isLoading;
  final String label;
  final double width;
  final double borderRadius;
  final double loadingSize;
  final double loadingStrokeWidth;
  final Color loadingColor;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return SizedBox(
        width: width,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            onPressed: isLoading == true ? null : onPressed,
            child: isLoading == true
                ? SizedBox(
                    width: loadingSize,
                    height: loadingSize,
                    child: CircularProgressIndicator(
                      strokeWidth: loadingStrokeWidth,
                      color: loadingColor,
                    ),
                  )
                : Text(label),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: backgroundColor ?? AppColors.colorPrimary,
        ),
        onPressed: isLoading == true ? null : onPressed,
        child: isLoading == true
            ? SizedBox(
                width: loadingSize,
                height: loadingSize,
                child: CircularProgressIndicator(
                  strokeWidth: loadingStrokeWidth,
                  color: loadingColor,
                ),
              )
            : Text(label),
      ),
    );
  }
}
