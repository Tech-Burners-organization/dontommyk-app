import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_assessment_history_usecase.dart';

sealed class AssessmentHistoryState extends Equatable {
  const AssessmentHistoryState();

  @override
  List<Object?> get props => [];
}

class AssessmentHistoryInitial extends AssessmentHistoryState {
  const AssessmentHistoryInitial();
}

class AssessmentHistoryLoading extends AssessmentHistoryState {
  const AssessmentHistoryLoading();
}

class AssessmentHistoryLoaded extends AssessmentHistoryState {
  final List<AssessmentHistoryItemModel> history;

  const AssessmentHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class AssessmentHistoryError extends AssessmentHistoryState {
  final String message;

  const AssessmentHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class AssessmentHistoryCubit extends Cubit<AssessmentHistoryState> {
  final GetAssessmentHistoryUseCase getAssessmentHistoryUseCase;

  AssessmentHistoryCubit({required this.getAssessmentHistoryUseCase})
      : super(const AssessmentHistoryInitial());

  Future<void> fetchHistory() async {
    emit(const AssessmentHistoryLoading());
    final result = await getAssessmentHistoryUseCase(const NoParams());
    switch (result) {
      case ResultSuccess(data: final history):
        emit(AssessmentHistoryLoaded(history));
      case ResultFailure(failure: final failure):
        emit(AssessmentHistoryError(failure.message));
    }
  }
}

