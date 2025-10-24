import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/routes/app_pages.dart';

class FitnessReportController extends BaseController {
  final email = ''.obs;
  final isLoading = false.obs;
  final selectedView = 'report'.obs; // 'report', 'introduction', 'profile'

  // Profile data
  final memberSince = 'June 2023'.obs;
  final currentGoal = 'Strength training'.obs;
  final achievements = ['5K Run', 'Weight Loss', 'Consistency Award'].obs;
  final fullName = 'Alex Johnson'.obs;
  final membershipLevel = 'Gold Member'.obs;
  final userEmail = 'alex.johnson@example.com'.obs;
  final lastWorkout = '2 days ago'.obs;

  void updateEmail(String value) => email.value = value;

  bool get isValidEmail => email.value.isNotEmpty && email.value.contains('@');

  void showIntroduction() {
    selectedView.value = 'introduction';
  }

  void showProfileOverview() {
    selectedView.value = 'profile';
  }

  void showReport() {
    selectedView.value = 'report';
  }

  Future<void> generateReport() async {
    if (!isValidEmail) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    isLoading.value = true;
    Get.toNamed(Routes.FITNESS_REPORT_GENERATING);
    
    // TODO: Implement actual report generation
    await Future.delayed(const Duration(seconds: 2)); // Simulate processing
    
    isLoading.value = false;
    Get.toNamed(Routes.REPORT_DISPLAY);
  }
}
