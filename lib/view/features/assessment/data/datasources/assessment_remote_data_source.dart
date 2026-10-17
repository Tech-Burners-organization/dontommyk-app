import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';

abstract class AssessmentRemoteDataSource {
  Future<InitialAssessmentResponse> getInitialAssessment();
  Future<String> submitInitialAssessment({
    required String assessmentId,
    required String benchmarkId,
    required List<AssessmentAnswer> answers,
  });
}

class AssessmentRemoteDataSourceImpl implements AssessmentRemoteDataSource {
  final ApiService apiService;

  AssessmentRemoteDataSourceImpl(this.apiService);

  @override
  Future<InitialAssessmentResponse> getInitialAssessment() async {
    final response = await apiService.getData<InitialAssessmentResponse>(
      '/assessments/initial',
      decoder: (json) => InitialAssessmentResponse.fromJson(
        json as Map<String, dynamic>,
      ),
    );
    return response.data;
  }

  @override
  Future<String> submitInitialAssessment({
    required String assessmentId,
    required String benchmarkId,
    required List<AssessmentAnswer> answers,
  }) async {
    final path =
        '/assessments/$assessmentId/submit-initial/benchmark/$benchmarkId';

    final body = {
      'assessmentData': answers.map((a) => a.toJson()).toList(),
    };

    final response = await apiService.postData<Map<String, dynamic>>(
      path,
      body,
      decoder: (json) => json as Map<String, dynamic>,
    );

    return response.message ?? 'Assessment submitted successfully.';
  }
}

