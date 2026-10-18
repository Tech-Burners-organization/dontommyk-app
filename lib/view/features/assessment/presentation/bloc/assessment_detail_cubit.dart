import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_detail_model.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_assessment_detail_usecase.dart';

sealed class AssessmentDetailState extends Equatable {
  const AssessmentDetailState();

  @override
  List<Object?> get props => [];
}

class AssessmentDetailInitial extends AssessmentDetailState {
  const AssessmentDetailInitial();
}

class AssessmentDetailLoading extends AssessmentDetailState {
  const AssessmentDetailLoading();
}

class AssessmentDetailLoaded extends AssessmentDetailState {
  final AssessmentDetailModel detail;

  const AssessmentDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class AssessmentDetailError extends AssessmentDetailState {
  final String message;

  const AssessmentDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class AssessmentDetailCubit extends Cubit<AssessmentDetailState> {
  final GetAssessmentDetailUseCase getAssessmentDetailUseCase;

  AssessmentDetailCubit({required this.getAssessmentDetailUseCase})
      : super(const AssessmentDetailInitial());

  Future<void> fetchDetail(String assessmentId) async {
    emit(const AssessmentDetailLoading());
    final result = await getAssessmentDetailUseCase(assessmentId);
    switch (result) {
      case ResultSuccess(data: final detail):
        emit(AssessmentDetailLoaded(detail));
      case ResultFailure(failure: final failure):
        emit(AssessmentDetailError(failure.message));
    }
  }
}

