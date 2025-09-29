import 'package:icon/app/modules/register/model/registration_response_model.dart';

abstract class RegistrationRepository{
  Future<RegistrationResponseModel> onRegister( Map<String, dynamic> requestBody);
}