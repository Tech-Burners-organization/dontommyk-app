import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_detail_model.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';

abstract class AssessmentRepository {
  Future<Result<InitialAssessmentResponse>> getInitialAssessment();
  Future<Result<String>> submitInitialAssessment({
    required String assessmentId,
    required String benchmarkId,
    required List<AssessmentAnswer> answers,
  });
  Future<Result<AiAssessmentResponse>> getAiAssessment(String assessmentId);
  Future<Result<String>> submitAiAssessment({
    required String assessmentId,
    required List<AssessmentAnswer> answers,
  });
  Future<Result<List<AssessmentHistoryItemModel>>> getAssessmentHistory();
  Future<Result<AssessmentDetailModel>> getAssessmentDetail(String assessmentId);
}

