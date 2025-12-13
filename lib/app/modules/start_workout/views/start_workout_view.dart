import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';

import '../controllers/start_workout_controller.dart';

class StartWorkoutView extends BaseView<StartWorkoutController> {
  const StartWorkoutView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: Text('Start Workout'),
    leading: Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: ActionPill(onTap: Get.back, height: 60, width: 60),
    ),
    centerTitle: true,
    actions: [
      ActionPill(
        onTap: () {},
        height: 40,
        width: 40,
        icon: Icons.alarm,
        iconSize: 20,
      ),
      8.width,
      ActionPill(
        onTap: () {},
        height: 40,
        width: 40,
        icon: Icons.settings_outlined,
        iconSize: 20,
      ),
      8.width,
    ],
  );

  @override
  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      slivers: [SliverToBoxAdapter(child: DumbbellSquatCard())],
    );
  }
}

class DumbbellSquatCard extends StatelessWidget {
  const DumbbellSquatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              children: [
                const Icon(Icons.fitness_center, size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Dumbbell Squat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
          ),

          // Rest timer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: const [
                Icon(Icons.alarm, color: Colors.redAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  'Rest Timer',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Table header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'SET',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'PREVIOUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'KG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'REPS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(child: Icon(Icons.check_circle_outline_outlined)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _setRow(
            setLabel: '1',
            previous: '100 kg x 5',
            kg: '100',
            reps: '5',
            score: '6.0',
            active: true,
            progress: 1.0,
          ),

          _restBar('2:00', progress: 0.7),

          _setRow(
            setLabel: 'W',
            previous: '100 kg x 5',
            kg: '100',
            reps: '5',
            score: '7.0',
            active: true,
            progress: 0.85,
          ),

          _restBar('1:01', progress: 0.5),

          _setRow(
            setLabel: '2',
            previous: '90 kg x 5',
            kg: '90',
            reps: '5',
            score: '0.0',
            active: false,
          ),

          _restBar('2:00', progress: 0.0),

          _setRow(
            setLabel: '3',
            previous: '90 kg x 5',
            kg: '90',
            reps: '5',
            score: '0.0',
            active: false,
          ),

          const SizedBox(height: 12),

          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'ADD SET',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Widget _setRow({
  required String setLabel,
  required String previous,
  required String kg,
  required String reps,
  required String score,
  required bool active,
  double progress = 0,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            setLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Text(previous),
              if (setLabel == '1')
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.star, size: 14, color: Colors.amber),
                ),
            ],
          ),
        ),
        Expanded(child: _inputBox(kg)),
        Expanded(child: _inputBox(reps)),
        SizedBox(
          width: 32,
          child: active
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAEA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    score,
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : const Icon(Icons.check_circle_outline),
        ),
      ],
    ),
  );
}

Widget _inputBox(String value) {
  return Container(
    height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFE0E0E0)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(value),
  );
}

Widget _restBar(String time, {required double progress}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
    child: Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: const Color(0xFFFFEAEA),
          valueColor: const AlwaysStoppedAnimation(Color(0xFF8B0000)),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
      ],
    ),
  );
}
