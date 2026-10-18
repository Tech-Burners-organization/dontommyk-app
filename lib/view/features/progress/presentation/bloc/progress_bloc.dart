import 'package:bloc/bloc.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/progress/domain/usecases/get_progress_usecase.dart';
import 'package:tommy/view/features/progress/presentation/bloc/progress_event.dart';
import 'package:tommy/view/features/progress/presentation/bloc/progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgressUseCase getProgressUseCase;

  ProgressBloc({required this.getProgressUseCase})
      : super(const ProgressInitial()) {
    on<FetchProgressEvent>(_onFetchProgress);
    on<ChangePeriodEvent>(_onChangePeriod);
  }

  Future<void> _onFetchProgress(
    FetchProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading(period: event.period));
    final result = await getProgressUseCase(event.period);

    switch (result) {
      case ResultSuccess(data: final data):
        emit(ProgressLoaded(data: data, period: event.period));
      case ResultFailure(failure: final failure):
        emit(ProgressError(message: failure.message, period: event.period));
    }
  }

  Future<void> _onChangePeriod(
    ChangePeriodEvent event,
    Emitter<ProgressState> emit,
  ) async {
    if (state.period == event.period && state is ProgressLoaded) return;
    emit(ProgressLoading(period: event.period));
    final result = await getProgressUseCase(event.period);

    switch (result) {
      case ResultSuccess(data: final data):
        emit(ProgressLoaded(data: data, period: event.period));
      case ResultFailure(failure: final failure):
        emit(ProgressError(message: failure.message, period: event.period));
    }
  }
}

