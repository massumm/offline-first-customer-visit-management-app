import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/your_daily_goals_controller.dart';

class YourDailyGoalsView extends GetView<YourDailyGoalsController> {
  const YourDailyGoalsView({super.key});
  @override
  Widget build(BuildContext context) {
    const kBackground = Color(0xFF0F0F0F);
    const kAccent = Color(0xFFE44933);
    final List<Map<String, dynamic>> tabs = [
      {'title': 'All Goals', 'selected': true},
      {'title': 'Active', 'selected': false},
      {'title': 'Discovery', 'selected': false},
    ];
    final List<Map<String, dynamic>> goals = [
      {
        'section': 'Workout',
        'items': [
          {
            'title': 'Workout',
            'value': '45-60 mins',
            'description': 'Complete a workout session',
            'frequency': 'Day',
          },
        ],
      },
      {
        'section': 'Nutrition',
        'items': [
          {
            'title': 'Calorie Intake',
            'value': '2,200 kcal',
            'description': 'Stay within daily calorie target',
            'frequency': 'Everyday',
          },
          {
            'title': 'Protein Intake',
            'value': '150g',
            'description': 'Meet daily protein goal',
            'frequency': 'Everyday',
          },
          {
            'title': 'Meal Frequency',
            'value': '3 meals',
            'description': 'Eat regular meals',
            'frequency': 'Day',
          },
          {
            'title': 'Water Goal',
            'value': '2L',
            'description': 'Drink enough water',
            'frequency': 'Day',
          },
        ],
      },
      {
        'section': 'Mood & Recovery',
        'items': [
          {
            'title': 'Mood Reflection',
            'value': 'Daily',
            'description': 'Reflect on your mood',
            'frequency': 'Night',
          },
          {
            'title': 'Repair Goal',
            'value': '20g',
            'description': 'Consume repair nutrients',
            'frequency': 'Day',
          },
        ],
      },
    ];
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: Text('Your Daily Goals', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: tabs.map((tab) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: tab['selected'] ? kAccent : Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tab['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tab['selected'] ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: goals.length,
              itemBuilder: (context, i) {
                final section = goals[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section['section'],
                      style: TextStyle(
                        color: kAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...List.generate((section['items'] as List).length, (j) {
                      final item = section['items'][j];
                      return GoalListItem(
                        title: item['title'],
                        value: item['value'],
                        description: item['description'],
                        frequency: item['frequency'],
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoalListItem extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final String frequency;
  const GoalListItem({
    Key? key,
    required this.title,
    required this.value,
    required this.description,
    required this.frequency,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: Color(0xFFE44933),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    frequency,
                    style: TextStyle(color: Colors.white38, fontSize: 12),
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
