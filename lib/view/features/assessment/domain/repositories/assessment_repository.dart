import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';

abstract class AssessmentRepository {
  Future<Result<InitialAssessmentResponse>> getInitialAssessment();
  Future<Result<String>> submitInitialAssessment({
    required String assessmentId,
    required String benchmarkId,
    required List<AssessmentAnswer> answers,
  });
}

