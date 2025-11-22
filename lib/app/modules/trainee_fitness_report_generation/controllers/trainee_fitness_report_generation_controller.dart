import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/base/network/exceptions/api_exception.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/utils/app_validators.dart';
import 'package:icon/app/modules/fitness_report/models/server_task_log_response_model.dart';
import 'package:icon/app/routes/app_pages.dart';
import 'package:icon/app/data/local/preference/store/user_store.dart';

import '../../fitness_report/repository/fitness_report_repository.dart';

class TraineeFitnessReportGenerationController extends BaseController {
  final FitnessReportRepository _reportRepository = Get.find(
    tag: (FitnessReportRepository).toString(),
  );

  // --------- Local Values --------------
  final int traineeId = Get.arguments ?? 43;

  // --- UI State ---
  final TextEditingController emailCtr = TextEditingController();
  final RxnString emailError = RxnString();
  final RxBool isSubmitBtnEnable = false.obs;

  // --------------- Progress State ---------------
  final RxDouble progress = 0.0.obs;

  double _targetProgress = 0.0;

  Timer? _progressAnimatorTimer;

  Timer? _pollingTimer;

  final RxBool hasError = false.obs;
  final RxString errorMessage =
      'An unexpected error occurred. Please try again.'.obs;

  static const double _networkPortionStart = 0.0;
  static const double _networkPortionEnd = 0.60;
  static const double _taskPortionStart = _networkPortionEnd;
  static const double _taskPortionEnd = 0.98;

  @override
  void onInit() {
    super.onInit();
    generateReport();
  }

  @override
  void onClose() {
    emailCtr.dispose();
    _progressAnimatorTimer?.cancel();
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> generateReport() async {
    try {
      hasError(false);
      errorMessage.value =
          'An unexpected error occurred. Please try again.'; // reset message

      // Reset progress for a new run.
      progress.value = 0.0;
      _targetProgress = 0.0;

      // Start the progress animation.
      _startProgressAnimator();

      final response = await _reportRepository.generateReport({
        "trainee_id": traineeId,
        'trainer_id': UserStore.to.trainerId ?? 1,
        "force": true,
      }, onReceiveProgress: _handleNetworkProgress);

      _setTargetProgress(_networkPortionEnd);

      final taskId = response.data['celery_task_id'] as String?;
      if (taskId != null && taskId.isNotEmpty) {
        _startPolling(taskId);
      } else {
        throw Exception("Failed to get a background task ID from the server.");
      }
    } on ApiException catch (e) {
      _stopProgressOnError();
      errorMessage.value = e.message;
      hasError(true);
      "API Error during report generation: ${e.description}".log();
    } catch (e) {
      _stopProgressOnError();
      errorMessage.value =
          'A network error occurred. Please check your connection and try again.';
      hasError(true);
      "Unexpected error during report generation: $e".log();
    }
  }

  void onEmailChanged(String value) {
    emailError.value = AppValidator().validateEmail(value);
    isSubmitBtnEnable.value = emailError.value == null;
  }

  void _handleNetworkProgress(int received, int total) {
    if (total <= 0) return;

    final fraction = received / total; // 0.0 - 1.0
    // Clamp between 0 and 1 for safety.
    final clampedFraction = fraction.clamp(0.0, 1.0);

    final uiProgress =
        _networkPortionStart +
        (clampedFraction * (_networkPortionEnd - _networkPortionStart));

    _setTargetProgress(uiProgress);
  }

  void _startPolling(String celeryTaskId) {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (
      Timer timer,
    ) async {
      try {
        int serverProgress = 0;

        final ServerTaskLagResponseModel responseData = await _reportRepository
            .checkServerBackgroundTask(celeryTaskId, (int received, int total) {
              if (total <= 0) return;

              final fraction = received / total; // 0.0 - 1.0
              final percent = (fraction * 100);

              // Clamp to [0, 100] and convert to int.
              serverProgress = percent < 0
                  ? 0
                  : percent > 100
                  ? 100
                  : percent.toInt();
            });

        if (responseData.isRunning == false) {
          timer.cancel();
          _completeProgress();

          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(Routes.FITNESS_REPORT);
          });
        } else {
          final double fraction = (serverProgress / 100.0).clamp(0.0, 1.0);

          // Map this to [_taskPortionStart - _taskPortionEnd] (e.g. 60% - 98%).
          final double uiProgress =
              _taskPortionStart +
              (fraction * (_taskPortionEnd - _taskPortionStart));

          _setTargetProgress(uiProgress);
        }
      } on ApiException catch (e) {
        timer.cancel(); // Stop polling on error.
        _stopProgressOnError();
        errorMessage.value = e.message;
        hasError(true);
        "API Error while checking task status: ${e.description}".log();
      } catch (e) {
        timer.cancel(); // Stop polling on error.
        _stopProgressOnError();
        errorMessage.value =
            'A network error occurred while checking status. Please try again.';
        hasError(true);
        "Unexpected error while checking task status: $e".log();
      }
    });
  }

  void _setTargetProgress(double value) {
    final double clamped = value.clamp(0.0, 0.99);

    if (clamped <= _targetProgress) return;

    _targetProgress = clamped;
  }

  void _startProgressAnimator() {
    _progressAnimatorTimer?.cancel();

    _progressAnimatorTimer = Timer.periodic(const Duration(milliseconds: 50), (
      Timer timer,
    ) {
      const double lerpFactor = 0.15;
      const double epsilon = 0.001;

      if (progress.value < _targetProgress) {
        final double delta = _targetProgress - progress.value;

        if (delta < epsilon) {
          progress.value = _targetProgress;
        } else {
          progress.value += delta * lerpFactor;
        }
      }
    });
  }

  void _completeProgress() {
    _pollingTimer?.cancel();
    _targetProgress = 1.0;
    progress.value = 1.0;
    _progressAnimatorTimer?.cancel();
  }

  void _stopProgressOnError() {
    _progressAnimatorTimer?.cancel();
    _pollingTimer?.cancel();
  }
}
