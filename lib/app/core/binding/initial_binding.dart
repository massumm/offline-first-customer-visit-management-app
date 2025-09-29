import 'package:get/get.dart';

import '../../data/local/preference/preference_service.dart';
import '../../data/local/preference/store/user_store.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageService());
    Get.lazyPut<UserStore>(() => UserStore(), fenix: true);
  }
}