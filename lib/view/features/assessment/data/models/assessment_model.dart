class AssessmentOption {
  final String id;
  final String text;
  final int score;

  const AssessmentOption({
    required this.id,
    required this.text,
    required this.score,
  });

  factory AssessmentOption.fromJson(Map<String, dynamic> json) {
    return AssessmentOption(
      id: json['_id']?.toString() ?? '',
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

class AssessmentQuestion {
  final String id;
  final String benchmarkId;
  final String category;
  final String question;
  final List<AssessmentOption> options;
  final int order;

  const AssessmentQuestion({
    required this.id,
    required this.benchmarkId,
    required this.category,
    required this.question,
    required this.options,
    required this.order,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? [];
    return AssessmentQuestion(
      id: json['_id']?.toString() ?? '',
      benchmarkId: json['benchmarkId']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: rawOptions
          .map((opt) => AssessmentOption.fromJson(opt as Map<String, dynamic>))
          .toList(),
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class AssessmentInfo {
  final String id;
  final String employeeId;
  final String organizationId;
  final String benchmarkId;
  final String type;
  final String status;

  const AssessmentInfo({
    required this.id,
    required this.employeeId,
    required this.organizationId,
    required this.benchmarkId,
    required this.type,
    required this.status,
  });

  factory AssessmentInfo.fromJson(Map<String, dynamic> json) {
    return AssessmentInfo(
      id: json['_id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      benchmarkId: json['benchmarkId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class InitialAssessmentResponse {
  final AssessmentInfo assessment;
  final List<AssessmentQuestion> questions;

  const InitialAssessmentResponse({
    required this.assessment,
    required this.questions,
  });

  factory InitialAssessmentResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final assessmentJson = data['assessment'] as Map<String, dynamic>? ?? {};
    final questionsList = data['assessmentQuestions'] as List<dynamic>? ?? [];

    return InitialAssessmentResponse(
      assessment: AssessmentInfo.fromJson(assessmentJson),
      questions: questionsList
          .map((q) => AssessmentQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AssessmentAnswer {
  final String questionId;
  final String answer;

  const AssessmentAnswer({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'answer': answer,
  };
}

