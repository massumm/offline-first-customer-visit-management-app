import 'package:get/get.dart';

import '../modules/activity_tracker/bindings/activity_tracker_binding.dart';
import '../modules/activity_tracker/views/activity_tracker_view.dart';
import '../modules/app_settings/bindings/app_settings_binding.dart';
import '../modules/app_settings/views/app_settings_view.dart';
import '../modules/app_settings/views/region_and_language_view.dart';
import '../modules/app_settings/views/units_and_preferrences_view.dart';
import '../modules/app_settings/views/accessibility_view.dart';
import '../modules/app_settings/views/two_factor_authentication_view.dart';
import '../modules/app_settings/views/app_integration_view.dart';
import '../modules/app_settings/views/active_sessions_view.dart';
import '../modules/app_settings/views/feedback_view.dart';
import '../modules/app_settings/views/help_and_support_view.dart';
import '../modules/app_settings/views/export_data_view.dart';
import '../modules/app_settings/views/delete_account_view.dart';
import '../modules/app_settings/views/privacy_view.dart';
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

  static const String INITIAL = Routes.SPLASH;

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
    GetPage(
      name: _Paths.APP_SETTINGS,
      page: () => const AppSettingsView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.REGION_AND_LANGUAGE,
      page: () => const RegionAndLanguageView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.UNITS_AND_PREFERRENCES,
      page: () => const UnitsAndPreferencesView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ACCESSIBILITY,
      page: () => const AccessibilityView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.TWO_FACTOR_AUTHENTICATION,
      page: () => const TwoFactorAuthenticationView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.APP_INTEGRATION,
      page: () => const AppIntegrationView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVE_SESSIONS,
      page: () => const ActiveSessionsView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.HELP_AND_SUPPORT,
      page: () => const HelpAndSupportView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.EXPORT_DATA,
      page: () => const ExportDataView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.DELETE_ACCOUNT,
      page: () => const DeleteAccountView(),
      binding: AppSettingsBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY,
      page: () => const PrivacyView(),
      binding: AppSettingsBinding(),
    ),
  ];
}
