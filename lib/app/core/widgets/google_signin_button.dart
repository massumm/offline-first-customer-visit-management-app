import 'package:flutter/material.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:icon/generated/assets.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;

  const GoogleSignInButton({super.key, required this.onPressed, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        minimumSize: Size(width, 44),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SuperImage(
            Assets.svgGoogleIcon,
            height: 20.0,
          ),
          const SizedBox(width: 12),
          Text(
            'Sign in with Google',
            style: textTheme.titleSmall?.copyWith(

            ),
          ),
        ],
      ),
    );
  }
}
