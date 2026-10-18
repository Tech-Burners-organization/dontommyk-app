import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/home/data/models/home_data_model.dart';
import 'package:tommy/view/features/home/domain/repositories/home_repository.dart';

class GetHomeDataUseCase
    implements UseCase<Result<HomeDataModel>, NoParams> {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  @override
  Future<Result<HomeDataModel>> call(NoParams params) {
    return repository.getHomeData();
  }
}

