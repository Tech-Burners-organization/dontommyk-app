import 'package:dio/dio.dart';
import 'package:tommy/core/network/api_exception.dart';

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

    if (rawData is Map && rawData['success'] == false) {
      throw ApiException(
        type: ApiExceptionType.badRequest,
        message: _readMessage(rawData) ?? 'Something went wrong.',
        statusCode: response.statusCode,
        data: rawData,
      );
    }

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
      if (message is List) return message.join('\n');
      return message?.toString();
    }
    return null;
  }
}
