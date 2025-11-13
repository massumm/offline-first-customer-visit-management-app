import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/app_keys.dart';
import '../../../../flavors/build_config.dart';
import '../preference_service.dart';

class OnboardingStore extends GetxController {
  static OnboardingStore get to => Get.find();

  final RxBool _isOnboardingShown = false.obs;
  final Logger logger = BuildConfig.instance.config.logger;

  bool get isOnBoardingShown => _isOnboardingShown.value;

  @override
  onInit() {
    super.onInit();
    _isOnboardingShown.value =
        StorageService.to.getBool(StorageKeys.STORAGE_ONBOARDING_SHOWN_KEY);
  }

  Future<void> setOnBoardingShownValue(bool value) async {
    await StorageService.to.setBool(
      StorageKeys.STORAGE_ONBOARDING_SHOWN_KEY,
      value,
    );
    _isOnboardingShown.value = value;
    logger.i("Onboarding Value: $value");
  }
}
