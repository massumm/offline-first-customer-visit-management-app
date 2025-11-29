import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

import 'subscription_service.dart';

/// Service to handle all in-app purchase operations
class IAPService extends GetxService {
  final Logger logger = Logger();
  
  static IAPService get to => Get.find();
  
  // IAP instance
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  
  // Stream subscription for purchase updates
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  // Product IDs
  static const String monthlySubscriptionId = 'Icon_Credit_100';
      // 'monthly_subscription_tier1';
  
  // Available products
  final RxList<ProductDetails> _products = <ProductDetails>[].obs;
  List<ProductDetails> get products => _products;
  
  // Purchase state
  final RxBool _isAvailable = false.obs;
  bool get isAvailable => _isAvailable.value;
  
  final RxBool _purchaseInProgress = false.obs;
  bool get purchaseInProgress => _purchaseInProgress.value;
  
  // Dependencies
  late final SubscriptionService _subscriptionService;
  
  @override
  void onInit() {
    super.onInit();
    _subscriptionService = Get.find<SubscriptionService>();
    _initializeIAP();
  }
  
  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
  
  /// Initialize the IAP connection and listeners
  Future<void> _initializeIAP() async {
    try {
      // Check if IAP is available on this device
      _isAvailable.value = await _inAppPurchase.isAvailable();
      
      if (!_isAvailable.value) {
        logger.e('IAP not available on this device');
        return;
      }
      
      // Listen to purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _listenToPurchaseUpdated,
        onDone: () => logger.i('IAP purchase stream closed'),
        onError: (error) => logger.e('IAP purchase stream error: $error'),
      );
      
      // Load available products
      await _loadProducts();
      
      logger.i('IAPService initialized successfully');
    } catch (e) {
      logger.e('Failed to initialize IAP: $e');
    }
  }
  
  /// Load available products from the stores
  Future<void> _loadProducts() async {
    try {
      const Set<String> kIds = <String>{monthlySubscriptionId};
      
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(kIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        logger.w('Products not found: ${response.notFoundIDs}');
      }
      
      if (response.error != null) {
        logger.e('Error loading products: ${response.error}');
        return;
      }
      
      _products.assignAll(response.productDetails);
      logger.i('Loaded ${_products.length} products');
      
      // Log product details for debugging
      for (final product in _products) {
        logger.d('Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      logger.e('Failed to load products: $e');
    }
  }
  
  /// Listen to purchase updates from the store
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      logger.i('Purchase update: ${purchaseDetails.status} for ${purchaseDetails.productID}');
      
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _handlePendingPurchase(purchaseDetails);
          break;
        case PurchaseStatus.purchased:
          _handleSuccessfulPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _handleFailedPurchase(purchaseDetails);
          break;
        case PurchaseStatus.restored:
          _handleRestoredPurchase(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          _handleCanceledPurchase(purchaseDetails);
          break;
      }
      
      // Complete the purchase if it's pending completion
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }
  
  /// Handle pending purchase
  void _handlePendingPurchase(PurchaseDetails purchaseDetails) {
    logger.i('Purchase pending for ${purchaseDetails.productID}');
    _purchaseInProgress.value = true;
    
    // Show loading or pending state to user
    Get.snackbar(
      'Purchase Pending',
      'Your purchase is being processed...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Handle successful purchase
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    logger.i('Purchase successful for ${purchaseDetails.productID}');
    _purchaseInProgress.value = false;
    
    try {
      // Verify the purchase (basic client-side verification)
      if (await _verifyPurchase(purchaseDetails)) {
        // Update user to premium status
        await _subscriptionService.updateSubscriptionStatus(true);
        
        logger.i('User upgraded to premium successfully');
        
        Get.snackbar(
          'Success!',
          'Welcome to Premium! Enjoy unlimited messages.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        
        // Close any open dialogs (paywall)
        if (Get.isDialogOpen == true) {
          Get.back();
        }
      } else {
        logger.e('Purchase verification failed');
        _showPurchaseError('Purchase verification failed. Please contact support.');
      }
    } catch (e) {
      logger.e('Error handling successful purchase: $e');
      _showPurchaseError('An error occurred while activating your subscription.');
    }
  }
  
  /// Handle failed purchase
  void _handleFailedPurchase(PurchaseDetails purchaseDetails) {
    logger.e('Purchase failed for ${purchaseDetails.productID}: ${purchaseDetails.error}');
    _purchaseInProgress.value = false;
    
    String errorMessage = 'Purchase failed. Please try again.';
    
    if (purchaseDetails.error != null) {
      final error = purchaseDetails.error!;
      logger.e('Purchase error code: ${error.code}, message: ${error.message}');
      
      // Customize error message based on error code
      switch (error.code) {
        case 'user_cancelled':
          return; // Don't show error for user cancellation
        case 'payment_invalid':
          errorMessage = 'Payment method is invalid. Please check your payment details.';
          break;
        case 'payment_not_allowed':
          errorMessage = 'Payment not allowed. Please check your account settings.';
          break;
        default:
          errorMessage = error.message;
      }
    }
    
    _showPurchaseError(errorMessage);
  }
  
  /// Handle restored purchase
  void _handleRestoredPurchase(PurchaseDetails purchaseDetails) async {
    logger.i('Purchase restored for ${purchaseDetails.productID}');
    _purchaseInProgress.value = false;
    
    // Treat restored purchase same as successful purchase
    _handleSuccessfulPurchase(purchaseDetails);
  }
  
  /// Handle canceled purchase
  void _handleCanceledPurchase(PurchaseDetails purchaseDetails) {
    logger.i('Purchase canceled for ${purchaseDetails.productID}');
    _purchaseInProgress.value = false;
    // No need to show error message for user cancellation
  }
  
  /// Basic purchase verification (client-side)
  /// Note: For production, you should implement server-side verification
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // Basic checks
      if (purchaseDetails.verificationData.localVerificationData.isEmpty) {
        logger.w('Empty verification data');
        return false;
      }
      
      if (purchaseDetails.productID != monthlySubscriptionId) {
        logger.w('Unknown product ID: ${purchaseDetails.productID}');
        return false;
      }
      
      // For production, implement server-side verification here
      // Send purchaseDetails.verificationData to your backend
      
      logger.i('Purchase verification passed (client-side only)');
      return true;
    } catch (e) {
      logger.e('Purchase verification error: $e');
      return false;
    }
  }
  
  /// Show purchase error to user
  void _showPurchaseError(String message) {
    Get.snackbar(
      'Purchase Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
    );
  }
  
  /// Purchase the monthly subscription
  Future<void> purchaseMonthlySubscription() async {
    if (!_isAvailable.value) {
      _showPurchaseError('In-app purchases are not available on this device.');
      return;
    }
    
    if (_purchaseInProgress.value) {
      logger.w('Purchase already in progress');
      return;
    }
    
    if (_products.isEmpty) {
      logger.w('No products available, reloading...');
      await _loadProducts();
      if (_products.isEmpty) {
        _showPurchaseError('No subscription options available. Please try again later.');
        return;
      }
    }
    
    try {
      final ProductDetails productDetails = _products.firstWhere(
        (product) => product.id == monthlySubscriptionId,
        orElse: () => throw Exception('Monthly subscription product not found'),
      );
      
      _purchaseInProgress.value = true;
      
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
      
      logger.i('Initiating purchase for ${productDetails.id}');
      
      // For subscriptions, use buyNonConsumable
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      
      if (!success) {
        _purchaseInProgress.value = false;
        _showPurchaseError('Failed to initiate purchase. Please try again.');
      }
    } catch (e) {
      _purchaseInProgress.value = false;
      logger.e('Error initiating purchase: $e');
      _showPurchaseError('Failed to start purchase process. Please try again.');
    }
  }
  
  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable.value) {
      _showPurchaseError('In-app purchases are not available on this device.');
      return;
    }
    
    try {
      logger.i('Restoring purchases...');
      await _inAppPurchase.restorePurchases();
      
      Get.snackbar(
        'Restore Complete',
        'If you had any previous purchases, they have been restored.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      logger.e('Error restoring purchases: $e');
      _showPurchaseError('Failed to restore purchases. Please try again.');
    }
  }
  
  /// Get the monthly subscription product details
  ProductDetails? getMonthlySubscriptionProduct() {
    try {
      return _products.firstWhere((product) => product.id == monthlySubscriptionId);
    } catch (e) {
      return null;
    }
  }
}
