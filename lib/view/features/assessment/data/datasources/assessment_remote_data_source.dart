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
  Future<AiAssessmentResponse> getAiAssessment(
    String assessmentId, {
    bool isWeekly = false,
  });
  Future<String> submitAiAssessment({
    required String assessmentId,
    required List<AssessmentAnswer> answers,
    bool isWeekly = false,
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
  Future<AiAssessmentResponse> getAiAssessment(
    String assessmentId, {
    bool isWeekly = false,
  }) async {
    final weeklyPath = '/assessments/ai/$assessmentId';
    final practicePlanPath =
        '/ai-feedback/me/practice-plan/$assessmentId/questions';

    final primaryPath = isWeekly ? weeklyPath : practicePlanPath;
    final fallbackPath = isWeekly ? practicePlanPath : weeklyPath;

    try {
      debugPrint('[GetAiAssessment] Requesting primary (isWeekly: $isWeekly): GET $primaryPath');
      final response = await apiService.getData<AiAssessmentResponse>(
        primaryPath,
        decoder: (json) => AiAssessmentResponse.fromJson(
          json as Map<String, dynamic>,
        ),
      );
      return response.data;
    } catch (e) {
      debugPrint(
          '[GetAiAssessment] $primaryPath failed: $e. Trying fallback: GET $fallbackPath...');
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
    bool isWeekly = false,
  }) async {
    final answersList = answers.map((a) => a.toJson()).toList();

    // Body for weekly assessment POST /assessments/:id/submit-ai:
    // { "assessmentData": [ { "questionId": "...", "answer": "..." } ] }
    final weeklyBody = {
      'assessmentData': answersList,
    };

    // Body for practice plan task POST /ai-feedback/me/practice-plan/:id/submit:
    // { "answers": [ { "questionId": "...", "answer": "..." } ] }
    final practicePlanBody = {
      'answers': answersList,
    };

    final weeklyPath = '/assessments/$assessmentId/submit-ai';
    final practicePlanPath =
        '/ai-feedback/me/practice-plan/$assessmentId/submit';

    final primaryPath = isWeekly ? weeklyPath : practicePlanPath;
    final primaryBody = isWeekly ? weeklyBody : practicePlanBody;

    final fallbackPath = isWeekly ? practicePlanPath : weeklyPath;
    final fallbackBody = isWeekly ? practicePlanBody : weeklyBody;

    final encoder = const JsonEncoder.withIndent('  ');
    final formattedBody = encoder.convert(primaryBody);

    debugPrint('====================================');
    debugPrint('[SubmitAiAssessment] Target ID: $assessmentId (isWeekly: $isWeekly)');
    debugPrint('[SubmitAiAssessment] Total Answers: ${answers.length}');
    debugPrint('[SubmitAiAssessment] Primary Path: POST $primaryPath');
    debugPrint('[SubmitAiAssessment] Request Body:\n$formattedBody');
    debugPrint('====================================');

    try {
      final response = await apiService.postData<Map<String, dynamic>>(
        primaryPath,
        primaryBody,
        decoder: (json) => json as Map<String, dynamic>,
      );
      return response.message ?? 'Assessment submitted successfully.';
    } catch (e) {
      debugPrint(
          '[SubmitAiAssessment] $primaryPath failed: $e. Falling back to: POST $fallbackPath...');
      final response = await apiService.postData<Map<String, dynamic>>(
        fallbackPath,
        fallbackBody,
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

