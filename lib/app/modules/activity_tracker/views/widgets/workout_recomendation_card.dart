import 'package:flutter/material.dart';
import 'package:icon/app/core/widgets/super_image.dart';

class WorkoutRecommendationCard extends StatelessWidget {
  const WorkoutRecommendationCard({
    super.key,
    required this.coachName,
    required this.coachAvatarUrl,
    required this.title,
    required this.description,
    required this.whyNow,
    required this.estimatedMinutes,
    required this.exerciseName,
    required this.totalVolumeKg,
    required this.sets,
    required this.repsPerSetLabel,
    this.onViewDetails,
    this.onStartWorkout,
  });

  final String coachName;
  final String coachAvatarUrl;
  final String title;
  final String description;
  final String whyNow;
  final int estimatedMinutes;
  final String exerciseName;
  final int totalVolumeKg;
  final int sets;
  final String repsPerSetLabel;
  final VoidCallback? onViewDetails;
  final VoidCallback? onStartWorkout;

  static const _radius = 18.0;
  static const _red = Color(0xFFEF4444);
  static const _blue = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_blue, _red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_radius + 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 10),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: "Recommended by" + avatar + title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SuperImage(
                  coachAvatarUrl,
                  radius: 100,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended by $coachName',
                        style: text.labelMedium?.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(
                color: const Color(0xFF555B66),
                height: 1.35,
              ),
            ),

            const SizedBox(height: 10),

            // "Why now?" bubble
            _WhyNowBubble(text: whyNow),

            const SizedBox(height: 12),

            // Estimated time row
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    style: text.bodyMedium?.copyWith(color: Colors.black87),
                    children: [
                      const TextSpan(text: 'Estimated time: '),
                      TextSpan(
                        text: '$estimatedMinutes min',
                        style: TextStyle(
                          color: _red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            const SizedBox(height: 10),

            // Stats grid (2 columns)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LabeledValue(label: 'Exercise', value: exerciseName),
                      const SizedBox(height: 10),
                      _LabeledValue(label: 'Sets', value: '$sets'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LabeledValue(
                        label: 'Total Volume',
                        value: '$totalVolumeKg kg',
                      ),
                      const SizedBox(height: 10),
                      _LabeledValue(label: 'Reps/Set', value: repsPerSetLabel),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewDetails ?? () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStartWorkout ?? () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Start Workout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.labelSmall?.copyWith(
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _WhyNowBubble extends StatelessWidget {
  const _WhyNowBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txt = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why now?',
            style: txt.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: txt.bodyMedium?.copyWith(
              color: const Color(0xFF4B5563),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}