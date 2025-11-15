import 'package:flutter/material.dart';

class RoutinesCard extends StatelessWidget {
  const RoutinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Routines', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Pick from your saved plans or create a new one.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 12),
        RoutineSectionCard(
          title: 'Full-Body Strength',
          chips: const [
            TagData('45 min', fg: Color(0xFFFB8C00), bg: Color(0xFFFFF3E0)),
            TagData('Total Volume 1,200 kg',
                fg: Color(0xFFB45309), bg: Color(0xFFFEF3C7)),
            TagData('6 Exercises',
                fg: Color(0xFF2E7D32), bg: Color(0xFFE8F5E9)),
            TagData('Icon', fg: Color(0xFF6B7280), bg: Color(0xFFF3F4F6)),
          ],
          initiallyExpanded: false,
          workouts: const [],
        ),
        const SizedBox(height: 12),
        RoutineSectionCard(
          title: 'Upper & Core Focus',
          chips: const [
            TagData('45 min', fg: Color(0xFFFB8C00), bg: Color(0xFFFFF3E0)),
            TagData('Total Volume 1,200 kg',
                fg: Color(0xFFB45309), bg: Color(0xFFFEF3C7)),
            TagData('6 Exercises',
                fg: Color(0xFF2E7D32), bg: Color(0xFFE8F5E9)),
            TagData('User', fg: Color(0xFF6B7280), bg: Color(0xFFF3F4F6)),
          ],
          initiallyExpanded: true,
          workouts: const [
            WorkoutData(
              title: 'Power Push Session',
              durationMin: 20,
              focus: 'Chest, Shoulders, Triceps',
              items: [
                'Warm-Up',
                'Incline Bench Press',
                'Overhead Press',
                'Triceps Dips'
              ],
            ),
            WorkoutData(
              title: 'Power Push Session',
              durationMin: 10,
              focus: 'Chest, Shoulders, Triceps',
              items: [
                'Warm-Up',
                'Incline Bench Press',
                'Overhead Press',
                'Triceps Dips'
              ],
            ),
            WorkoutData(
              title: 'Power Push Session',
              durationMin: 15,
              focus: 'Chest, Shoulders, Triceps',
              items: [
                'Warm-Up',
                'Incline Bench Press',
                'Overhead Press',
                'Triceps Dips'
              ],
            ),
          ],
        ),
      ],
    );
  }
}


class RoutineSectionCard extends StatefulWidget {
  const RoutineSectionCard({
    super.key,
    required this.title,
    required this.chips,
    required this.workouts,
    this.initiallyExpanded = false,
  });

  final String title;
  final List<TagData> chips;
  final List<WorkoutData> workouts;
  final bool initiallyExpanded;

  @override
  State<RoutineSectionCard> createState() => _RoutineSectionCardState();
}

class _RoutineSectionCardState extends State<RoutineSectionCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));
    return Card(
      elevation: 0,
      shape: border,
      color: Colors.white,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          children: [
            // Header row (title + chevron)
            Row(
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(letterSpacing: 0.2)),
                ),
                InkWell(
                  onTap: () => setState(() => _expanded = !_expanded),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Chips
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.chips.map((t) => TagChip(data: t)).toList(),
              ),
            ),
            // Expanded content
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 4),
              secondChild: Column(
                children: [
                  const SizedBox(height: 10),
                  ...widget.workouts
                      .map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: WorkoutItemCard(data: w),
                  ))
                      ,
                ],
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutItemCard extends StatelessWidget {
  const WorkoutItemCard({super.key, required this.data});

  final WorkoutData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                data.items.join(' • '),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black87),
                  children: [
                    const TextSpan(
                        text: 'Focus: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: data.focus),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE11D48), // pink/red
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Start Workout',
                      style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
        // Duration badge (top-right)
        Positioned(
          right: 10,
          top: 8,
          child: TagChip(
            data: TagData(
              '${data.durationMin} min',
              fg: const Color(0xFFEF4444),
              bg: const Color(0xFFFFE4E6),
            ),
            dense: true,
          ),
        ),
      ],
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.data, this.dense = false});

  final TagData data;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        data.label,
        style: TextStyle(
          fontSize: dense ? 11 : 12,
          fontWeight: FontWeight.w700,
          color: data.fg,
          height: 1,
        ),
      ),
    );
  }
}

//--------------------------------- Models --------------------------------

class TagData {
  final String label;
  final Color fg;
  final Color bg;
  const TagData(this.label, {required this.fg, required this.bg});
}

class WorkoutData {
  final String title;
  final int durationMin;
  final String focus;
  final List<String> items;

  const WorkoutData({
    required this.title,
    required this.durationMin,
    required this.focus,
    required this.items,
  });
}