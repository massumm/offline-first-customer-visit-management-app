import 'package:get/get.dart';
import 'package:icon/app/modules/otp_validation/repository/otp_verifications_repository_impl.dart';

import '../controllers/otp_validation_controller.dart';
import '../repository/otp_verifications_repository.dart';

class OtpValidationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationsRepository>(
        () => OtpVerificationsRepositoryImpl(),
      tag: (OtpVerificationsRepository).toString(),
    );


    Get.lazyPut<OtpValidationController>(
      () => OtpValidationController(),
    );
  }
}
