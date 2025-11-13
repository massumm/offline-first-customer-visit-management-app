import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/local/preference/store/user_store.dart';

/// Service to manage subscription status and free message limits
class SubscriptionService extends GetxService {
  final Logger logger = Logger();
  
  static SubscriptionService get to => Get.find();
  
  // Constants
  static const int defaultFreeMessages = 3;
  
  // Dependencies
  final UserStore _userStore = Get.find<UserStore>();
  
  @override
  void onInit() {
    super.onInit();
    logger.i("SubscriptionService initialized");
  }
  
  /// Check if the user can send a message
  /// Returns true if user is premium OR has remaining free messages
  bool canSendMessage() {
    // If user is premium, they can always send messages
    if (_userStore.isPremium) {
      logger.d("User is premium - message allowed");
      return true;
    }
    
    // Check remaining free messages for non-premium users
    final remainingMessages = _userStore.remainingFreeMessages;
    logger.d("Non-premium user has $remainingMessages remaining free messages");
    
    return remainingMessages > 0;
  }
  
  /// Call this method when a message is sent to decrement the counter
  /// Only decrements for non-premium users
  Future<void> onMessageSent() async {
    if (_userStore.isPremium) {
      logger.d("Premium user sent message - no counter decrement");
      return;
    }
    
    final currentCount = _userStore.remainingFreeMessages;
    if (currentCount > 0) {
      await _userStore.decrementFreeMessages();
      logger.i("Message sent - remaining free messages: ${_userStore.remainingFreeMessages}");
    } else {
      logger.w("Message sent but user already at 0 free messages");
    }
  }
  
  /// Check if paywall should be shown
  /// Returns true when user is not premium AND has 0 remaining messages
  bool shouldShowPaywall() {
    if (_userStore.isPremium) {
      return false;
    }
    
    return _userStore.remainingFreeMessages <= 0;
  }
  
  /// Get remaining free messages for non-premium users
  int getRemainingFreeMessages() {
    return _userStore.remainingFreeMessages;
  }
  
  /// Check if user is currently premium
  bool isPremiumUser() {
    return _userStore.isPremium;
  }
  
  /// Reset free messages to default count (used for new users or testing)
  Future<void> resetFreeMessages() async {
    await _userStore.resetFreeMessages();
    logger.i("Free messages reset to $defaultFreeMessages");
  }
  
  /// Update subscription status (will be called after successful IAP)
  Future<void> updateSubscriptionStatus(bool isPremium) async {
    await _userStore.updateSubscriptionStatus(isPremium);
    logger.i("Subscription status updated - isPremium: $isPremium");
  }
  
  /// Get comprehensive subscription status for UI components
  Map<String, dynamic> getSubscriptionStatus() {
    return {
      'isPremium': _userStore.isPremium,
      'remainingFreeMessages': _userStore.remainingFreeMessages,
      'canSendMessage': canSendMessage(),
      'shouldShowPaywall': shouldShowPaywall(),
    };
  }
}
