import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/app_keys.dart';
import '../../../../modules/trainee_onboarding/models/trainee_profile_create_model.dart';
import '../preference_service.dart';

class TraineeDataStore extends GetxService {
  final Logger logger = Logger();

  static TraineeDataStore get to => Get.find();

  final Rx<TraineeProfileCreateModel?> _traineeModel =
  Rx<TraineeProfileCreateModel?>(null);

  TraineeProfileCreateModel? get traineeModel => _traineeModel.value;

  final StorageService _storageService = Get.find<StorageService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await Get.isRegistered<StorageService>()
        ? null
        : Get.putAsync(() => StorageService().init());
    _loadModelFromStorage();
    logger.i("UserStore initialized and user data loaded (if available).");
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
        logger.i("UserStore: Loaded model for trainee");
      } else {
        _traineeModel.value = null;
        logger.i("UserStore: No model found in storage.");
      }
    } catch (e) {
      logger.e("UserStore: Failed to load model from storage: $e");
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
      logger.e("UserStore: Error saving model: $e");
    }
  }
}
