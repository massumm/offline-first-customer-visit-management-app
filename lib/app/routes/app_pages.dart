import 'package:get/get.dart';

import '../modules/activity_tracker/bindings/activity_tracker_binding.dart';
import '../modules/activity_tracker/views/activity_tracker_view.dart';
import '../modules/fitness_report/bindings/fitness_report_binding.dart';
import '../modules/fitness_report/views/report_display_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/icon_chat/bindings/icon_chat_binding.dart';
import '../modules/icon_chat/views/icon_chat_view.dart';
import '../modules/icon_profile/bindings/icon_profile_binding.dart';
import '../modules/icon_profile/views/icon_profile_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/otp_validation/bindings/otp_validation_binding.dart';
import '../modules/otp_validation/views/otp_validation_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/email_verification_otp_page_view.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register/views/two_factor_success_page_view.dart';
import '../modules/register/views/two_factor_verification_page_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/trainee_fitness_report_generation/bindings/trainee_fitness_report_generation_binding.dart';
import '../modules/trainee_fitness_report_generation/views/trainee_fitness_report_generation_view.dart';
import '../modules/trainee_onboarding/bindings/trainee_onboarding_binding.dart';
import '../modules/trainee_onboarding/views/trainee_onboarding_view.dart';
import '../modules/trainee_register/bindings/trainee_register_binding.dart';
import '../modules/trainee_register/views/trainee_register_view.dart';
import '../modules/trainer_onboarding/bindings/trainer_onboarding_binding.dart';
import '../modules/trainer_onboarding/views/trainer_onboarding_view.dart';
import '../modules/weekly_routine/bindings/weekly_routine_binding.dart';
import '../modules/weekly_routine/views/add_exercise_to_routine_view.dart';
import '../modules/weekly_routine/views/explore_view.dart';
import '../modules/weekly_routine/views/weekly_routine_view.dart';
import '../modules/workout_history/bindings/workout_history_binding.dart';
import '../modules/workout_history/views/workout_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.ACTIVITY_TRACKER,
          page: () => ActivityTrackerView(),
          binding: ActivityTrackerBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.Two_Factor_Verification,
      page: () => TwoFactorVerificationPageView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.EMAIL_VERIFICATION_OTP,
      page: () => EmailVerificationOtpPageView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.TWO_FACTOR_SUCCESS,
      page: () => TwoFactorSuccessPageView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.TRAINER_ONBOARDING,
      page: () => const TrainerOnboardingView(),
      binding: TrainerOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.ICON_CHAT,
      page: () => const IconChatView(),
      binding: IconChatBinding(),
    ),
    GetPage(
      name: _Paths.TRAINEE_ONBOARDING,
      page: () => TraineeOnboardingView(),
      binding: TraineeOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FITNESS_REPORT,
      page: () => ReportDisplayView(),
      binding: FitnessReportBinding(),
    ),
    GetPage(
      name: _Paths.TRAINEE_FITNESS_REPORT_GENERATION,
      page: () => TraineeFitnessReportGenerationView(),
      binding: TraineeFitnessReportGenerationBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VALIDATION,
      page: () => OtpValidationView(),
      binding: OtpValidationBinding(),
    ),
    GetPage(
      name: _Paths.ICON_PROFILE,
      page: () => IconProfileView(),
      binding: IconProfileBinding(),
    ),
    GetPage(
      name: _Paths.TRAINEE_REGISTER,
      page: () => const TraineeRegisterView(),
      binding: TraineeRegisterBinding(),
    ),
    GetPage(
      name: _Paths.WEEKLY_ROUTINE,
      page: () => const WeeklyRoutineView(),
      binding: WeeklyRoutineBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EXERCISE_TO_ROUTINE,
      page: () => const AddExerciseToRoutineView(),
      binding: WeeklyRoutineBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: WeeklyRoutineBinding(),
    ),
    GetPage(
      name: _Paths.WORKOUT_HISTORY,
      page: () => WorkoutHistoryView(),
      binding: WorkoutHistoryBinding(),
    ),
  ];
}
