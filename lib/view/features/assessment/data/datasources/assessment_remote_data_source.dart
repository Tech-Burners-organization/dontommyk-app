import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_detail_model.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';

abstract class AssessmentRemoteDataSource {
  Future<InitialAssessmentResponse> getInitialAssessment();
  Future<String> submitInitialAssessment({
    required String assessmentId,
    required String benchmarkId,
    required List<AssessmentAnswer> answers,
  });
  Future<AiAssessmentResponse> getAiAssessment(String assessmentId);
  Future<String> submitAiAssessment({
    required String assessmentId,
    required List<AssessmentAnswer> answers,
  });
  Future<List<AssessmentHistoryItemModel>> getAssessmentHistory();
  Future<AssessmentDetailModel> getAssessmentDetail(String assessmentId);
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

  @override
  Future<AiAssessmentResponse> getAiAssessment(String assessmentId) async {
    final practicePlanPath =
        '/ai-feedback/me/practice-plan/$assessmentId/questions';
    try {
      debugPrint('[GetAiAssessment] Requesting: GET $practicePlanPath');
      final response = await apiService.getData<AiAssessmentResponse>(
        practicePlanPath,
        decoder: (json) => AiAssessmentResponse.fromJson(
          json as Map<String, dynamic>,
        ),
      );
      return response.data;
    } catch (e) {
      debugPrint(
          '[GetAiAssessment] $practicePlanPath failed: $e. Trying fallback /assessments/ai/$assessmentId...');
      final fallbackPath = '/assessments/ai/$assessmentId';
      final response = await apiService.getData<AiAssessmentResponse>(
        fallbackPath,
        decoder: (json) => AiAssessmentResponse.fromJson(
          json as Map<String, dynamic>,
        ),
      );
      return response.data;
    }
  }

  @override
  Future<String> submitAiAssessment({
    required String assessmentId,
    required List<AssessmentAnswer> answers,
  }) async {
    final body = {
      'answers': answers.map((a) => a.toJson()).toList(),
    };

    final encoder = const JsonEncoder.withIndent('  ');
    final formattedBody = encoder.convert(body);

    debugPrint('====================================');
    debugPrint('[SubmitAiAssessment] Target ID: $assessmentId');
    debugPrint('[SubmitAiAssessment] Total Answers: ${answers.length}');
    debugPrint('[SubmitAiAssessment] Request Body:\n$formattedBody');
    debugPrint('====================================');

    // 1. Practice plan submit endpoint from Postman:
    // POST /ai-feedback/me/practice-plan/:task_id/submit
    final practicePlanPath =
        '/ai-feedback/me/practice-plan/$assessmentId/submit';
    try {
      debugPrint('[SubmitAiAssessment] Attempting: POST $practicePlanPath');
      final response = await apiService.postData<Map<String, dynamic>>(
        practicePlanPath,
        body,
        decoder: (json) => json as Map<String, dynamic>,
      );
      return response.message ?? 'Assessment submitted successfully.';
    } catch (e) {
      debugPrint(
          '[SubmitAiAssessment] $practicePlanPath failed: $e. Falling back to /assessments/$assessmentId/submit-ai...');
      final fallbackPath = '/assessments/$assessmentId/submit-ai';
      final response = await apiService.postData<Map<String, dynamic>>(
        fallbackPath,
        body,
        decoder: (json) => json as Map<String, dynamic>,
      );
      return response.message ?? 'Assessment submitted successfully.';
    }
  }

  @override
  Future<List<AssessmentHistoryItemModel>> getAssessmentHistory() async {
    final response = await apiService.getData<List<AssessmentHistoryItemModel>>(
      '/assessments/history',
      decoder: (json) {
        final map = json as Map<String, dynamic>;
        final rawList = map['data'] is List<dynamic>
            ? map['data'] as List<dynamic>
            : [];
        return rawList
            .map((item) => AssessmentHistoryItemModel.fromJson(
                  item as Map<String, dynamic>,
                ))
            .toList();
      },
    );
    return response.data;
  }

  @override
  Future<AssessmentDetailModel> getAssessmentDetail(
    String assessmentId,
  ) async {
    final response = await apiService.getData<AssessmentDetailModel>(
      '/assessments/$assessmentId/detail',
      decoder: (json) {
        final map = json as Map<String, dynamic>;
        final data = map['data'] is Map<String, dynamic>
            ? map['data'] as Map<String, dynamic>
            : map;
        return AssessmentDetailModel.fromJson(data);
      },
    );
    return response.data;
  }
}

