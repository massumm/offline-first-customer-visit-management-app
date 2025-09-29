import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/widgets/custom_toast.dart';
import '../../../data/local/preference/store/user_store.dart';
import '../../../routes/app_pages.dart';
import '../repository/login_repository.dart';


class LoginController extends GetxController {
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  var obscurePassword = true.obs;
  var rememberMe = false.obs;

  // TextInput validation error
  var passwordError = RxnString();
  var emailError = RxnString();
  var isLoading = false.obs;

  //............. Repository ...........
  final LoginRepository _loginRepository = Get.find(
    tag: (LoginRepository).toString(),
  );


  @override
  void onClose() {
    emailCtr.dispose();
    passwordCtr.dispose();
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
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
          UserStore.to.saveProfile(response).whenComplete(() {
            isLoading(false);
            Get.offAllNamed(Routes.HOME);
          });
        }, onError: (error){
          isLoading.value = false;
          CustomToast.showErrorToast('Invalid credentials');
        });

      } catch (error) {
        isLoading.value = false;
        CustomToast.showErrorToast('An unexpected error occurred');


        // // Handle different types of exceptions
        // if (error is NotFoundException) {
        //   CustomToast.showWarningToast((error as BaseException).description);
        // } else if (error is ApiException) {
        //   CustomToast.showWarningToast((error as BaseException).description);
        // } else if (error is NetworkException) {
        //   CustomToast.showErrorToast('Network error occurred');
        // }
      }
    }
  }
}
