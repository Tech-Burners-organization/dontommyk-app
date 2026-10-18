import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';

class AssessmentDetailOption {
  final String id;
  final String text;
  final int score;

  const AssessmentDetailOption({
    required this.id,
    required this.text,
    required this.score,
  });

  factory AssessmentDetailOption.fromJson(Map<String, dynamic> json) {
    return AssessmentDetailOption(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'text': text,
    'score': score,
  };
}

class AssessmentDetailQuestion {
  final String questionId;
  final String category;
  final String question;
  final List<AssessmentDetailOption> options;
  final String? selectedAnswer;
  final int? obtainedScore;
  final int? maxPossibleScore;
  final bool answered;

  const AssessmentDetailQuestion({
    required this.questionId,
    required this.category,
    required this.question,
    required this.options,
    this.selectedAnswer,
    this.obtainedScore,
    this.maxPossibleScore,
    this.answered = false,
  });

  factory AssessmentDetailQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? [];
    return AssessmentDetailQuestion(
      questionId: json['questionId']?.toString() ??
          json['_id']?.toString() ??
          '',
      category: json['category']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: rawOptions
          .map((opt) =>
              AssessmentDetailOption.fromJson(opt as Map<String, dynamic>))
          .toList(),
      selectedAnswer: json['selectedAnswer']?.toString(),
      obtainedScore: (json['obtainedScore'] as num?)?.toInt(),
      maxPossibleScore: (json['maxPossibleScore'] as num?)?.toInt(),
      answered: json['answered'] == true,
    );
  }
}

class AssessmentDetailSummary {
  final String id;
  final String type;
  final String category;
  final String status;
  final String? generatedBy;
  final String? completedAt;
  final String? createdAt;

  const AssessmentDetailSummary({
    required this.id,
    required this.type,
    required this.category,
    required this.status,
    this.generatedBy,
    this.completedAt,
    this.createdAt,
  });

  factory AssessmentDetailSummary.fromJson(Map<String, dynamic> json) {
    return AssessmentDetailSummary(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      generatedBy: json['generatedBy']?.toString(),
      completedAt: json['completedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}

class AssessmentDetailModel {
  final AssessmentDetailSummary assessment;
  final List<AssessmentDetailQuestion> questions;
  final AssessmentResultModel? result;

  const AssessmentDetailModel({
    required this.assessment,
    required this.questions,
    this.result,
  });

  factory AssessmentDetailModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final assessmentJson = data['assessment'] as Map<String, dynamic>? ?? {};
    final questionsList = data['questions'] as List<dynamic>? ?? [];

    return AssessmentDetailModel(
      assessment: AssessmentDetailSummary.fromJson(assessmentJson),
      questions: questionsList
          .map((q) =>
              AssessmentDetailQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      result: data['result'] is Map<String, dynamic>
          ? AssessmentResultModel.fromJson(
              data['result'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

