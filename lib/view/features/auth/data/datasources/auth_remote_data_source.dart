import 'package:flutter/foundation.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/auth/data/models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginData> login(String email, String password);
  Future<String> forgotPassword(String email);
  Future<String> verifyEmail(String email, String otp);
  Future<String> resendOtp(String email);
  Future<String> resetPassword(
    String newPassword,
    String confirmPassword, {
    String? token,
  });
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Map<String, dynamic>?> getEmployeeProfileStatus();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  static String resetPasswordToken = '';

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<LoginData> login(String email, String password) async {
    final response = await apiService.postData<LoginData>(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
      decoder: (json) => LoginData.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await apiService.postData<Map<String, dynamic>>(
      '/auth/forget-password',
      {
        'email': email.trim(),
      },
      decoder: (json) => json as Map<String, dynamic>,
    );
    return response.message ??
        'Please check your email. We have sent you a one-time passcode (OTP).';
  }

  String _extractToken(dynamic json) {
    if (json == null) return '';
    if (json is String && json.trim().isNotEmpty) return json.trim();
    if (json is Map) {
      for (final key in [
        'accessToken',
        'token',
        'access_token',
        'resetToken',
        'reset_token',
        'verificationToken',
        'authToken',
        'auth_token',
        'jwt',
      ]) {
        final val = json[key];
        if (val != null && val.toString().trim().isNotEmpty) {
          return val.toString().trim();
        }
      }
      final data = json['data'];
      if (data != null) {
        final fromData = _extractToken(data);
        if (fromData.isNotEmpty) return fromData;
      }
      for (final entry in json.entries) {
        final k = entry.key.toString().toLowerCase();
        if (k.contains('token') && entry.value is String && (entry.value as String).trim().isNotEmpty) {
          return (entry.value as String).trim();
        }
      }
    }
    return '';
  }

  @override
  Future<String> verifyEmail(String email, String otp) async {
    final otpValue = int.tryParse(otp.trim()) ?? otp.trim();
    debugPrint('[VerifyEmail] Request: POST /auth/verify-email, email: $email, OTP: $otpValue');
    final response = await apiService.postData<String>(
      '/auth/verify-email',
      {
        'email': email.trim(),
        'OTP': otpValue,
      },
      decoder: (json) {
        debugPrint('[VerifyEmail] Response json: $json');
        final token = _extractToken(json);
        debugPrint('[VerifyEmail] Extracted token: $token');
        return token;
      },
    );

    final token = response.data;
    if (token.isNotEmpty) {
      resetPasswordToken = token;
      PrefsHelper.token = token;
      PrefsHelper.resetToken = token;
      await PrefsHelper.setString('token', token);
      await PrefsHelper.setString('resetToken', token);
    }
    return token;
  }

  @override
  Future<String> resendOtp(String email) async {
    final response = await apiService.postData<Map<String, dynamic>>(
      '/auth/resend-otp',
      {
        'email': email.trim(),
      },
      decoder: (json) => json as Map<String, dynamic>,
    );
    return response.message ?? 'OTP has been resent.';
  }

  @override
  Future<String> resetPassword(
    String newPassword,
    String confirmPassword, {
    String? token,
  }) async {
    var effectiveToken = token?.trim() ?? '';
    if (effectiveToken.isEmpty) {
      effectiveToken = resetPasswordToken.trim();
    }
    if (effectiveToken.isEmpty) {
      effectiveToken = PrefsHelper.resetToken.trim();
    }
    if (effectiveToken.isEmpty) {
      effectiveToken = PrefsHelper.token.trim();
    }
    if (effectiveToken.isEmpty) {
      effectiveToken = (await PrefsHelper.getString('resetToken')).trim();
    }
    if (effectiveToken.isEmpty) {
      effectiveToken = (await PrefsHelper.getString('token')).trim();
    }

    final cleanToken = effectiveToken
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
        .trim();

    debugPrint('====================================');
    debugPrint('[ResetPassword] Endpoint: POST /auth/reset-password');
    debugPrint('[ResetPassword] Clean Token: ${cleanToken.isNotEmpty ? (cleanToken.length > 25 ? "${cleanToken.substring(0, 25)}..." : cleanToken) : "EMPTY!"}');
    debugPrint('====================================');

    final headers = cleanToken.isNotEmpty
        ? {
            'resettoken': cleanToken,
            'resetToken': cleanToken,
            'token': cleanToken,
            'Authorization': 'Bearer $cleanToken',
          }
        : null;

    final body = <String, dynamic>{
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
      if (cleanToken.isNotEmpty) ...{
        'resettoken': cleanToken,
        'resetToken': cleanToken,
      },
    };

    final response = await apiService.postData<Map<String, dynamic>>(
      '/auth/reset-password',
      body,
      headers: headers,
      decoder: (json) => json as Map<String, dynamic>,
    );
    return response.message ?? 'Password reset successfully.';
  }

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await apiService.postData<Map<String, dynamic>>(
      '/auth/change-password',
      {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
      decoder: (json) => json as Map<String, dynamic>,
    );
    return response.message ?? 'Your password has been successfully changed';
  }

  @override
  Future<Map<String, dynamic>?> getEmployeeProfileStatus() async {
    try {
      final response = await apiService.getData<Map<String, dynamic>>(
        '/employees/profile',
        decoder: (json) {
          if (json is Map<String, dynamic>) {
            return json;
          }
          if (json is Map) {
            return json.map((key, value) => MapEntry(key.toString(), value));
          }
          return <String, dynamic>{};
        },
      );
      final raw = response.data;
      if (raw.containsKey('data') && raw['data'] is Map) {
        final inner = raw['data'] as Map;
        return inner.map((key, value) => MapEntry(key.toString(), value));
      }
      return raw;
    } catch (_) {
      return null;
    }
  }
}
