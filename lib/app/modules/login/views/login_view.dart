import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/widgets/google_signin_button.dart';
import 'package:icon/app/core/widgets/input_widgets/adaptive_text_field.dart';
import 'package:icon/app/core/widgets/super_image.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../generated/assets.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/action_pill.dart';
import '../controllers/login_controller.dart';

class LoginView extends BaseView<LoginController> {
  LoginView({super.key});

  @override
  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildBody(context),
        Positioned(top: 20, left: 16, child: ActionPill(onTap: Get.back)),
        //TODO: Background Effects
        // SuperImage(
        //   Assets.svgBgGradientColor
        // )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          // Use a ConstrainedBox to ensure the content is at least as tall as the viewport.
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Subtract the vertical padding from the max height.
              minHeight: constraints.maxHeight - 32.0,
            ),
            // IntrinsicHeight allows the Column to expand to the parent's height,
            // which is necessary for the Spacer to work.
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  78.height,
                  // Logo
                  controller.isDarkTheme
                      ? SuperImage(Assets.svgIconLogoDark, height: 80)
                      : SuperImage(Assets.svgLogo, height: 80),
                  const SizedBox(height: 10),
                  Text(
                    "Let’s train smarter. Let’s be Iconic",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Log in to your account",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  Obx(() {
                    return AdaptiveSuperTextField(
                      controller: controller.emailCtr,
                      hintText: "abc@example.com",
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      errorText: controller.emailError.value,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) {
                        if (controller.emailError.value != null) {
                          controller.emailError.value = null;
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 15),

                  // Password
                  Obx(() {
                    return AdaptiveSuperTextField(
                      controller: controller.passwordCtr,
                      hintText: "********",
                      labelText: 'Password',
                      isPassword: true,
                      // Control the visibility from your controller
                      obscureText: controller.obscurePassword.value,
                      // Provide a callback to be executed when the internal icon is tapped
                      onTogglePasswordVisibility: () {
                        // Use the GetX .toggle() method for simplicity
                        controller.obscurePassword.toggle();
                      },
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      errorText: controller.passwordError.value,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) {
                        // Call the controller method to perform validation in real time.
                        controller.onPasswordChanged(value);
                      },
                    );
                  }),

                  const SizedBox(height: 10),

                  // Remember me & Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            return Material(
                              type: MaterialType.transparency,
                              child: Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.rememberMe.value = value!;
                                },
                                // ... your other checkbox properties
                              ),
                            );
                          }),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          controller.toForgotPassword();
                        },
                        child: Text(
                          "Forgot password?",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Login button
                  Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.isLoading.isTrue
                          ? null
                          : controller.onLoginButtonPressed,
                      child: controller.isLoading.isTrue
                          ? const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Log in",
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  }),

                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Or Connect With",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google button
                  GoogleSignInButton(onPressed: controller.onGoogleLogin),

                  if (Platform.isIOS) ...[
                    const SizedBox(height: 12),

                    // Apple button
                    SignInWithAppleButton(
                      onPressed: () async {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                            );

                        debugPrint(credential.toString());
                      },
                      style: controller.isDarkTheme
                          ? SignInWithAppleButtonStyle.white
                          : SignInWithAppleButtonStyle.black,

                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                  const Spacer(),

                  // The "Don't have an account?" text, now at the bottom.
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: const TextStyle(
                              color: AppColors.colorPrimary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.colorPrimary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                controller.toRegister();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;
}
