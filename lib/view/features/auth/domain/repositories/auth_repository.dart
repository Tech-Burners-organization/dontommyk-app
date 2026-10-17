import 'package:tommy/core/result/result.dart';

abstract class AuthRepository {
  Future<Result<void>> login(String email, String password);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> verifyEmail(String email, String otp);
  Future<Result<String>> resendOtp(String email);
  Future<Result<String>> resetPassword(
    String newPassword,
    String confirmPassword, {
    String? token,
  });
}
