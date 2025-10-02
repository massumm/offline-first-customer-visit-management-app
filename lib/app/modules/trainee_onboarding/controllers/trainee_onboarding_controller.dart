import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../../base/widgets/custom_toast.dart';
import '../models/trainee_profile_create_model.dart';
import '../repository/trainee_onboarding_repository.dart';

class TraineeOnboardingController extends GetxController {
  // ........... Text Controllers ...............
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController addressCtr = TextEditingController();
  final TextEditingController cityCtr = TextEditingController();
  final TextEditingController countryCtr = TextEditingController();
  final TextEditingController descriptionCtr = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxString selectedGender = ''.obs;
  final RxString fitnessExperience = ''.obs;
  final RxString selectedPartner = ''.obs;
  final RxBool isButtonLoading = false.obs;
  var selectedQualifications = <String>[].obs;
  TextEditingController otherController = TextEditingController();
  TextEditingController customNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxDouble warmDirect = 5.0.obs;
  var selectedReminder = "".obs;
  final options = ["Gym", "Home", "Mixed"];
  final realisticallyTrain = ["1", "2", "3", "4", "5", "6", "7",];
  final sessionBe = ["5 min", "15 min", "30 min", "40 min", "1 hour", "1 hour+",];
  final timePreferTrain = ["Morning", "Afternoon", "Evening", "Flexible"];
  final occupationTraining = ["Sedentary", "Lightly active", "Moderate", "Very active"];
  final achieveEachDay = ["2,500", "5,000", "7,500", "10,000", "12,500",];
  final consistentlyAbility = ["Time", "Energy", "Motivation",];

  final equipmentAccess = [
    "None",
    "Dumbbells",
    "Barbell",
    "Bands",
    "Machines",
    "Other"
  ];

  final preferredTrainingStyle = [
    "General Training",
    "Cardio",
    "Sport-specific",
    "Bodybuilding",
    "Powerlifting",
    "Circuit",
    "HITT",
    "Mixed",
    "Other",
  ];

  final bodyPartsFocus = [
    "Fully body",
    "Abs",
    "Chest",
    "Shoulders",
    "Arms",
    "Back",
    "Glutes",
    "Other",
    "Cardiovascular system",
    "Glutes",
    "Calves",
    "Central Nervous System",
  ];
  //........... Repository ...............
  final TraineeOnboardingRepository _repository = Get.find(
    tag: (TraineeOnboardingRepository).toString(),
  );

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate; // This is now type-safe
    }
  }

  void toggleQualification(String qualification) {
    if (selectedQualifications.contains(qualification)) {
      selectedQualifications.remove(qualification);
    } else {
      selectedQualifications.add(qualification);
    }
  }

  void onDoneButtonPressed() {
    // check all are selected
    if (nameCtr.text.isEmpty ||
        addressCtr.text.isEmpty ||
        cityCtr.text.isEmpty ||
        countryCtr.text.isEmpty ||
        selectedGender.value.isEmpty ||
        selectedDate.value == null) {
      CustomToast.showErrorToast('Please fill all fields');
      return;
    }

    isButtonLoading(true);

    // Store the data to the TraineeProfileCreateModel
    final TraineeProfileCreateModel traineeProfileCreateModel =
        TraineeProfileCreateModel(
          bio: descriptionCtr.text,
          dateOfBirth: selectedDate.value,
          phoneNumber: '1234567890',
          fullAddress: addressCtr.text,
          country: countryCtr.text,
          city: cityCtr.text,
          gender: selectedGender.value,
          experience: fitnessExperience.value,
          partner: selectedPartner.value,
          description: descriptionCtr.text,
          trainingLocation: 'Home',
          equipmentAccess: '',
          preferredTrainingStyle: '',
          daysPerWeek: null,
          sessionLength: '',
          trainingIntensity: null,
          preferredTimeOfDay: '',
          trainingReminder: null,
        );
    // Store to local DB
    _repository
        .storeTraineeProfile(traineeProfileCreateModel)
        .then(
          (_) {
            Get.toNamed(Routes.LOGIN);
            CustomToast.showToast(message: 'Please Login to Create Profile');
            isButtonLoading(false);
          },
          onError: (error) {
            CustomToast.showErrorToast('Something went wrong!');
            isButtonLoading(false);
          },
        );
  }
}
