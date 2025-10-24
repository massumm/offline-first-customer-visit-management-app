import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';

import '../controllers/fitness_report_controller.dart';

class ReportDisplayView extends BaseView<FitnessReportController> {
  ReportDisplayView({super.key});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'View Your Report',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Introduction by You (Icon)'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  controller.showIntroduction();
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Your Profile Overview'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  controller.showProfileOverview();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Fitness Report',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Report data will be displayed here',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Introduction by You',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Your Fitness Journey',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This personalized introduction explains your fitness goals and progress based on your Icon membership data.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Row(
                    children: [
                      const Icon(Icons.fitness_center, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text('Member since: ${controller.memberSince.value}'),
                    ],
                  )),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.green),
                      const SizedBox(width: 10),
                      Text('Current goal: ${controller.currentGoal.value}'),
                    ],
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Achievements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.achievements
                .map((achievement) => Chip(label: Text(achievement)))
                .toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildProfileView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Profile Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Center(
            child: Text(
              controller.fullName.value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          )),
          const SizedBox(height: 10),
          Obx(() => Center(
            child: Text(
              controller.membershipLevel.value,
              style: const TextStyle(color: Colors.amber),
            ),
          )),
          const SizedBox(height: 30),
          const Text(
            'Profile Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(() => _buildProfileDetailRow('Email', controller.userEmail.value, Icons.email)),
                  const Divider(),
                  Obx(() => _buildProfileDetailRow('Joined', controller.memberSince.value, Icons.calendar_today)),
                  const Divider(),
                  Obx(() => _buildProfileDetailRow('Last Workout', controller.lastWorkout.value, Icons.fitness_center)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.selectedView.value == 'report'
                ? 'Fitness Report'
                : controller.selectedView.value == 'introduction'
                ? 'Introduction'
                : 'Profile Overview',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showBottomSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.selectedView.value) {
          case 'introduction':
            return _buildIntroductionView(context);
          case 'profile':
            return _buildProfileView(context);
          default:
            return _buildReportView(context);
        }
      }),
    );
  }
}
