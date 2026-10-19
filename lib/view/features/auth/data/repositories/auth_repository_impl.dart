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
      var loginData = await remoteDataSource.login(email, password);
      if (loginData.needsVerification) {
        return ResultSuccess(loginData);
      }

      await PrefsHelper.setString('token', loginData.accessToken);
      await PrefsHelper.setString('refreshToken', loginData.refreshToken);
      if (loginData.role.isNotEmpty) {
        await PrefsHelper.setString('role', loginData.role);
      }

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

      // Verify real onboarding status from server
      var onboarding = loginData.onboarding;
      if (!onboarding.isProfileCompleted || !onboarding.isInitialAssessmentCompleted) {
        final profileData = await remoteDataSource.getEmployeeProfileStatus();
        if (profileData != null) {
          final rawOnboarding = profileData['onboarding'];
          final isProfileCompleted = profileData['isProfileCompleted'] as bool? ??
              (rawOnboarding is Map ? rawOnboarding['isProfileCompleted'] as bool? : null) ??
              false;
          final isInitialAssessmentCompleted =
              (rawOnboarding is Map ? rawOnboarding['isInitialAssessmentCompleted'] as bool? : null) ??
              false;

          onboarding = OnboardingInfo(
            isProfileCompleted: isProfileCompleted,
            isInitialAssessmentCompleted: isInitialAssessmentCompleted,
          );
          loginData = loginData.copyWith(onboarding: onboarding);

          final firstName = profileData['firstName']?.toString() ?? '';
          final lastName = profileData['lastName']?.toString() ?? '';
          final fullName = '$firstName $lastName'.trim();
          if (fullName.isNotEmpty) {
            await PrefsHelper.setString('name', fullName);
          }
          final designation = profileData['designation']?.toString() ?? '';
          if (designation.isNotEmpty) {
            await PrefsHelper.setString('role', designation);
          }
          final profilePhoto = profileData['profilePhoto']?.toString() ?? '';
          if (profilePhoto.isNotEmpty) {
            await PrefsHelper.setString('profileImage', profilePhoto);
          }
        }
      }

      await PrefsHelper.setProfileCompleted(
        onboarding.isProfileCompleted,
      );
      await PrefsHelper.setInitialAssessmentCompleted(
        onboarding.isInitialAssessmentCompleted,
      );

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
