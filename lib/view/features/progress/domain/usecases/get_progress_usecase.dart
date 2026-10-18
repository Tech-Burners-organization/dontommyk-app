import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/progress/data/models/progress_model.dart';
import 'package:tommy/view/features/progress/domain/repositories/progress_repository.dart';

class GetProgressUseCase implements UseCase<Result<ProgressDataModel>, String> {
  final ProgressRepository repository;

  GetProgressUseCase(this.repository);

  @override
  Future<Result<ProgressDataModel>> call(String period) {
    return repository.getProgress(period: period);
  }
}

