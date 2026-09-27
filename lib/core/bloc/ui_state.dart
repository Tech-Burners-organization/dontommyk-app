import 'package:equatable/equatable.dart';

sealed class UiState<T> extends Equatable {
  const UiState();

  @override
  List<Object?> get props => const [];
}

final class UiInitial<T> extends UiState<T> {
  const UiInitial();
}

final class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

final class UiSuccess<T> extends UiState<T> {
  const UiSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class UiEmpty<T> extends UiState<T> {
  const UiEmpty([this.message = 'No data found']);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class UiFailure<T> extends UiState<T> {
  const UiFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
