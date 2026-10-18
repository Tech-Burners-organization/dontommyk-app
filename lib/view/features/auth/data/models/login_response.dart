class OnboardingInfo {
  final bool isProfileCompleted;
  final bool isInitialAssessmentCompleted;

  const OnboardingInfo({
    this.isProfileCompleted = false,
    this.isInitialAssessmentCompleted = false,
  });

  factory OnboardingInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OnboardingInfo();
    return OnboardingInfo(
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
      isInitialAssessmentCompleted:
          json['isInitialAssessmentCompleted'] as bool? ?? false,
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final String role;
  final OnboardingInfo onboarding;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    this.role = '',
    this.onboarding = const OnboardingInfo(),
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return LoginData(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      role: data['role'] as String? ?? '',
      onboarding: OnboardingInfo.fromJson(
        data['onboarding'] as Map<String, dynamic>?,
      ),
    );
  }
}
