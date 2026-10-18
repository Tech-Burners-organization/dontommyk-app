import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/auth/data/models/login_response.dart';

abstract class AuthRepository {
  Future<Result<LoginData>> login(String email, String password);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> verifyEmail(String email, String otp);
  Future<Result<String>> resendOtp(String email);
  Future<Result<String>> resetPassword(
    String newPassword,
    String confirmPassword, {
    String? token,
  });
}
