import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/action_pill.dart';
import 'package:icon/app/modules/register/controllers/register_controller.dart';

class TwoFactorVerificationPageView extends BaseView<RegisterController> {
  const TwoFactorVerificationPageView({super.key});

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionPill(onTap: Get.back),
              30.height,

              // Title
              Text(
                "Add an Extra Layer of\nSecurity",
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              12.height,

              // Subtitle
              Text(
                "Protect your account with two-factor\nauthentication.",
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Two-Factor Options
              _buildOptionCard(
                icon: Icons.phone_android_outlined,
                iconColor: const Color(0xFFE9522B),
                iconBgColor: const Color(0xFFFFEBE5),
                title: "SMS Code",
                subtitle: "Receive verification codes via text message",
                onTap: () {
                  // TODO: Navigate to SMS verification
                  // Get.back();
                },
              ),
              16.height,

              _buildOptionCard(
                icon: Icons.qr_code_scanner_outlined,
                iconColor: const Color(0xFFE9522B),
                iconBgColor: const Color(0xFFFFEBE5),
                title: "Authenticator App",
                subtitle: "use apps like Google Authenticator or Authy",
                onTap: () {
                  // TODO: Navigate to authenticator setup
                  // Get.back();
                },
              ),
              16.height,

              Obx(
                () => _buildOptionCard(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFFE9522B),
                  iconBgColor: const Color(0xFFFFEBE5),
                  title: "Email Verification",
                  subtitle: "Get codes sent to your email address",
                  isLoading: controller.isVerifying.value,
                  onTap: controller.isVerifying.value
                      ? null
                      : controller.sendVerificationEmail,
                ),
              ),

              40.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    String? badge,
    bool isLoading = false,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Get.theme.inputDecorationTheme.fillColor,
          border: Border.all(
            color: Get.theme.inputDecorationTheme.border!.borderSide.color,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            16.width,

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      if (badge != null) ...[
                        8.width,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: Get.textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  4.height,
                  Text(
                    subtitle,
                    style: Get.textTheme.bodySmall?.copyWith(
                      height: 1.4,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon or loading indicator
            isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFE9522B),
                    ),
                  )
                : const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}
