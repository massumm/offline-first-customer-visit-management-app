import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/widgets/super_image.dart';

import '../../../../generated/assets.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends BaseView<HomeController> {
  HomeView({super.key});

  @override
  Widget body(BuildContext context) {
    final cs = Theme
        .of(context)
        .colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 16),
              _UserHeader(username: controller.username, day: 12, level: 7),
              const SizedBox(height: 16),
              DailyProcressIndicators(controller: controller),
              const SizedBox(height: 16),
              TrainerRegCard(onPressed: () {}),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 520;
                  final actionCards = [
                    _ActionsCard(
                      title: 'Activity',
                      color: const Color(0xFF6E7416), // olive-ish
                      percent: 0.85,
                      lines: const [
                        'Workouts: 2 / 4 this week',
                        'Today: 5.3 km Run',
                        'Record: New 5K Best Time!',
                      ],
                    ),
                    _ActionsCard(
                      title: 'Recovery',
                      color: const Color(0xFFD0473D), // red-ish
                      percent: 0.78,
                      lines: const [
                        'Readiness Score: 78 / 100',
                        'Sleep: 7h 20m',
                        'HRV: 65 ms',
                      ],
                    ),
                  ];

                  if (isWide) {
                    // Wide layout: Row with Expanded children
                    return Row(
                      children: [
                        Expanded(child: actionCards[0]),
                        const SizedBox(width: 16),
                        Expanded(child: actionCards[1]),
                      ],
                    );
                  } else {
                    // Narrow layout: Horizontally scrolling Row
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.8,
                            // Example: Card takes 80% of screen width
                            child: actionCards[0],
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: constraints.maxWidth * 0.8,
                            // Example: Card takes 80% of screen width
                            child: actionCards[1],
                          ),
                          // Add more cards here if needed, and they will scroll horizontally
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              _GoalsCard(onPressed: () {}, ringValue: 0.64),
              const SizedBox(height: 16),
              _CommunityCard(color: cs.secondary),
              const SizedBox(height: 58),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          backgroundColor: const Color(0xFF141518),
          selectedIndex: controller.selectedNavIndex.value,
          onDestinationSelected: (index) {
            controller.selectedNavIndex.value = index;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Analysis',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;
}

class DailyProcressIndicators extends StatelessWidget {
  const DailyProcressIndicators({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => DayCard(item: controller.week[i]),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemCount: controller.week.length,
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({
    required this.username,
    required this.day,
    required this.level,
  });

  final String username;
  final int day;
  final int level;

  @override
  Widget build(BuildContext context) {
    final chipStyle = Theme
        .of(context)
        .textTheme
        .bodyMedium;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning,',
                  style: Theme
                      .of(
                    context,
                  )
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall,
                ),
              ],
            ),
          ),
          _InfoChip(
            icon: Assets.svgMorningIcon,
            label: 'Day $day',
            style: chipStyle,
          ),
          const SizedBox(width: 8),
          _InfoChip(
            icon: Assets.svgLevel7,
            label: 'Level $level',
            style: chipStyle,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.style});

  final String icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SuperImage(icon),
          const SizedBox(width: 6),
          Text(label, style: style),
        ],
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.item});

  final DayItem item;

  @override
  Widget build(BuildContext context) {
    final isToday = item.isToday;

    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFF3A1E1E) : Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isToday
            ? Border.all(color: const Color(0xFFE35D5D), width: 1)
            : null,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ProgressRing(
                value: item.progress,
                thickness: 4,
                trackColor: Colors.white10,
                valueColor: isToday
                    ? AppColors.redProgressColor
                    : AppColors.greenProgressColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(item.label, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 2),
            Text(
              '${item.date}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal circular progress ring (no packages).
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.thickness = 4,
    this.trackColor = Colors.white10,
    this.valueColor = const Color(0xFF6EE7B7),
    this.child,
  });

  final double value; // 0..1
  final double thickness;
  final Color trackColor;
  final Color valueColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RingPainter(
        value: value.clamp(0.0, 1.0),
        thickness: thickness,
        track: trackColor,
        fill: valueColor,
      ),
      child: child,
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.thickness,
    required this.track,
    required this.fill,
  });

  final double value;
  final double thickness;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final valuePaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    // Track
    canvas.drawArc(
      rect.deflate(thickness / 2),
      -math.pi / 2,
      2 * math.pi,
      false,
      trackPaint,
    );

    // Progress arc
    canvas.drawArc(
      rect.deflate(thickness / 2),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.value != value ||
          old.fill != fill ||
          old.track != track ||
          old.thickness != thickness;
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.svgLogo, height: 40),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
    );
  }
}

class _QuickStatsStrip extends StatelessWidget {
  const _QuickStatsStrip();

  @override
  Widget build(BuildContext context) {
    final items = <_StatItem>[
      _StatItem(
        icon: Icons.local_fire_department,
        label: 'Cals',
        value: '1420',
      ),
      _StatItem(icon: Icons.directions_walk, label: 'Steps', value: '8.5k'),
      _StatItem(icon: Icons.favorite, label: 'HR', value: '72'),
      _StatItem(icon: Icons.water_drop, label: 'H2O', value: '1.5L'),
      _StatItem(icon: Icons.hotel, label: 'Sleep', value: '7h 20m'),
      _StatItem(icon: Icons.fitness_center, label: 'Workouts', value: '3x'),
    ];

    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _StatPill(item: items[i]),
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _StatPill extends StatelessWidget {
  final _StatItem item;

  const _StatPill({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 20),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                item.label,
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrainerRegCard extends StatelessWidget {
  final VoidCallback onPressed;

  const TrainerRegCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Color(0xFF1F1F1F), AppColors.colorPrimarySwatch.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: Color(0XFF2B2B2B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Apply to Become a Trainer',
            style: Theme
                .of(
              context,
            )
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Share your passion for fitness and help others reach their goals. Join our community of certified trainers.',
            textAlign: TextAlign.center,
            style: Theme
                .of(
              context,
            )
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onPressed,
            child: const Text(
              'Apply Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double progress;
  final Color? color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = color ?? Theme
        .of(context)
        .colorScheme
        .primary;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _ProgressRing(size: 46, value: progress, color: ringColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme
                        .of(
                      context,
                    )
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  final double ringValue;
  final VoidCallback onPressed;

  const _GoalsCard({required this.ringValue, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Daily Goals',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ' 2/6 (64%) complete • Keep it up!',
                    style: Theme
                        .of(
                      context,
                    )
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: onPressed,
                    label: const Text('Add Goals'),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _ProgressRing(
              size: 74,
              value: ringValue,
              color: AppColors.greenProgressColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthGrid extends StatelessWidget {
  const _HealthGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _HealthCard(
          title: 'Hydration',
          value: '1.5 L',
          icon: Icons.water_drop,
          progress: 0.6,
        ),
        _HealthCard(
          title: 'Heart Rate',
          value: '70 BPM',
          icon: Icons.favorite,
          progress: 0.7,
        ),
        _HealthCard(
          title: 'Calories',
          value: '1,420',
          icon: Icons.local_fire_department,
          progress: 0.5,
        ),
        _HealthCard(
          title: 'Sleep',
          value: '7h 20m',
          icon: Icons.nightlight_round,
          progress: 0.8,
        ),
        _HealthCard(
          title: 'Protein',
          value: '57%',
          icon: Icons.egg,
          progress: 0.57,
        ),
        _HealthCard(
          title: 'Steps',
          value: '8,500',
          icon: Icons.directions_walk,
          progress: 0.85,
        ),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double progress;

  const _HealthCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme
        .of(context)
        .colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: cs.primary),
                ),
                const Spacer(),
                Text(
                  value,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme
                  .of(
                context,
              )
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({
    required this.title,
    required this.color,
    required this.percent,
    required this.lines,
  });

  final String title;
  final Color color;
  final double percent;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final fg = Colors.white;
    final bg = color.withOpacity(0.18);
    final barBg = Colors.white.withOpacity(0.25);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                    color: fg.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
              Icon(Icons.arrow_outward, color: fg.withOpacity(0.9), size: 18),
            ],
          ),
          const SizedBox(height: 10),
          // Big percentage
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(percent * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: percent.clamp(0, 1),
                    minHeight: 10,
                    backgroundColor: barBg,
                    valueColor: AlwaysStoppedAnimation<Color>(fg),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bullet-ish lines
          ...lines.map(
                (t) =>
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    t,
                    style: TextStyle(
                      color: fg.withOpacity(0.92),
                      fontSize: 13,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final Color color;

  const _CommunityCard({required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme
          .of(context)
          .cardColor,
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Join the weekly challenge and share your progress.',
                    style: Theme
                        .of(
                      context,
                    )
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
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

class _ProgressRing extends StatelessWidget {
  final double value; // 0..1
  final double size;
  final double stroke;
  final Color? color;

  const _ProgressRing({
    super.key,
    required this.value,
    this.size = 72,
    this.stroke = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme
        .of(context)
        .colorScheme;
    final ringColor = color ?? cs.primary;
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: stroke,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: Theme
                .of(context)
                .textTheme
                .labelLarge,
          ),
        ],
      ),
    );
  }
}
