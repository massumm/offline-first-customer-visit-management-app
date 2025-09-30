import 'package:flutter/material.dart';


class BottomPillBar extends StatelessWidget {
  const BottomPillBar({
    super.key,
    required this.index,
    required this.onTap,
    this.hasFab = true,
  });

  final int index;
  final ValueChanged<int> onTap;

  /// If you mount a centered FAB on the Scaffold, keep this true so we reserve the gap.
  final bool hasFab;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF111214);
    final border = Colors.white.withValues(alpha: 0.08);

    // Typical FAB: 56dp + both sides notch margin (defaults to 10 here)
    const notchMargin = 10.0;
    const fabDiameter = 56.0;
    final fabGap = hasFab ? fabDiameter + (notchMargin * 2) : 0.0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomAppBar(
            color: Colors.transparent,
            height: 84,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: notchMargin,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: border, width: 1),
                boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black54)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Left two items
                  Flexible(
                    fit: FlexFit.tight,
                    child: _Item(
                      label: 'Home',
                      icon: Icons.home_outlined,
                      selected: index == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _Item(
                      label: 'Analytic',
                      icon: Icons.show_chart_rounded,
                      selected: index == 1,
                      onTap: () => onTap(1),
                    ),
                  ),

                  // Middle FAB gap (prevents crowding/overflow near the notch)
                  if (fabGap > 0) SizedBox(width: fabGap),

                  // Right two items
                  Flexible(
                    fit: FlexFit.tight,
                    child: _Item(
                      label: 'Community',
                      icon: Icons.groups_rounded,
                      selected: index == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _ProfileItem(
                      label: 'Profile',
                      selected: index == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const inactive = Color(0xFFB9BDC6);
    // keep the same active hue; slightly translucent like your original
    final active = const Color(0xFFE44A3A).withValues(alpha: 200 / 255);

    // Tight paddings keep the height compact and avoid vertical squeeze
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: selected ? active : inactive),
            const SizedBox(height: 4),
            // Cap text scale so large system text won’t overflow the pill
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2)),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: selected ? active : inactive,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const inactive = Color(0xFFB9BDC6);
    const active = Color(0xFFE44A3A);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? active : Colors.transparent,
                  width: selected ? 1.5 : 0,
                ),
              ),
              child: const CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12'),
              ),
            ),
            const SizedBox(height: 4),
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: selected ? active : inactive,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
