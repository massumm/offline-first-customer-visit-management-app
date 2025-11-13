abstract class ForgotPasswordRepository {
  Future<Map<String, dynamic>> requestPasswordReset(Map<String, dynamic> requestBody);
  Future<Map<String, dynamic>> requestOtp(Map<String, dynamic> requestBody);
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> requestBody);
  Future<Map<String, dynamic>> resetPasswordConfirm(Map<String, dynamic> requestBody);
}
