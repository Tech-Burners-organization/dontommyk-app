import 'package:dio/dio.dart';
import 'package:tommy/core/network/api_exception.dart';
import 'package:tommy/core/network/api_response.dart';

typedef JsonDecoder<T> = T Function(dynamic json);

/// The single HTTP entry point for repositories.
///
/// Keep JSON-to-model conversion in the feature's data layer by passing a
/// [decoder]. Dio-specific errors are normalized to [ApiException].
class ApiService {
  const ApiService(this._dio);

  final Dio _dio;

  Future<ApiResponse<T>> getData<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) {
    return _request(
      () => _dio.get<dynamic>(
        path,
        queryParameters: query,
        options: _mergeOptions(options, headers),
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  Future<ApiResponse<T>> postData<T>(
    String path,
    Object? data, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) {
    return _request(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, headers),
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  Future<ApiResponse<T>> putData<T>(
    String path,
    Object? data, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) {
    return _request(
      () => _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, headers),
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  Future<ApiResponse<T>> patchData<T>(
    String path,
    Object? data, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) {
    return _request(
      () => _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, headers),
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  Future<ApiResponse<T>> deleteData<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) {
    return _request(
      () => _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, headers),
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  Future<ApiResponse<T>> postMultipartData<T>(
    String path,
    Map<String, dynamic> body, {
    required List<MultipartBody> multipartBody,
    String method = 'POST',
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) async {
    final formData = FormData.fromMap(body);

    for (final item in multipartBody) {
      formData.files.add(
        MapEntry(item.key, await MultipartFile.fromFile(item.filePath)),
      );
    }

    return _request(
      () => _dio.request<dynamic>(
        path,
        data: formData,
        options: Options(
          method: method,
          headers: headers,
          contentType: Headers.multipartFormDataContentType,
        ),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  Future<ApiResponse<T>> multipartRepo<T>(
    String path, {
    required String multipartBody,
    String fileName = 'file',
    Map<String, dynamic> fields = const {},
    String method = 'POST',
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    JsonDecoder<T>? decoder,
  }) {
    return postMultipartData<T>(
      path,
      fields,
      multipartBody: [MultipartBody(fileName, multipartBody)],
      method: method,
      headers: headers,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      decoder: decoder,
    );
  }

  Options? _mergeOptions(Options? options, Map<String, dynamic>? headers) {
    if (headers == null || headers.isEmpty) return options;

    return (options ?? Options()).copyWith(
      headers: {...?options?.headers, ...headers},
    );
  }

  Future<ApiResponse<T>> _request<T>(
    Future<Response<dynamic>> Function() request,
    JsonDecoder<T>? decoder,
  ) async {
    try {
      final response = await request();
      return ApiResponse<T>.fromResponse(response, decoder: decoder);
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(ApiException.fromDio(error), stackTrace);
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ApiException(
          type: ApiExceptionType.unknown,
          message: 'Something went wrong. Please try again.',
          cause: error,
        ),
        stackTrace,
      );
    }
  }
}

class MultipartBody {
  const MultipartBody(this.key, this.file);

  final String key;

  /// Accepts either a file path or any file object that exposes a `path`.
  final dynamic file;

  String get filePath {
    if (file is String) return file as String;
    return file.path as String;
  }
}
