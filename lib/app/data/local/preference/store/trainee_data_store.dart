import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/app_keys.dart';
import '../preference_service.dart';

class TraineeDataStore extends GetxService {
  final Logger logger = Logger();

  static TraineeDataStore get to => Get.find();


  // Keep this as the internal, private state for the raw onboarding answers
  final Rx<Map<String, dynamic>?> _onboardingData = Rx<Map<String, dynamic>?>(null);

  // Expose the reactive stream publicly
  Rx<Map<String, dynamic>?> get onboardingData => _onboardingData;

  // Getter for non-reactive access to the data
  Map<String, dynamic>? get onboardingDataValue => _onboardingData.value;


  final StorageService _storageService = Get.find<StorageService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.isRegistered<StorageService>()
        ? null
        : Get.putAsync(() => StorageService().init());
    _loadOnboardingDataFromStorage();
    logger.i("TraineeDataStore initialized and onboarding data loaded (if available).");
  }

  void _loadOnboardingDataFromStorage() {
    try {
      // Load the onboarding data JSON string
      final dataJson = _storageService.getString(
        StorageKeys.STORAGE_TRAINEE_ONBOARDING_MODEL_KEY,
      );

      if (dataJson.isNotEmpty) {
        _onboardingData.value = jsonDecode(dataJson) as Map<String, dynamic>;
        logger.i("TraineeDataStore: Loaded onboarding data.");
      } else {
        _onboardingData.value = null;
        logger.i("TraineeDataStore: No onboarding data found in storage.");
      }
    } catch (e) {
      logger.e("TraineeDataStore: Failed to load onboarding data from storage: $e");
      _onboardingData.value = null;
    }
  }

  /// Saves the raw Map data from the onboarding questions to storage.
  Future<void> saveOnboardingData(Map<String, dynamic> data) async {
    try {
      final dataJson = jsonEncode(data);
      await _storageService.setString(
        StorageKeys.STORAGE_TRAINEE_ONBOARDING_MODEL_KEY,
        dataJson,
      );
      // Also update the in-memory state
      _onboardingData.value = data;
      logger.i("TraineeDataStore: Successfully saved onboarding data.");
    } catch (e) {
      logger.e("TraineeDataStore: Error saving onboarding data: $e");
    }
  }

  /// Cleans the onboarding data from storage and memory.
  Future<void> cleanOnboardingData() async {
    try {
      // Clear the data from persistent storage
      await _storageService.remove(StorageKeys.STORAGE_TRAINEE_ONBOARDING_MODEL_KEY);

      // Clear the data from memory
      _onboardingData.value = null;

      logger.i("TraineeDataStore: Cleaned onboarding data from storage and memory.");
    } catch (e) {
      logger.e("TraineeDataStore: Error cleaning onboarding data: $e");
    }
  }
}