import 'package:flutter/material.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onFinish;

  const SuccessDialog({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Card Behind
          Container(
            margin: const EdgeInsets.only(top: 48),
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorPrimary,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back arrow
                Align(
                  alignment: Alignment.topLeft,
                  child: BackPill(
                    onTap: () => Navigator.maybePop(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Trainer, you've successfully completed\nonboarding",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subTextColor),
                ),
                24.height,
                // Finish Button
                ElevatedButton(
                  onPressed: onFinish,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.colorPrimary),
                    foregroundColor: AppColors.black11,
                    backgroundColor: AppColors.black11,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Finish',
                    style: TextStyle(color: AppColors.colorPrimary),
                  ),
                ),
              ],
            ),
          ),
          // Orange Icon (floating)
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.colorPrimary,
              child: Icon(Icons.check, size: 36, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
