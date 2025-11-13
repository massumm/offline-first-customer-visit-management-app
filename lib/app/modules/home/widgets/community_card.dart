import 'package:flutter/material.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';

class CommunityCard extends StatelessWidget {
  final Color color;

  const CommunityCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: .2),
              child: Icon(Icons.group_add_outlined, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Spotlight',
                    style: AppTextTheme.titleSmallBold,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Join the weekly challenge and share your progress.',
                    style: AppTextTheme.bodySmallRegular.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
