import 'package:tommy/core/errors/exception.dart';
import 'package:tommy/core/errors/failure.dart';
import 'package:tommy/core/network/api_exception.dart';

abstract final class FailureMapper {
  static Failure from(Object error) {
    return switch (error) {
      ApiException(type: ApiExceptionType.connection, :final message) =>
        NetworkFailure(message),
      ApiException(:final message, :final statusCode) => ServerFailure(
        message,
        statusCode: statusCode,
      ),
      CacheException(:final message) => CacheFailure(message),
      AppException(:final message) => UnknownFailure(message),
      _ => const UnknownFailure('Something went wrong. Please try again.'),
    };
  }
}
