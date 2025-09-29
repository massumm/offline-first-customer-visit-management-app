import 'package:icon/app/base/models/login_response_model.dart';

abstract class LoginRepository{
  Future<LoginResponseModel> login(Map<String, dynamic> requestBody);
}