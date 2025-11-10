import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/generated/assets.dart';

import '../controllers/activity_tracker_controller.dart';
import 'widgets/health_dashboard_card.dart';
import 'widgets/workout_recomendation_card.dart';

class ActivityTrackerView extends BaseView<ActivityTrackerController> {
  ActivityTrackerView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      leading: SizedBox(
        height: 32,
        width: 32,
        child: Center(
          child: ActionPill(onTap: () => Navigator.maybePop(context)),
        ),
      ),
      title: Text('Activity Tracker'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: WorkoutRecommendationCard(
              coachName: 'Coach Mish',
              coachAvatarUrl: Assets.imagesMishIcon,
              title: 'Dumbbell Squat',
              description:
                  'Todays focus is on controlled dumbbell squats, targeting your glutes, quads, and core stability. Maintain a neutral spine and smooth tempo.',
              whyNow:
                  'After two upper-body sessions, it\'s time to balance with a lower-body focus to support compound strength.',
              estimatedMinutes: 20,
              exerciseName: 'Dumbbell Squat',
              totalVolumeKg: 850,
              sets: 5,
              repsPerSetLabel: '8/10',
            ),
          ),
          SliverToBoxAdapter(child: 12.height),
          SliverToBoxAdapter(child: HealthDashboardCard()),
        ],
      ),
    );
  }
}

