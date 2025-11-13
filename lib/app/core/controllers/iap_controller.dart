import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../base/base_controller.dart';
import '../services/iap_service.dart';

/// Controller to manage IAP UI interactions and state
class IAPController extends BaseController {
  // Dependencies
  late final IAPService _iapService;
  
  // Reactive variables
  final RxList<ProductDetails> _products = <ProductDetails>[].obs;
  List<ProductDetails> get products => _products;
  
  final RxBool _isPurchasing = false.obs;
  bool get isPurchasing => _isPurchasing.value;
  
  @override
  void onInit() {
    super.onInit();
    _iapService = Get.find<IAPService>();
    _initializeController();
  }
  
  /// Initialize controller and load products
  void _initializeController() {
    // Initial load of products and state
    _refreshProducts();
    
    logger.i('IAPController initialized');
  }
  
  /// Refresh products and purchase state from IAP service
  void _refreshProducts() {
    _products.assignAll(_iapService.products);
    _isPurchasing.value = _iapService.purchaseInProgress;
    
    logger.d('IAPController: Refreshed - products: ${_products.length}, purchasing: ${_isPurchasing.value}');
  }
  
  /// Purchase monthly subscription - called from UI
  Future<void> purchaseSubscription() async {
    try {
      logger.i('IAPController: Starting subscription purchase');
      
      if (_isPurchasing.value) {
        logger.w('Purchase already in progress');
        return;
      }
      
      if (!_iapService.isAvailable) {
        logger.e('IAP service not available');
        Get.snackbar(
          'Error',
          'In-app purchases are not available on this device.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      showLoading();
      await _iapService.purchaseMonthlySubscription();
      hideLoading();
      
    } catch (e) {
      hideLoading();
      logger.e('Error in purchaseSubscription: $e');
      
      Get.snackbar(
        'Error',
        'Failed to start purchase. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Restore previous purchases - called from UI
  Future<void> restorePurchases() async {
    try {
      logger.i('IAPController: Restoring purchases');
      
      if (!_iapService.isAvailable) {
        Get.snackbar(
          'Error',
          'In-app purchases are not available on this device.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      showLoading();
      await _iapService.restorePurchases();
      hideLoading();
      
    } catch (e) {
      hideLoading();
      logger.e('Error in restorePurchases: $e');
      
      Get.snackbar(
        'Error',
        'Failed to restore purchases. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Get the monthly subscription product for display
  ProductDetails? getMonthlySubscription() {
    return _iapService.getMonthlySubscriptionProduct();
  }
  
  /// Check if IAP is available
  bool get isIAPAvailable => _iapService.isAvailable;
  
  /// Get formatted price for monthly subscription
  String getMonthlySubscriptionPrice() {
    final product = getMonthlySubscription();
    return product?.price ?? '£5.00'; // Fallback price
  }
  
  /// Get subscription title for display
  String getMonthlySubscriptionTitle() {
    final product = getMonthlySubscription();
    return product?.title ?? 'Monthly Premium Subscription';
  }
  
  /// Check if products are loaded
  bool get hasProducts => _products.isNotEmpty;
}
