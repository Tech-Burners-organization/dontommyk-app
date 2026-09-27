import 'package:dio/dio.dart';

class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    required this.statusCode,
    this.message,
  });

  final T data;
  final int? statusCode;
  final String? message;

  factory ApiResponse.fromResponse(
    Response<dynamic> response, {
    T Function(dynamic json)? decoder,
  }) {
    final rawData = response.data;
    final decodedData = decoder != null ? decoder(rawData) : rawData as T;

    return ApiResponse<T>(
      data: decodedData,
      statusCode: response.statusCode,
      message: _readMessage(rawData),
    );
  }

  static String? _readMessage(dynamic body) {
    if (body is Map) {
      final message = body['message'] ?? body['detail'] ?? body['error'];
      return message?.toString();
    }
    return null;
  }
}
