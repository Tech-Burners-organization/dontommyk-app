import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/config/app_config.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/core/network/auth_interceptor.dart';
import 'package:tommy/core/utils/prefs_helper.dart';

class AppDependencies {
  AppDependencies._({required this.apiService});

  final ApiService apiService;

  factory AppDependencies.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: const {
          Headers.acceptHeader: Headers.jsonContentType,
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(tokenProvider: () => PrefsHelper.token),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
          logPrint: _debugLog,
        ),
      );
    }

    return AppDependencies._(apiService: ApiService(dio));
  }
}

void _debugLog(Object message) {
  if (kDebugMode) debugPrint(message.toString());
}
