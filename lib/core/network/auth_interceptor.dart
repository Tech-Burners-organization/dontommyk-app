import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
      final clean = token.trim().replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '');
      options.headers[_authorizationHeader] = 'Bearer $clean';
    } else if (hasAuthorization) {
      final authKey = options.headers.keys.firstWhere(
        (key) => key.toLowerCase() == _authorizationHeader.toLowerCase(),
      );
      final rawAuth = options.headers[authKey]?.toString() ?? '';
      if (rawAuth.isNotEmpty) {
        final clean = rawAuth.trim().replaceFirst(RegExp(r'^Bearer\s+Bearer\s+', caseSensitive: false), 'Bearer ');
        options.headers[authKey] = clean;
      }
    }

    if (kDebugMode) {
      debugPrint('[Network] ${options.method} ${options.uri}');
      debugPrint('[Network] Headers: ${options.headers}');
    }

    handler.next(options);
  }
}
