import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_detail_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class GetAssessmentDetailUseCase
    implements UseCase<Result<AssessmentDetailModel>, String> {
  final AssessmentRepository repository;

  GetAssessmentDetailUseCase(this.repository);

  @override
  Future<Result<AssessmentDetailModel>> call(String assessmentId) {
    return repository.getAssessmentDetail(assessmentId);
  }
}

