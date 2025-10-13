import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:icon/app/core/widgets/super_image.dart';

import '../../../../generated/assets.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and tagline
              SuperImage(Assets.svgLogo),
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
                return TextField(
                  controller: controller.emailCtr,
                  style: TextStyle(color: Colors.red),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  // Add onChanged to clear error when user types
                  onChanged: (value) {
                    if (controller.emailError.value != null) {
                      controller.emailError.value = null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "abc@example.com",
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    // Display email error text
                    errorText: controller.emailError.value,
                    errorStyle: TextStyle(color: Colors.redAccent),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.redAccent, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 15),

              // Password
              Obx(() {
                return TextField(
                  controller: controller.passwordCtr,
                  obscureText: controller.obscurePassword.value,
                  style: TextStyle(color: Colors.white),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    if (controller.passwordError.value != null) {
                      controller.passwordError.value = null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "********",
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.isFalse
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        controller.obscurePassword.value =
                            !controller.obscurePassword.value;
                      },
                    ),
                    errorText: controller.passwordError.value,
                    errorStyle: TextStyle(color: Colors.redAccent),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.redAccent, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
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
                        return Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) {
                            controller.rememberMe.value = value!;
                          },
                          checkColor: Colors.black,
                          activeColor: Colors.red,
                        );
                      }),
                      Text("Remember me", style: TextStyle(color: Colors.grey)),
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
                      ? null : controller.onLoginButtonPressed,
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
      ),
    );
  }
}
