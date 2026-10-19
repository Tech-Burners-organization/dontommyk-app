import 'package:tommy/core/network/api_service.dart';
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

  @override
  Future<String> verifyEmail(String email, String otp) async {
    final otpValue = int.tryParse(otp.trim()) ?? otp.trim();
    final response = await apiService.postData<String>(
      '/auth/verify-email',
      {
        'email': email.trim(),
        'OTP': otpValue,
      },
      decoder: (json) {
        if (json is Map) {
          final data = json['data'];
          if (data is Map) {
            final t = data['accessToken'] ?? data['token'] ?? data['access_token'];
            if (t != null) return t.toString();
          }
          if (data is String && data.isNotEmpty) return data;
          final rootToken = json['accessToken'] ?? json['token'] ?? json['access_token'];
          if (rootToken != null) return rootToken.toString();
        }
        return '';
      },
    );
    return response.data;
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
    final headers = (token != null && token.isNotEmpty)
        ? {'Authorization': 'Bearer $token'}
        : null;

    final response = await apiService.postData<Map<String, dynamic>>(
      '/auth/reset-password',
      {
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
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
