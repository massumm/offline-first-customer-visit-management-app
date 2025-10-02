import 'package:get/get.dart';

import '../modules/activity_tracker/bindings/activity_tracker_binding.dart';
import '../modules/activity_tracker/views/activity_tracker_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile_create_animation/bindings/profile_create_animation_binding.dart';
import '../modules/profile_create_animation/views/profile_create_animation_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/trainee_onboarding/bindings/trainee_onboarding_binding.dart';
import '../modules/trainee_onboarding/views/trainee_onboarding_view.dart';
import '../modules/trainer_onboarding/bindings/trainer_onboarding_binding.dart';
import '../modules/trainer_onboarding/views/trainer_onboarding_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.ACTIVITY_TRACKER,
          page: () =>  ActivityTrackerView(),
          binding: ActivityTrackerBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      // middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.TRAINEE_ONBOARDING,
      page: () => const TraineeOnboardingView(),
      binding: TraineeOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.TRAINER_ONBOARDING,
      page: () => const TrainerOnboardingView(),
      binding: TrainerOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_CREATE_ANIMATION,
      page: () => const ProfileCreateAnimationView(),
      binding: ProfileCreateAnimationBinding(),
    ),
  ];
}
