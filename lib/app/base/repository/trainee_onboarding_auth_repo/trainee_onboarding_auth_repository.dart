import 'package:icon/app/modules/login/models/login_response_model.dart';

abstract class TraineeOnboardingAuthRepository{
  Future<LoginResponseModel> registerEmail(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> getTokenFromEmail(Map<String, dynamic> payload);
}