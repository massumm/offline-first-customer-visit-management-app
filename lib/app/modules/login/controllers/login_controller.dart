import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/services/theme_service.dart';
import '../../../base/network/exceptions/api_exception.dart';
import '../../../base/network/exceptions/base_exception.dart';
import '../../../base/network/exceptions/network_exception.dart';
import '../../../base/network/exceptions/not_found_exception.dart';
import '../../../base/widgets/custom_toast.dart';
import '../../../data/local/preference/store/user_store.dart';
import '../../../routes/app_pages.dart';
import '../repository/login_repository.dart';


class LoginController extends BaseController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  var obscurePassword = true.obs;
  var rememberMe = false.obs;

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();
  var isLoading = false.obs;

  // .............Theme Data...........
  final ts = Get.find<ThemeService>();

  bool  get isDarkTheme  {
    final platformDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

    return ts.themeMode == ThemeMode.dark ||
        (ts.themeMode == ThemeMode.system && platformDark);
  }

  //............. Repository ...........
  final LoginRepository _loginRepository = Get.find(
    tag: (LoginRepository).toString(),
  );

  

  @override
  void onClose() {
    // emailCtr.dispose();
    // passwordCtr.dispose();
    super.onClose();
  }

  // Email validation logic
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    // Basic email format validation using a regular expression
    // This is a common, though not exhaustive, regex for email validation.
    // For stricter validation, you might consider a more complex regex or a package.
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null; // Return null if validation passes
  }

  String? validatePassword(String? password, {String? email}) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (numericRegex.hasMatch(password)) {
      return "Password cannot consist entirely of digits.";
    }

    // For a production app, consider using a service or a more extensive,
    // securely stored list of common passwords.
    const commonPasswords = {
      '12345678',
      'password',
      '123456',
      '123456789',
      'qwerty',
      '111111',
      'p@ssword',
      'admin'
    };

    if (commonPasswords.contains(password.toLowerCase())) {
      return "Password is too common. Please choose a stronger one.";
    }

    if (email != null && email.isNotEmpty) {
      final username = email.split('@').first;
      // Avoid flagging short usernames that might appear in many words.
      if (username.length > 3 && password.toLowerCase().contains(username.toLowerCase())) {
        return "Password cannot be too similar to your email.";
      }
    }

    return null; // Return null if validation passes
  }


// Add this method to be called on every keystroke in the password field.
  void onPasswordChanged(String password) {
    // Pass the email for the similarity check.
    passwordError.value = validatePassword(password, email: emailCtr.text);
  }

  void onLoginButtonPressed() {
    // Handle login loading
    if(isLoading.isTrue) return;

    // Trigger validation for both email and password
    emailError.value = validateEmail(emailCtr.text);
    passwordError.value = validatePassword(passwordCtr.text);

    // Only proceed with login if there are no errors
    if (emailError.value == null && passwordError.value == null) {
      try{
        isLoading(true);
        final requestBody = {
          "username": emailCtr.text,
          "password": passwordCtr.text,
        };

        _loginRepository.login(requestBody).then((response){

          CustomToast.showSuccessToast('Login successful');
          try{
            UserStore.to.saveProfileAndToken(response).whenComplete(() {
              _handleRoute(response.twoFaEnabled ?? false);
            });
          } catch (e) {
            CustomToast.showErrorToast('An unexpected error occurred');
            "error on save profile".log();
          }
          isLoading(false);
        }, onError: (error){
          isLoading.value = false;
          CustomToast.showErrorToast('Invalid credentials');
        });

      } catch (error) {
        isLoading.value = false;
        CustomToast.showErrorToast('An unexpected error occurred');
        // Handle different types of exceptions
        if (error is NotFoundException) {
          CustomToast.showWarningToast((error as BaseException).description);
        } else if (error is ApiException) {
          CustomToast.showWarningToast((error as BaseException).description);
        } else if (error is NetworkException) {
          CustomToast.showErrorToast('Network error occurred');
        }
      }
    }
  }

  void _handleRoute(bool twoFaEnabled) {
    if(twoFaEnabled) {
       Get.offAndToNamed(Routes.EMAIL_VERIFICATION_OTP); // TODO:HANDLE THE ROUTE
    } else {
      Get.offAndToNamed(Routes.HOME);
    }
  }


  void toRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void toForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
