import 'package:icon/app/modules/login/models/login_response_model.dart';

abstract class OtpVerificationsRepository{

  Future<LoginResponseModel> varifyOtp(Map<String, dynamic> payload);

  Future<void> otpRequest(Map<String, String> map);

}