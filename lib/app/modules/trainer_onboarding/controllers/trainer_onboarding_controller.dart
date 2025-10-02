import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../base/widgets/custom_toast.dart';
import '../repository/tainer_onboarding_repository.dart';

class TrainerOnboardingController extends GetxController {
  //TODO: Implement TrainerOnboardingController

  final count = 0.obs;
  final nameController = TextEditingController();
  final options = ["<1yr", "1-3yrs", "3-5yrs", "5-10yrs", "10yrs+"];
  var selectedQualifications = <String>[].obs;
  var uploadedFiles = <Map<String, String>>[].obs; // {name, size}
  TextEditingController otherController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController customController = TextEditingController();
  var selectedOption = (-1).obs;
  var selectedIndex = (-1).obs;
  RxDouble warmDirect = 5.0.obs;
  RxDouble formalCasual = 6.0.obs;
  RxDouble sciencePreference = 4.0.obs;
  RxDouble humorSerious = 8.0.obs;
  RxDouble empathyAccountability = 6.0.obs;
  RxDouble structureFreedom = 3.0.obs;

  var trainingPlanOptions = [
    "Individualised",
    "Template-Based",
    "Phase-Based",
    "Assessment Driven",
  ].obs;

  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = trainingPlanOptions.removeAt(oldIndex);
    trainingPlanOptions.insert(newIndex, item);
  }

  void toggleQualification(String qualification) {
    if (selectedQualifications.contains(qualification)) {
      selectedQualifications.remove(qualification);
    } else {
      selectedQualifications.add(qualification);
    }
  }

  void addFile(String name, String size) {
    uploadedFiles.add({"name": name, "size": size});
  }

  void removeFile(int index) {
    uploadedFiles.removeAt(index);
  }

  final qualifications = [
    "Personal Training",
    "Strength & Conditioning",
    "Nutrition",
    "Yoga",
    "Pilates",
    "CrossFit",
    "Sports Therapy",
    "Physiology",
    "Olympic Lifting",
    "Mobility",
    "Pre/Post-Natal",
    "Other",
  ];

  final specialism = [
    "Strength",
    "Weight Loss",
    "Hypertrophy",
    "Mobility",
    "Rehabilitation",
    "Endurance",
    "Sports Performance",
    "HIIT",
    "Functional Training",
    "Bodybuilding",
    "Olympic Lifting",
    "Powerlifting",
    "Calisthenics",
    "Group Training",
    "Online Coaching",
    "Mindset Coaching",
    "Nutrition",
    "Recovery",
  ];

  final clientBestConnect = [
    "Beginners",
    "Busy Professionals",
    "Athletes",
    "Rehab Clients",
    "Seniors",
    "All Types",
    "Other",
  ];

  final topicWontCover = [
    "PEDs/Steroids",
    "Mental Health Therapy",
    "Diagnosing Medical Issues",
    "Extreme Diets",
    "Other",
  ];

  final trainingStyle = [
    "Strength Training",
    "HIIT",
    "Circuit Training",
    "Bodybuilding",
    "Functional Fitness",
    "Mobility",
    "Cardio",
    "Sport-Specific",
    "Powerlifting",
    "Olympic Lifting",
    "Calisthenics",
    "Pilates",
    "CrossFit, Yoga",
    "Pilates",
    "Endurance",
    "Corrective Exercise",
    "Endurance",
    "Group Training",
    "Other",
  ];

  final extraSupport = [
    "Injury Rehab",
    "Post-Partum",
    "Chronic Pain",
    "Larger Bodies",
    "Mobility Issues",
    "Neurodiversity",
  ];

  final coachingStyles = [
    {
      "title": "Guide",
      "subtitle": "I help clients find their own path",
      "icon": Icons.route,
    },
    {
      "title": "Motivator",
      "subtitle": "I provide energy and encouragement",
      "icon": Icons.bolt,
    },
    {
      "title": "Teacher",
      "subtitle": "I focus on educating clients",
      "icon": Icons.school,
    },
    {
      "title": "Tough Love",
      "subtitle": "I hold clients accountable with direct feedback",
      "icon": Icons.fitness_center,
    },
  ];

  var selectedCoachingStyle = "".obs;
  var selectedCoachingDescription = "".obs;

  final TrainerOnboardingRepository _repository = Get.find(
    tag: (TrainerOnboardingRepository).toString(),
  );

  final RxBool isCompleting = false.obs;

  void onComplete() {
    isCompleting(true);

    final data = {
      // "bio": "string",
      // "date_of_birth": "2019-08-24",
      // "phone_number": "string",
      // "full_address": "string",
      // "country": "string",
      // "city": "string",
      // "gender": "string",
      "persona_name": nameController.text,
      "persona_description": descriptionController.text,
      "coaching_style_name": selectedCoachingStyle.value,
      "coaching_style_description": selectedCoachingDescription.value,
    };

    _repository
        .createTrainerProfile(data)
        .then(
          (response) {
            CustomToast.showSuccessToast(
              'Trainer Profile Created Successfully',
            );
            isCompleting(false);
            Get.offAllNamed(Routes.HOME);
          },
          onError: (e) {
            CustomToast.showErrorToast(e.toString());
          },
        );
  }
}
