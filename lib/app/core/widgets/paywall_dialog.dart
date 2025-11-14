import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controllers/iap_controller.dart';
import '../services/subscription_service.dart';
import '../theme/services/theme_service.dart';

/// Paywall dialog to prompt users for subscription after free messages are exhausted
class PaywallDialog extends StatelessWidget {
  const PaywallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final iapController = Get.find<IAPController>();
    final subscriptionService = Get.find<SubscriptionService>();
    final themeService = Get.find<ThemeService>();
    
    // Check platform and theme for styling
    final isIOS = GetPlatform.isIOS;
    final isDarkMode = themeService.isDarkMode;
    
    return Obx(() {
      if (isIOS) {
        return _buildCupertinoDialog(context, iapController, subscriptionService, isDarkMode);
      } else {
        return _buildMaterialDialog(context, iapController, subscriptionService, isDarkMode);
      }
    });
  }
  
  /// Build Cupertino-style dialog for iOS
  Widget _buildCupertinoDialog(
    BuildContext context,
    IAPController iapController,
    SubscriptionService subscriptionService,
    bool isDarkMode,
  ) {
    return CupertinoAlertDialog(
      title: const Text(
        'Upgrade to Continue',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          _buildSubscriptionCard(iapController, isDarkMode, true),
          const SizedBox(height: 12),
          Text(
            'Note: The app is in beta with features under development.',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Get.back(),
          child: const Text(
            'Cancel',
            style: TextStyle(fontFamily: 'Inter'),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () => _handleRestorePurchases(iapController),
          child: const Text(
            'Restore',
            style: TextStyle(fontFamily: 'Inter'),
          ),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: iapController.isPurchasing 
            ? null 
            : () => _handleSubscription(iapController),
          child: iapController.isPurchasing
            ? const CupertinoActivityIndicator()
            : const Text(
                'Subscribe',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
        ),
      ],
    );
  }
  
  /// Build Material-style dialog for Android
  Widget _buildMaterialDialog(
    BuildContext context,
    IAPController iapController,
    SubscriptionService subscriptionService,
    bool isDarkMode,
  ) {
    return Dialog(
      backgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upgrade to Continue',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ve used all your free messages',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 24),
            _buildSubscriptionCard(iapController, isDarkMode, false),
            const SizedBox(height: 16),
            Text(
              'Note: The app is in beta with features under development.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontStyle: FontStyle.italic,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: iapController.isPurchasing 
                  ? null 
                  : () => _handleSubscription(iapController),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE55C37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: iapController.isPurchasing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Get started',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _handleRestorePurchases(iapController),
                  child: Text(
                    'Restore',
                    style: TextStyle(
                      color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '•',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build subscription card with gradient and features
  Widget _buildSubscriptionCard(
    IAPController iapController, 
    bool isDarkMode,
    bool isCompact,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
            ? [
                const Color(0xFF3A3A3C),
                const Color(0xFF2C2C2E),
              ]
            : [
                const Color(0xFFE3F2FD),
                const Color(0xFFFCE4EC),
              ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
            ? Colors.grey[800]! 
            : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Core plan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            iapController.getMonthlySubscriptionPrice(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            'Unlimited messages with Mish Icon',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            'Priority access to new features',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            'Enhanced activity tracking',
            isDarkMode,
          ),
        ],
      ),
    );
  }
  
  /// Build feature item with checkmark
  Widget _buildFeatureItem(String text, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFE55C37).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.check,
            size: 14,
            color: Color(0xFFE55C37),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
  
  /// Handle subscription purchase
  void _handleSubscription(IAPController iapController) async {
    try {
      await iapController.purchaseSubscription();
    } catch (e) {
      // Error handling is done in the controller
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Handle restore purchases
  void _handleRestorePurchases(IAPController iapController) async {
    try {
      await iapController.restorePurchases();
    } catch (e) {
      // Error handling is done in the controller
      Get.snackbar(
        'Error',
        'Failed to restore purchases. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}