import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/assessment/data/datasources/assessment_remote_data_source.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final AssessmentRemoteDataSource remoteDataSource;

  AssessmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<InitialAssessmentResponse>> getInitialAssessment() async {
    try {
      final response = await remoteDataSource.getInitialAssessment();
      return ResultSuccess(response);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> submitInitialAssessment({
    required String assessmentId,
    required String benchmarkId,
    required List<AssessmentAnswer> answers,
  }) async {
    try {
      final message = await remoteDataSource.submitInitialAssessment(
        assessmentId: assessmentId,
        benchmarkId: benchmarkId,
        answers: answers,
      );
      return ResultSuccess(message);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}

