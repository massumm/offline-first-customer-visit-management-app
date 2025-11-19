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
  
  // Subscription/Paywall related observables
  final RxBool _isPremium = false.obs;
  bool get isPremium => _isPremium.value;
  
  final RxInt _remainingFreeMessages = 3.obs; // Default 3 free messages
  int get remainingFreeMessages => _remainingFreeMessages.value;
  
  // Trainer ID getter
  int? get trainerId => _profile.value?.traineeProfile?.trainerId;

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
          _initializeSubscriptionState(); // Initialize subscription state from loaded profile
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
      
      // Initialize subscription state from profile
      _initializeSubscriptionState();
      
      logger.i("UserStore: Profile and token saved for user");
    } catch (e) {
      logger.e("UserStore: Error saving profile: $e");
    }
  }

  /// Initialize subscription state from the current profile
  void _initializeSubscriptionState() {
    if (_profile.value?.traineeProfile != null) {
      final traineeProfile = _profile.value!.traineeProfile!;
      _isPremium.value = traineeProfile.isPremium ?? false;
      _remainingFreeMessages.value = traineeProfile.remainingFreeMessages ?? 3;
      logger.i("UserStore: Initialized subscription state - isPremium: ${_isPremium.value}, remainingMessages: ${_remainingFreeMessages.value}");
    } else {
      // Default values for new users
      _isPremium.value = false;
      _remainingFreeMessages.value = 3;
      logger.i("UserStore: Set default subscription state for new user");
    }
  }

  /// Update the user's subscription status
  Future<void> updateSubscriptionStatus(bool isPremium) async {
    _isPremium.value = isPremium;
    
    if (isPremium) {
      // Reset free message count when user becomes premium
      _remainingFreeMessages.value = 3;
    }
    
    // Update the stored profile if it exists
    if (_profile.value?.traineeProfile != null) {
      final updatedProfile = _profile.value!.traineeProfile!.copyWith(
        isPremium: isPremium,
        remainingFreeMessages: _remainingFreeMessages.value,
      );
      
      final updatedLoginResponse = _profile.value!.copyWith(
        traineeProfile: updatedProfile,
      );
      
      await saveProfileAndToken(updatedLoginResponse);
    }
    
    logger.i("UserStore: Updated subscription status to $isPremium");
  }

  /// Decrement the free message count
  Future<void> decrementFreeMessages() async {
    if (!_isPremium.value && _remainingFreeMessages.value > 0) {
      _remainingFreeMessages.value--;
      
      // Update the stored profile
      if (_profile.value?.traineeProfile != null) {
        final updatedProfile = _profile.value!.traineeProfile!.copyWith(
          remainingFreeMessages: _remainingFreeMessages.value,
        );
        
        final updatedLoginResponse = _profile.value!.copyWith(
          traineeProfile: updatedProfile,
        );
        
        await saveProfileAndToken(updatedLoginResponse);
      }
      
      logger.i("UserStore: Decremented free messages to ${_remainingFreeMessages.value}");
    }
  }

  /// Reset free message count (e.g., for testing or admin purposes)
  Future<void> resetFreeMessages() async {
    _remainingFreeMessages.value = 3;
    
    // Update the stored profile
    if (_profile.value?.traineeProfile != null) {
      final updatedProfile = _profile.value!.traineeProfile!.copyWith(
        remainingFreeMessages: _remainingFreeMessages.value,
      );
      
      final updatedLoginResponse = _profile.value!.copyWith(
        traineeProfile: updatedProfile,
      );
      
      await saveProfileAndToken(updatedLoginResponse);
    }
    
    logger.i("UserStore: Reset free messages to 3");
  }

  /// Check if the user can send a message (either premium or has remaining free messages)
  bool canSendMessage() {
    return _isPremium.value || _remainingFreeMessages.value > 0;
  }

  Future<void> onLogout() async {
    await _storageService.remove(StorageKeys.STORAGE_USER_TOKEN_KEY);
    await _storageService.remove(StorageKeys.STORAGE_USER_KEY);
    _token.value = '';
    _profile.value = null;
    _isLogin.value = false;
    
    // Reset subscription state
    _isPremium.value = false;
    _remainingFreeMessages.value = 3;
    
    // authToken.value = ''; // Clear if you have separate ones
    // userEmail.value = '';
    logger.i("UserStore: User logged out and data cleared.");
  }
}
