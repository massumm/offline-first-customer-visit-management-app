import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:icon/app/base/base_view.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/input_widgets/adaptive_text_field.dart';
import 'package:icon/app/core/widgets/super_image.dart';

import '../../../../generated/assets.dart';
import '../../../core/widgets/back_pill.dart';
import '../controllers/login_controller.dart';

class LoginView extends BaseView<LoginController> {
  LoginView({super.key});

  @override
  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildBody(context),
        Positioned(top: 20, left: 16, child: BackPill(onTap: Get.back)),
        //TODO: Background Effects
        // SuperImage(
        //   Assets.svgBgGradientColor
        // )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and tagline
            controller.isDarkTheme
                ? SuperImage(Assets.svgIconLogoDark)
                : SuperImage(Assets.svgLogo),
            const SizedBox(height: 10),
            Text(
              "Let’s train smarter. Let’s be Iconic",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
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
                // Tell the widget to behave like a password field
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
                  if (controller.passwordError.value != null) {
                    controller.passwordError.value = null;
                  }
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
                    Text("Remember me"),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),

            // // Remember me & Forgot password
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       children: [
            //         Obx(() {
            //           // Wrap the Checkbox with a Material widget
            //           return Material(
            //             // Use transparency to avoid changing the background color
            //             type: MaterialType.transparency,
            //             child: Checkbox(
            //               value: controller.rememberMe.value,
            //               onChanged: (value) {
            //                 controller.rememberMe.value = value!;
            //               },
            //               checkColor: Colors.black,
            //               activeColor: Colors.red,
            //             ),
            //           );
            //         }),
            //         Text("Remember me", style: TextStyle(color: Colors.grey)),
            //       ],
            //     ),
            //     TextButton(
            //       onPressed: () {},
            //       child: Text(
            //         "Forgot password?",
            //         style: TextStyle(color: Colors.grey),
            //       ),
            //     ),
            //   ],
            // ),
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
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text("Log in", style: TextStyle(fontSize: 16)),
              );
            }),

            const SizedBox(height: 20),
            Text("Or Connect With", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            // Google button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[800]!),
                  backgroundColor: Colors.grey[900],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                label: Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

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
                icon: Icon(Icons.apple, color: Colors.white),
                label: Text(
                  "Sign in with Apple",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                text: "Don’t have an account? ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: "Register",
                    style: TextStyle(color: Colors.red),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.toRegister();
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;
}
