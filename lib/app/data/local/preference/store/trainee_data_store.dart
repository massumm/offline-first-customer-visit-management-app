import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/app_keys.dart';
import '../../../../modules/trainee_onboarding/models/trainee_profile_create_model.dart';
import '../preference_service.dart';

class TraineeDataStore extends GetxService {
  final Logger logger = Logger();

  static TraineeDataStore get to => Get.find();


  // Keep this as the internal, private state
  final Rx<TraineeProfileCreateModel?> _traineeModel = Rx<TraineeProfileCreateModel?>(null);

  // Expose the reactive stream publicly
  Rx<TraineeProfileCreateModel?> get traineeModel => _traineeModel;

  // You can keep the old getter for non-reactive access if needed, but rename it
  TraineeProfileCreateModel? get traineeModelValue => _traineeModel.value;


  final StorageService _storageService = Get.find<StorageService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.isRegistered<StorageService>()
        ? null
        : Get.putAsync(() => StorageService().init());
    _loadModelFromStorage();
    logger.i("TraineeDataStore initialized and user data loaded (if available).");
  }

  void _loadModelFromStorage() {
    try {
      // Load the authentication token
      final modelJson = _storageService.getString(
        StorageKeys.STORAGE_TRAINEE_ONBOARDING_MODEL_KEY,
      );

      if (modelJson.isNotEmpty) {
        final decodedJson = jsonDecode(modelJson);
        _traineeModel.value = TraineeProfileCreateModel.fromJson(
          decodedJson as Map<String, dynamic>,
        );
        logger.i("TraineeDataStore: Loaded model for trainee");
      } else {
        _traineeModel.value = null;
        logger.i("TraineeDataStore: No model found in storage.");
      }
    } catch (e) {
      logger.e("TraineeDataStore: Failed to load model from storage: $e");
      _traineeModel.value = null;
    }
  }

  Future<void> saveTraineeModel(TraineeProfileCreateModel model) async {
    try {
      final modelJson = jsonEncode(model.toJson());
      await _storageService.setString(
        StorageKeys.STORAGE_TRAINEE_ONBOARDING_MODEL_KEY,
        modelJson,
      );
    } catch (e) {
      logger.e("TraineeDataStore: Error saving model: $e");
    }
  }

  // Clean method
  Future<void> cleanTraineeData() async {
    try {
      // Clear the model from persistent storage
      await _storageService.remove(StorageKeys.STORAGE_TRAINEE_ONBOARDING_MODEL_KEY);

      // Clear the model from memory
      _traineeModel.value = null;

      logger.i("TraineeDataStore: Cleaned trainee data from storage and memory.");
    } catch (e) {
      logger.e("TraineeDataStore: Error cleaning trainee data: $e");
    }
  }
}
