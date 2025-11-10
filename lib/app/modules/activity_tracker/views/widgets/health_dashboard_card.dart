import 'package:flutter/material.dart';

class HealthDashboardCard extends StatelessWidget {
  const HealthDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    const rose = Color(0xFFE11D48);

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.08,
            children: [
              MetricCard(
                title: 'Steps',
                icon: Icons.directions_walk,
                value: '8,547',
                unit: 'steps',
                detailText: '8500/10,000 steps',
                progress: 0.8547,
                accent: rose,
                buttonText: 'Update Steps',
                onPressed: () => _toast(context, 'Steps updated'),
              ),
              MetricCard(
                title: 'Calories',
                icon: Icons.local_fire_department,
                value: '420',
                unit: 'kcal',
                detailText: '200/500 kcal',
                progress: 0.40,
                accent: rose,
                buttonText: 'Update Steps',
                onPressed: () => _toast(context, 'Calories target changed'),
              ),
              HeartRateCard(
                title: 'Heart Rate',
                valueBpm: 72,
                minBpm: 60,
                maxBpm: 90,
                accent: rose,
                buttonText: 'Update Steps',
                onPressed: () => _toast(context, 'Heart rate source refreshed'),
              ),
              MetricCard(
                title: 'Active Minutes',
                icon: Icons.access_time,
                value: '45',
                unit: 'min',
                detailText: '40/60 min',
                progress: 0.75,
                accent: rose,
                buttonText: 'Update Steps',
                onPressed: () => _toast(context, 'Active minutes synced'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 42)
            ),
            child: Text('Load more'),),

        ],
      ),
    );
  }

  static void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String unit;
  final String detailText;
  final double progress; // 0..1
  final Color accent;
  final String buttonText;
  final VoidCallback onPressed;

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    required this.detailText,
    required this.progress,
    required this.accent,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(title: title, icon: icon, accent: accent),
          const SizedBox(height: 4),
          _BigStat(value: value, unit: unit),
          const SizedBox(height: 4),
          Text(
            detailText,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12.5,
              height: 1.2,
            ),
          ),
          const Spacer(),
          TinyProgressBar(value: progress, color: accent),
          const Spacer(),
          _SoftButton(text: buttonText, onPressed: onPressed),
        ],
      ),
    );
  }
}

class HeartRateCard extends StatelessWidget {
  final String title;
  final int valueBpm;
  final int minBpm;
  final int maxBpm;
  final Color accent;
  final String buttonText;
  final VoidCallback onPressed;

  const HeartRateCard({
    super.key,
    required this.title,
    required this.valueBpm,
    required this.minBpm,
    required this.maxBpm,
    required this.accent,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = ((valueBpm - minBpm) / (maxBpm - minBpm))
        .clamp(0.0, 1.0)
        .toDouble();

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(title: title, icon: Icons.favorite_border, accent: accent),
          const SizedBox(height: 4),
          _BigStat(value: '$valueBpm', unit: 'bpm'),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_MiniLabel('min: $minBpm'), _MiniLabel('max: $maxBpm')],
          ),
          const SizedBox(height: 6),
          TinyProgressBar(value: clamped, color: accent),
          const Spacer(),
          _SoftButton(text: buttonText, onPressed: onPressed),
        ],
      ),
    );
  }
}

/// ———————————————————— UI building blocks ————————————————————

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;

  const _TitleRow({
    required this.title,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Icon(icon, color: accent, size: 20),
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String unit;

  const _BigStat({required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
        const SizedBox(width: 6),
        Text(unit, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
      ],
    );
  }
}

class _MiniLabel extends StatelessWidget {
  final String text;

  const _MiniLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade700, fontSize: 12.5),
    );
  }
}

class TinyProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;

  const TinyProgressBar({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final bg = color.withValues(alpha: 0.15);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final filled = (w * value.clamp(0, 1)).toDouble();

        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: filled,
              height: 8,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF241814),
                    Color(0xFFE9522B),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }

}

class _SoftButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SoftButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Center(
        child: Text(
          'Update Steps',
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
