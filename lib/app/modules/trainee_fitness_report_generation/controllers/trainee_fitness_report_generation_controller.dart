import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/utils/app_validators.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';

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
  final progress = 0.0.obs;
  Timer? _progressTimer;
  var enableApiProgressState = true.obs;

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
    _progressTimer?.cancel(); // Ensure timer is cancelled
    super.onClose();
  }

  Future<void> generateReport() async {
    try {
      if (hasError.value) hasError(false);

      _startProgressSimulation();

      await _reportRepository.generateReport(
        {
          "trainee_id": traineeId,
          'trainer_id': UserStore.to.trainerId ?? 1,
          "force": true,
        },
        onReceiveProgress: (sent, total) {
          if (total != -1) {
            _progressTimer?.cancel(); // Stop simulation
            progress.value = sent / total;
            "Progress: $progress".log();
          }
        },
      );

      _completeProgress();

      // A short delay to allow the user to see the "completed" state.
      Future.delayed(
        const Duration(seconds: 1),
        () => Get.offAllNamed(Routes.FITNESS_REPORT),
      );
    } on ApiException catch (e) {
      _stopProgressOnError();
      errorMessage(e.message);
      hasError(true);
      "API Error during report generation: ${e.description}".log();
    } catch (e) {
      _stopProgressOnError();
      errorMessage(
        'A network error occurred. Please check your connection and try again.',
      );
      hasError(true);
      "Unexpected error during report generation: ${e.toString()}".log();
    }
  }

  void _startProgressSimulation() {
    progress.value = 0.0;
    _progressTimer?.cancel();

    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (progress.value < 0.9) {
        progress.value += 0.02;
      } else {
        timer.cancel(); // Stop at 90% and wait for completion
      }
    });
  }

  /// Completes the progress, setting it to 100%.
  void _completeProgress() {
    _progressTimer?.cancel();
    progress.value = 1.0;
  }

  /// Stops the progress simulation in case of an error.
  void _stopProgressOnError() {
    _progressTimer?.cancel();
  }

  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);
    isSubmitBtnEnable.value = emailError.value == null;
  }
}
