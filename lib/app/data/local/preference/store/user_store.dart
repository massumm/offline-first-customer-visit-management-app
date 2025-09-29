import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/app_keys.dart';
import '../../../../modules/login/models/login_response_model.dart';
import '../preference_service.dart';

class UserStore extends GetxController {
  final Logger logger = Logger();

  static UserStore get to => Get.find();

  LoginResponseModel get profile => _profile.value;

  RxString token = ''.obs;
  final RxBool _isLogin = false.obs;
  final Rx<LoginResponseModel> _profile = LoginResponseModel().obs;

  @override
  void onInit() {
    super.onInit();
    token.value =
        StorageService.to.getString(StorageKeys.STORAGE_USER_TOKEN_KEY);
    String profileOffline =
    StorageService.to.getString(StorageKeys.STORAGE_USER_KEY);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(LoginResponseModel.fromJson(jsonDecode(profileOffline)));
    }
  }

  Future<String> getProfile() async {
    if (token.value.isEmpty) return "";
    return StorageService.to.getString(StorageKeys.STORAGE_USER_KEY);
  }

  Future<void> setToken(String value) async {
    await StorageService.to
        .setString(StorageKeys.STORAGE_USER_TOKEN_KEY, value);
    token.value = value;
    token.refresh();
  }

  Future<void> saveProfile(LoginResponseModel profile) async {
    _isLogin.value = true;
    try {
      jsonEncode(profile);
    } catch (e) {
      logger.i(e.toString());
    }
    await StorageService.to.setString(
      StorageKeys.STORAGE_USER_KEY,
      jsonEncode(profile),
    );
    _profile.value = profile;
    await setToken(profile.access ?? "");
  }

  Future<void> onLogout() async {
    await StorageService.to.remove(StorageKeys.STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(StorageKeys.STORAGE_USER_KEY);
    _isLogin.value = false;
    token.value = '';
    _profile.value = LoginResponseModel();
    token.refresh();
  }
}
