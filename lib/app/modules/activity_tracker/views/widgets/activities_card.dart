import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';

class ActivitiesCard extends StatelessWidget {
  const ActivitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Log Activity'),
              const SizedBox(height: 12),
              // Log Activity cards
              Column(
                children: const [
                  ActivityCategoryCard(
                    icon: CupertinoIcons.heart_fill,
                    iconBg: Color(0xFFFEE2E2),
                    iconColor: Color(0xFFDC2626),
                    title: 'Workout',
                    subtitle: 'Functional, HIIT, Weights',
                  ),
                  SizedBox(height: 10),
                  ActivityCategoryCard(
                    icon: CupertinoIcons.heart,
                    iconBg: Color(0xFFE0F2FE),
                    iconColor: Color(0xFF0284C7),
                    title: 'Cardio',
                    subtitle: 'Running, Cycling',
                  ),
                  SizedBox(height: 10),
                  ActivityCategoryCard(
                    icon: CupertinoIcons.person_crop_circle_badge_checkmark,
                    iconBg: Color(0xFFE9D5FF),
                    iconColor: Color(0xFF7C3AED),
                    title: 'Mobility',
                    subtitle: 'Yoga, Stretching, Recovery',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Activity Log', trailing: '12min ago'),
              const SizedBox(height: 12),
              // Activity Log entries
              Column(
                children: const [
                  ActivityLogCard(
                    icon: Icons.directions_run,
                    iconBg: Color(0xFFE0F2FE),
                    title: 'Morning Run',
                    meta: 'Workout · 25 min · 8:10 am',
                  ),
                  SizedBox(height: 10),
                  ActivityLogCard(
                    icon: Icons.fitness_center,
                    iconBg: Color(0xFFFEE2E2),
                    title: 'Upper Body Strength',
                    meta: 'Cardio · 25 min · 7:30 am',
                  ),
                ],
              ),
            ],
          ),
        ),



        const SizedBox(height: 24),

        // const SectionHeader(title: 'Wearable Integration'),
        // const SizedBox(height: 12),
        // Wearable integration grid
        // IntegrationGrid(
        //   items: [
        //     IntegrationItem(
        //       label: 'Apple Health',
        //       icon: CupertinoIcons.app,
        //       status: IntegrationStatus.disconnected,
        //     ),
        //     const IntegrationItem(
        //       label: 'Google Fit',
        //       icon: Icons.monitor_heart,
        //       status: IntegrationStatus.connected,
        //     ),
        //     const IntegrationItem(
        //       label: 'Fitbit',
        //       icon: Icons.watch,
        //       status: IntegrationStatus.disconnected,
        //     ),
        //     const IntegrationItem(
        //       label: 'Garmin',
        //       icon: Icons.watch_outlined,
        //       status: IntegrationStatus.disconnected,
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 32),
      ],
    );
  }
}


class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          title,
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: text.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
          ),
      ],
    );
  }
}

class ActivityCategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ActivityCategoryCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _IconBadge(icon: icon, bg: iconBg, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.right_chevron,
                  size: 18, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityLogCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String meta;
  final VoidCallback? onTap;

  const ActivityLogCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _IconBadge(icon: icon, bg: iconBg, color: const Color(0xFF1F2937)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 2),
                    Text(meta,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: const Color(0xFF6B7280))),
                  ],
                ),
              ),
              const Icon(Icons.north_east, size: 18, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }
}


enum IntegrationStatus { connected, disconnected }

class IntegrationItem {
  final String label;
  final IconData icon;
  final IntegrationStatus status;
  const IntegrationItem({
    required this.label,
    required this.icon,
    required this.status,
  });
}

class IntegrationGrid extends StatelessWidget {
  final List<IntegrationItem> items;
  const IntegrationGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Responsive 2-up layout using Wrap for natural line breaks
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map((e) => SizedBox(
        width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
        child: IntegrationCard(item: e),
      ))
          .toList(),
    );
  }
}

class IntegrationCard extends StatelessWidget {
  final IntegrationItem item;
  const IntegrationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isConnected = item.status == IntegrationStatus.connected;
    final chipBg = isConnected ? const Color(0xFFE7F6EC) : const Color(0xFFF3F4F6);
    final chipFg = isConnected ? const Color(0xFF15803D) : const Color(0xFF6B7280);
    final chipText = isConnected ? 'Connected' : 'Connect';

    return _Surface(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _IconBadge(
              icon: item.icon,
              bg: const Color(0xFFF3F4F6),
              color: const Color(0xFF111827),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                chipText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: chipFg, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Surface extends StatelessWidget {
  final Widget child;
  const _Surface({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color color;
  const _IconBadge({required this.icon, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 22),
    );
    // If you want it circular, swap borderRadius for: shape: BoxShape.circle
  }
}

