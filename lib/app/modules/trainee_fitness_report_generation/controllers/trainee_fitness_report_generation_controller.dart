import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/utils/app_validators.dart';
import 'package:icon/app/routes/app_pages.dart';

import '../../fitness_report/repository/fitness_report_repository.dart';

class TraineeFitnessReportGenerationController extends BaseController {
  final FitnessReportRepository _reportRepository = Get.find(
    tag: (FitnessReportRepository).toString(),
  );

  // --------- local value --------------
  final int traineeId = Get.arguments ?? 43;

  // --- UI State for the initial email form ---
  final TextEditingController emailCtr = TextEditingController();
  var emailError = RxnString();
  final isSubmitBtnEnable = RxBool(false);
  final RxBool onEmailLoading = false.obs;

  final RxBool isValidEmail = true.obs;

  // ---------------Progress Loading Effect State ---------------
  // --- UI State for the Saving/Progress View ---
  final progress = 0.0.obs;
  var enableApiProgressState = true.obs; // Triggers navigation to SavingView

  // --- New properties for error handling in SavingView ---
  final hasError = false.obs;

  final RxString errorMessage =
      'An unexpected error occurred. Please try again.'.obs;

  @override
  void onInit() {
    super.onInit();
    generateReport();
  }

  @override
  void onClose() {
    emailCtr.dispose();
    super.onClose();
  }

  Future<void> generateReport() async {
    try {
      if (hasError.value) hasError(false);

      progress.value = 0.0;

      await _reportRepository.generateReport(
        {"trainee_id": traineeId, 'trainer_id': 1, "force": true},
        onSendProgress: (sent, total) {
          if (total != -1) {
            progress.value = sent / total;
          }
        },
      );

      progress.value = 1.0;

      await Get.offAllNamed(Routes.FITNESS_REPORT);
    } on ApiException catch (e) {
      errorMessage(e.message);
      hasError(true);
      "API Error during report generation: ${e.description}".log();
    } catch (e) {
      errorMessage(
        'A network error occurred. Please check your connection and try again.',
      );
      hasError(true);
      "Unexpected error during report generation: ${e.toString()}".log();
    }
  }

  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);
    isSubmitBtnEnable.value = emailError.value == null;
  }
}
