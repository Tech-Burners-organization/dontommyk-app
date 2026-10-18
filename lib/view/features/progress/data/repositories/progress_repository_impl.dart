import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/progress/data/datasources/progress_remote_data_source.dart';
import 'package:tommy/view/features/progress/data/models/progress_model.dart';
import 'package:tommy/view/features/progress/domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<ProgressDataModel>> getProgress({required String period}) async {
    try {
      final progressData = await remoteDataSource.getProgress(period: period);
      return ResultSuccess(progressData);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}

