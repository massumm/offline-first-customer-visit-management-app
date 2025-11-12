import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';

import '../../../../generated/assets.dart';
import '../../../core/widgets/action_pill.dart';
import '../../../core/widgets/google_signin_button.dart';
import '../../../core/widgets/input_widgets/adaptive_text_field.dart';
import '../../../core/widgets/super_image.dart';
import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends BaseView<RegisterController> {
  RegisterView({super.key});

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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 32.0,
            ),
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
                  Text("Get Started", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 5),
                  Text(
                    "Create your account now",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  Obx(() {
                    return AdaptiveSuperTextField(
                      controller: controller.nameCtr,
                      hintText: "Name",
                      labelText: 'Full Name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      errorText: controller.nameError.value,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) {},
                    );
                  }),
                  const SizedBox(height: 15),
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
                    children: [
                      Obx(() {
                        return Checkbox(
                          value: controller.agreeToService.value,
                          onChanged: (value) {
                            controller.agreeToService.value = value!;
                          },
                          checkColor: Colors.black,
                          activeColor: Colors.red,
                        );
                      }),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "By signing up, you agree with Icon’s ",

                            style: TextStyle(color: AppColors.subTextColor),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(color: AppColors.subTextColor),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
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
                      onPressed:
                          controller.isLoading.isTrue ||
                              controller.agreeToService.isFalse
                          ? null
                          : controller.onRegisterButtonPressed,
                      child: controller.isLoading.isTrue
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text("Register", style: TextStyle(fontSize: 16)),
                    );
                  }),

                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Or Connect With",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google button
                  GoogleSignInButton(onPressed:  controller.onGoogleLogin),

                  if(Platform.isIOS)...[
                    const SizedBox(height: 10),

                    // Apple button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[800]!),
                          backgroundColor: Colors.grey[900],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.apple, color: Colors.white, size: 24),
                        label: Text(
                          "Sign in with Apple",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: AppColors.colorPrimary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.colorPrimary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAndToNamed(Routes.LOGIN);
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
}
