import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class GetAiAssessmentUseCase
    implements UseCase<Result<AiAssessmentResponse>, String> {
  final AssessmentRepository repository;

  GetAiAssessmentUseCase(this.repository);

  @override
  Future<Result<AiAssessmentResponse>> call(String assessmentId) {
    return repository.getAiAssessment(assessmentId);
  }
}

