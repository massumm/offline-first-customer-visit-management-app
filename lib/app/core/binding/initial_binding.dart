import 'package:get/get.dart';
import 'package:icon/app/data/local/preference/store/trainee_data_store.dart';

import '../../data/local/preference/preference_service.dart';
import '../../data/local/preference/store/user_store.dart';
import '../controllers/iap_controller.dart';
import '../services/iap_service.dart';
import '../services/subscription_service.dart';
import '../theme/services/theme_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>( StorageService(), permanent: true);
    Get.lazyPut<UserStore>(() => UserStore(), fenix: true);
    Get.lazyPut<TraineeDataStore>(() => TraineeDataStore(), fenix: true);

    // ----------- Subscription & IAP Services -------------------
    Get.lazyPut<SubscriptionService>(() => SubscriptionService(), fenix: true);
    Get.lazyPut<IAPService>(() => IAPService(), fenix: true);
    Get.lazyPut<IAPController>(() => IAPController(), fenix: true);

    // ----------- Theme Service -------------------
    Get.lazyPut<ThemeService>(() => ThemeService(), fenix: true);
  }
}