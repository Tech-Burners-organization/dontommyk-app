import 'package:dio/dio.dart';

enum ApiExceptionType {
  connection,
  timeout,
  cancelled,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
    this.cause,
  });

  final ApiExceptionType type;
  final String message;
  final int? statusCode;
  final dynamic data;
  final Object? cause;

  factory ApiException.fromDio(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    if (error.type == DioExceptionType.cancel) {
      return ApiException(
        type: ApiExceptionType.cancelled,
        message: 'Request cancelled.',
        cause: error,
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        type: ApiExceptionType.timeout,
        message: 'Request timed out. Please try again.',
        cause: error,
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return ApiException(
        type: ApiExceptionType.connection,
        message: 'No internet connection.',
        cause: error,
      );
    }

    return ApiException(
      type: _typeFromStatusCode(statusCode),
      message: _messageFromResponse(response?.data, statusCode),
      statusCode: statusCode,
      data: response?.data,
      cause: error,
    );
  }

  static ApiExceptionType _typeFromStatusCode(int? statusCode) {
    if (statusCode != null && statusCode >= 500 && statusCode <= 599) {
      return ApiExceptionType.server;
    }

    return switch (statusCode) {
      400 => ApiExceptionType.badRequest,
      401 => ApiExceptionType.unauthorized,
      403 => ApiExceptionType.forbidden,
      404 => ApiExceptionType.notFound,
      409 => ApiExceptionType.conflict,
      422 => ApiExceptionType.validation,
      _ => ApiExceptionType.unknown,
    };
  }

  static String _messageFromResponse(dynamic body, int? statusCode) {
    if (body is Map) {
      final value = body['message'] ?? body['detail'] ?? body['error'];
      if (value is List) return value.join('\n');
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    if (statusCode != null && statusCode >= 500 && statusCode <= 599) {
      return 'Server error. Please try again later.';
    }

    return switch (statusCode) {
      400 => 'Invalid request.',
      401 => 'Your session has expired. Please sign in again.',
      403 => 'You do not have permission to do that.',
      404 => 'The requested resource was not found.',
      409 => 'This data already exists.',
      422 => 'Please check the submitted information.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  @override
  String toString() => 'ApiException($type, $statusCode, $message)';
}
