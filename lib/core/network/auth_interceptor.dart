import 'dart:async';

import 'package:dio/dio.dart';

typedef TokenProvider = FutureOr<String?> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenProvider});

  final TokenProvider tokenProvider;
  static const _authorizationHeader = 'Authorization';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    final hasAuthorization = options.headers.keys.any(
      (key) => key.toLowerCase() == _authorizationHeader.toLowerCase(),
    );

    if (!hasAuthorization && token != null && token.trim().isNotEmpty) {
      options.headers[_authorizationHeader] = 'Bearer ${token.trim()}';
    }

    handler.next(options);
  }
}
