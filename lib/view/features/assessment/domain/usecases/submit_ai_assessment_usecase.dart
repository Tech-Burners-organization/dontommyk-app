import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class SubmitAiAssessmentParams extends Equatable {
  final String assessmentId;
  final List<AssessmentAnswer> answers;
  final bool isWeekly;

  const SubmitAiAssessmentParams({
    required this.assessmentId,
    required this.answers,
    this.isWeekly = false,
  });

  @override
  List<Object?> get props => [assessmentId, answers, isWeekly];
}

class SubmitAiAssessmentUseCase
    implements UseCase<Result<String>, SubmitAiAssessmentParams> {
  final AssessmentRepository repository;

  SubmitAiAssessmentUseCase(this.repository);

  @override
  Future<Result<String>> call(SubmitAiAssessmentParams params) {
    return repository.submitAiAssessment(
      assessmentId: params.assessmentId,
      answers: params.answers,
      isWeekly: params.isWeekly,
    );
  }
}

