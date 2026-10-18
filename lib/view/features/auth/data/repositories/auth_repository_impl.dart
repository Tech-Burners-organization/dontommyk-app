import 'dart:convert';
import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tommy/view/features/auth/data/models/login_response.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<LoginData>> login(String email, String password) async {
    try {
      final loginData = await remoteDataSource.login(email, password);
      await PrefsHelper.setString('token', loginData.accessToken);
      await PrefsHelper.setString('refreshToken', loginData.refreshToken);
      if (loginData.role.isNotEmpty) {
        await PrefsHelper.setString('role', loginData.role);
      }
      await PrefsHelper.setProfileCompleted(
        loginData.onboarding.isProfileCompleted,
      );
      await PrefsHelper.setInitialAssessmentCompleted(
        loginData.onboarding.isInitialAssessmentCompleted,
      );

      try {
        final parts = loginData.accessToken.split('.');
        if (parts.length == 3) {
          final payload = utf8.decode(
            base64Url.decode(base64Url.normalize(parts[1])),
          );
          final map = jsonDecode(payload) as Map<String, dynamic>;
          if (map['email'] != null) {
            await PrefsHelper.setString('email', map['email'].toString());
          }
          if (map['role'] != null && loginData.role.isEmpty) {
            await PrefsHelper.setString('role', map['role'].toString());
          }
          if (map['id'] != null) {
            await PrefsHelper.setString('userId', map['id'].toString());
          }
        }
      } catch (_) {}

      return ResultSuccess(loginData);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> forgotPassword(String email) async {
    try {
      final message = await remoteDataSource.forgotPassword(email);
      return ResultSuccess(message);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> verifyEmail(String email, String otp) async {
    try {
      final token = await remoteDataSource.verifyEmail(email, otp);
      if (token.isNotEmpty) {
        await PrefsHelper.setString('token', token);
      }
      return ResultSuccess(token);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> resendOtp(String email) async {
    try {
      final message = await remoteDataSource.resendOtp(email);
      return ResultSuccess(message);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> resetPassword(
    String newPassword,
    String confirmPassword, {
    String? token,
  }) async {
    try {
      final message = await remoteDataSource.resetPassword(
        newPassword,
        confirmPassword,
        token: token,
      );
      return ResultSuccess(message);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final message = await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return ResultSuccess(message);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}
