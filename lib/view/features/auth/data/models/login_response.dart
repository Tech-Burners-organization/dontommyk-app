class OnboardingInfo {
  final bool isProfileCompleted;
  final bool isInitialAssessmentCompleted;

  const OnboardingInfo({
    this.isProfileCompleted = false,
    this.isInitialAssessmentCompleted = false,
  });

  factory OnboardingInfo.fromJson(
    Map<String, dynamic>? json, {
    Map<String, dynamic>? fallback,
  }) {
    if (json == null && fallback == null) return const OnboardingInfo();
    final map = json ?? const {};
    final fb = fallback ?? const {};
    return OnboardingInfo(
      isProfileCompleted: (map['isProfileCompleted'] as bool?) ??
          (fb['isProfileCompleted'] as bool?) ??
          false,
      isInitialAssessmentCompleted:
          (map['isInitialAssessmentCompleted'] as bool?) ??
              (fb['isInitialAssessmentCompleted'] as bool?) ??
              false,
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final String role;
  final OnboardingInfo onboarding;
  final bool needsVerification;
  final String email;
  final String message;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    this.role = '',
    this.onboarding = const OnboardingInfo(),
    this.needsVerification = false,
    this.email = '',
    this.message = '',
  });

  LoginData copyWith({
    String? accessToken,
    String? refreshToken,
    String? role,
    OnboardingInfo? onboarding,
    bool? needsVerification,
    String? email,
    String? message,
  }) {
    return LoginData(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
      onboarding: onboarding ?? this.onboarding,
      needsVerification: needsVerification ?? this.needsVerification,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  factory LoginData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] is Map
        ? (json['data'] as Map).cast<String, dynamic>()
        : json;
    final token = (data['accessToken'] ??
            data['token'] ??
            data['access_token'] ??
            json['accessToken'] ??
            json['token'] ??
            json['access_token'])
        ?.toString() ??
        '';
    final refreshToken = (data['refreshToken'] ??
            data['refresh_token'] ??
            json['refreshToken'] ??
            json['refresh_token'])
        ?.toString() ??
        '';
    final role = (data['role'] ?? json['role'])?.toString() ?? '';
    final needsVerification = (data['needsVerification'] as bool?) ??
        (json['needsVerification'] as bool?) ??
        false;
    final email = (data['email'] ?? json['email'])?.toString() ?? '';
    final message = (json['message'] ?? data['message'])?.toString() ?? '';

    return LoginData(
      accessToken: token,
      refreshToken: refreshToken,
      role: role,
      needsVerification: needsVerification,
      email: email,
      message: message,
      onboarding: OnboardingInfo.fromJson(
        data['onboarding'] as Map<String, dynamic>?,
        fallback: data,
      ),
    );
  }
}
