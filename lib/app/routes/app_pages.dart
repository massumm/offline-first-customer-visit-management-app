import 'package:get/get.dart';
import 'package:icon/app/modules/app_settings/bindings/app_settings_binding.dart';
import 'package:icon/app/modules/app_settings/views/app_settings_view.dart';

import '../modules/activity_tracker/bindings/activity_tracker_binding.dart';
import '../modules/activity_tracker/views/activity_tracker_view.dart';
import '../modules/fitness_report/bindings/fitness_report_binding.dart';
import '../modules/fitness_report/views/fitness_report_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/goal_tracking/bindings/goal_tracking_binding.dart';
import '../modules/goal_tracking/views/goal_tracking_view.dart';
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
import '../modules/trainee_onboarding/bindings/trainee_onboarding_binding.dart';
import '../modules/trainee_onboarding/views/trainee_onboarding_view.dart';
import '../modules/trainee_onboarding_by_page/bindings/trainee_onboarding_by_page_binding.dart';
import '../modules/trainee_onboarding_by_page/views/trainee_onboarding_by_page_view.dart';
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
import '../modules/your_activity_goals/bindings/your_activity_goals_binding.dart';
import '../modules/your_activity_goals/views/your_activity_goals_view.dart';
import '../modules/your_daily_goals/bindings/your_daily_goals_binding.dart';
import '../modules/your_daily_goals/views/your_daily_goals_view.dart';
import '../modules/your_nutrition_goals/bindings/your_nutrition_goals_binding.dart';
import '../modules/your_nutrition_goals/views/your_nutrition_goals_view.dart';
import '../modules/your_recovery_goals/bindings/your_recovery_goals_binding.dart';
import '../modules/your_recovery_goals/views/your_recovery_goals_view.dart';

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
      page: () => const TraineeOnboardingView(),
      binding: TraineeOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FITNESS_REPORT,
      page: () => const FitnessReportView(),
      binding: FitnessReportBinding(),
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
      name: _Paths.GOAL_TRACKING,
      page: () => const GoalTrackingView(),
      binding: GoalTrackingBinding(),
    ),
    GetPage(
      name: _Paths.YOUR_ACTIVITY_GOALS,
      page: () => const YourActivityGoalsView(),
      binding: YourActivityGoalsBinding(),
    ),
    GetPage(
      name: _Paths.YOUR_RECOVERY_GOALS,
      page: () => const YourRecoveryGoalsView(),
      binding: YourRecoveryGoalsBinding(),
    ),
    GetPage(
      name: _Paths.YOUR_NUTRITION_GOALS,
      page: () => const YourNutritionGoalsView(),
      binding: YourNutritionGoalsBinding(),
    ),
    GetPage(
      name: _Paths.YOUR_DAILY_GOALS,
      page: () => const YourDailyGoalsView(),
      binding: YourDailyGoalsBinding(),
    ),
    GetPage(
      name: _Paths.TRAINEE_ONBOARDING_BY_PAGE,
      page: () => const TraineeOnboardingByPageView(),
      binding: TraineeOnboardingByPageBinding(),
    ),
    GetPage(
      name: _Paths.APP_SETTINGS,
      page: () => const AppSettingsView(),
      binding: AppSettingsBinding(),
    ),
  ];
}
