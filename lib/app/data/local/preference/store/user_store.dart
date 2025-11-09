import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../core/values/app_keys.dart';
import '../../../../modules/login/models/login_response_model.dart';
import '../preference_service.dart'; // Make sure this path is correct

class UserStore extends GetxService {
  final Logger logger = Logger();

  static UserStore get to => Get.find();

  // Observable for the user's profile
  final Rx<LoginResponseModel?> _profile = Rx<LoginResponseModel?>(null);
  LoginResponseModel? get profile => _profile.value;

  // Observables for login state and token
  final RxBool _isLogin = false.obs;
  bool get isLoggedIn => _isLogin.value;

  final RxString _token = ''.obs;
  String get token => _token.value;

  // final RxString authToken = ''.obs; // If this is different from _token
  // final RxString userEmail = ''.obs;

  // Instance of StorageService, ensured to be initialized by GetX dependency management
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
    logger.i("UserStore initialized and user data loaded (if available).");
  }

  void _loadUserFromStorage() {
    try {
      // Load the authentication token
      final storedToken = _storageService.getString(StorageKeys.STORAGE_USER_TOKEN_KEY);
      if (storedToken.isNotEmpty) {
        _token.value = storedToken;
        _isLogin.value = true; // If a token exists, consider the user logged in
        logger.i("UserStore: Loaded token - ${_token.value}");
      } else {
        _token.value = '';
        _isLogin.value = false;
        logger.i("UserStore: No token found in storage.");
      }

      // Load the user profile
      final profileJson = _storageService.getString(StorageKeys.STORAGE_USER_KEY);
      if (profileJson.isNotEmpty) {
        try {
          final decodedJson = jsonDecode(profileJson);
          _profile.value = LoginResponseModel.fromJson(decodedJson as Map<String, dynamic>);
          logger.i("UserStore: Loaded profile for user"); // Example: logging username
        } catch (e) {
          logger.e("UserStore: Error decoding profile JSON: $e");
          _profile.value = null; // Clear profile if decoding fails
        }
      } else {
        _profile.value = null;
        logger.i("UserStore: No profile found in storage.");
      }

      // If you were storing authToken and userEmail separately, load them here:
      // authToken.value = _storageService.getString('auth_token') ?? '';
      // userEmail.value = _storageService.getString('user_email') ?? '';
      // logger.i("UserStore: Loaded separate authToken - ${authToken.value}, email - ${userEmail.value}");

    } catch (e) {
      logger.e("UserStore: Failed to load user data from storage: $e");
      // Ensure a clean state in case of error
      _token.value = '';
      _profile.value = null;
      _isLogin.value = false;
    }
  }

  Future<void> saveAuthToken(String newToken) async {
    await _storageService.setString(StorageKeys.STORAGE_USER_TOKEN_KEY, newToken);
    _token.value = newToken;
    _isLogin.value = newToken.isNotEmpty;
    // If this token is the primary one, you might not need the separate 'authToken.value = token;'
  }

  // Renamed from getProfile to avoid confusion with the profile getter
  Future<String?> getUserProfileJson() async {
    if (_token.value.isEmpty) return null;
    return _storageService.getString(StorageKeys.STORAGE_USER_KEY);
  }

  Future<void> saveProfileAndToken(LoginResponseModel userProfile) async {
    try {
      final profileJson = jsonEncode(userProfile.toJson()); // Assuming toJson() in your model
      await _storageService.setString(StorageKeys.STORAGE_USER_KEY, profileJson);
      _profile.value = userProfile;

      if (userProfile.access != null && userProfile.access!.isNotEmpty) {
        _token.value = userProfile.access ?? '';
        await saveAuthToken(userProfile.access ?? '');
      }
      _isLogin.value = true;
      logger.i("UserStore: Profile and token saved for user");
    } catch (e) {
      logger.e("UserStore: Error saving profile: $e");
    }
  }

  Future<void> onLogout() async {
    await _storageService.remove(StorageKeys.STORAGE_USER_TOKEN_KEY);
    await _storageService.remove(StorageKeys.STORAGE_USER_KEY);
    _token.value = '';
    _profile.value = null;
    _isLogin.value = false;
    // authToken.value = ''; // Clear if you have separate ones
    // userEmail.value = '';
    logger.i("UserStore: User logged out and data cleared.");
  }
}
