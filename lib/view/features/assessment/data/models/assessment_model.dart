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
  final String assessmentId;
  final String category;
  final String question;
  final List<AssessmentOption> options;
  final int order;

  const AssessmentQuestion({
    required this.id,
    this.benchmarkId = '',
    this.assessmentId = '',
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
      assessmentId: json['assessmentId']?.toString() ?? '',
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
  final String category;
  final String type;
  final String status;
  final int cycleNumber;
  final String scheduledAt;

  const AssessmentInfo({
    required this.id,
    this.employeeId = '',
    this.organizationId = '',
    this.benchmarkId = '',
    this.category = '',
    this.type = '',
    this.status = '',
    this.cycleNumber = 1,
    this.scheduledAt = '',
  });

  factory AssessmentInfo.fromJson(Map<String, dynamic> json) {
    return AssessmentInfo(
      id: json['_id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      benchmarkId: json['benchmarkId']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      cycleNumber: (json['cycleNumber'] as num?)?.toInt() ?? 1,
      scheduledAt: json['scheduledAt']?.toString() ?? '',
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

class AiAssessmentResponse {
  final AssessmentInfo assessment;
  final List<AssessmentQuestion> questions;
  final bool isDue;
  final String availableAt;

  const AiAssessmentResponse({
    required this.assessment,
    required this.questions,
    this.isDue = true,
    this.availableAt = '',
  });

  factory AiAssessmentResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final taskOrAssessmentJson =
        (data['task'] ?? data['assessment']) as Map<String, dynamic>? ?? {};
    final category = taskOrAssessmentJson['category']?.toString() ?? '';
    final assessmentId = taskOrAssessmentJson['_id']?.toString() ?? '';

    final rawQuestions =
        (data['questions'] ?? data['assessmentQuestions']) as List<dynamic>? ??
            [];

    final parsedQuestions = rawQuestions.map((q) {
      if (q is Map<String, dynamic>) {
        final qCategory = q['category']?.toString();
        final qWithFallback = Map<String, dynamic>.from(q);
        if (qCategory == null || qCategory.isEmpty) {
          qWithFallback['category'] = category;
        }
        if (!qWithFallback.containsKey('assessmentId')) {
          qWithFallback['assessmentId'] = assessmentId;
        }
        return AssessmentQuestion.fromJson(qWithFallback);
      }
      return AssessmentQuestion.fromJson({});
    }).toList();

    return AiAssessmentResponse(
      assessment: AssessmentInfo.fromJson(taskOrAssessmentJson),
      questions: parsedQuestions,
      isDue: data['isDue'] as bool? ?? true,
      availableAt: data['availableAt']?.toString() ?? '',
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

