import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class GetInitialAssessmentUseCase
    implements UseCase<Result<InitialAssessmentResponse>, NoParams> {
  final AssessmentRepository repository;

  GetInitialAssessmentUseCase(this.repository);

  @override
  Future<Result<InitialAssessmentResponse>> call(NoParams params) {
    return repository.getInitialAssessment();
  }
}

