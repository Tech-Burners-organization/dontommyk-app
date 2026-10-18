import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class GetAssessmentHistoryUseCase
    implements UseCase<Result<List<AssessmentHistoryItemModel>>, NoParams> {
  final AssessmentRepository repository;

  GetAssessmentHistoryUseCase(this.repository);

  @override
  Future<Result<List<AssessmentHistoryItemModel>>> call(NoParams params) {
    return repository.getAssessmentHistory();
  }
}

