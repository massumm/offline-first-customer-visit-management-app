import 'package:get/get.dart';

import '../../data/local/preference/preference_service.dart';
import '../../data/local/preference/store/user_store.dart';
import '../theme/services/theme_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>( StorageService(), permanent: true);
    Get.lazyPut<UserStore>(() => UserStore(), fenix: true);

    // ----------- Theme Service -------------------
    Get.lazyPut<ThemeService>(() => ThemeService(), fenix: true);
  }
}