class LoginData {
  final String accessToken;
  final String refreshToken;

  LoginData({required this.accessToken, required this.refreshToken});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return LoginData(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
    );
  }
}
