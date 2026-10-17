import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class SubmitInitialAssessmentParams extends Equatable {
  final String assessmentId;
  final String benchmarkId;
  final List<AssessmentAnswer> answers;

  const SubmitInitialAssessmentParams({
    required this.assessmentId,
    required this.benchmarkId,
    required this.answers,
  });

  @override
  List<Object?> get props => [assessmentId, benchmarkId, answers];
}

class SubmitInitialAssessmentUseCase
    implements UseCase<Result<String>, SubmitInitialAssessmentParams> {
  final AssessmentRepository repository;

  SubmitInitialAssessmentUseCase(this.repository);

  @override
  Future<Result<String>> call(SubmitInitialAssessmentParams params) {
    return repository.submitInitialAssessment(
      assessmentId: params.assessmentId,
      benchmarkId: params.benchmarkId,
      answers: params.answers,
    );
  }
}

