class ScoreDifferenceModel {
  final int overall;
  final int leadership;
  final int communication;
  final int behavioral;
  final int emotional;

  const ScoreDifferenceModel({
    this.overall = 0,
    this.leadership = 0,
    this.communication = 0,
    this.behavioral = 0,
    this.emotional = 0,
  });

  factory ScoreDifferenceModel.fromJson(Map<String, dynamic> json) {
    return ScoreDifferenceModel(
      overall: (json['overall'] as num?)?.toInt() ?? 0,
      leadership: (json['leadership'] as num?)?.toInt() ?? 0,
      communication: (json['communication'] as num?)?.toInt() ?? 0,
      behavioral: (json['behavioral'] as num?)?.toInt() ?? 0,
      emotional: (json['emotional'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'overall': overall,
    'leadership': leadership,
    'communication': communication,
    'behavioral': behavioral,
    'emotional': emotional,
  };
}

class AssessmentResultModel {
  final int overallScore;
  final int leadershipScore;
  final int communicationScore;
  final int behavioralScore;
  final int emotionalScore;
  final ScoreDifferenceModel? scoreDifference;
  final String? evaluatedBy;

  const AssessmentResultModel({
    this.overallScore = 0,
    this.leadershipScore = 0,
    this.communicationScore = 0,
    this.behavioralScore = 0,
    this.emotionalScore = 0,
    this.scoreDifference,
    this.evaluatedBy,
  });

  factory AssessmentResultModel.fromJson(Map<String, dynamic> json) {
    return AssessmentResultModel(
      overallScore: (json['overallScore'] as num?)?.toInt() ?? 0,
      leadershipScore: (json['leadershipScore'] as num?)?.toInt() ?? 0,
      communicationScore: (json['communicationScore'] as num?)?.toInt() ?? 0,
      behavioralScore: (json['behavioralScore'] as num?)?.toInt() ?? 0,
      emotionalScore: (json['emotionalScore'] as num?)?.toInt() ?? 0,
      scoreDifference: json['scoreDifference'] is Map<String, dynamic>
          ? ScoreDifferenceModel.fromJson(
              json['scoreDifference'] as Map<String, dynamic>,
            )
          : null,
      evaluatedBy: json['evaluatedBy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'overallScore': overallScore,
    'leadershipScore': leadershipScore,
    'communicationScore': communicationScore,
    'behavioralScore': behavioralScore,
    'emotionalScore': emotionalScore,
    'scoreDifference': scoreDifference?.toJson(),
    'evaluatedBy': evaluatedBy,
  };
}

class AssessmentHistoryItemModel {
  final String assessmentId;
  final String type;
  final String category;
  final String status;
  final String? generatedBy;
  final int? cycleNumber;
  final String? scheduledAt;
  final String? completedAt;
  final String? createdAt;
  final AssessmentResultModel? result;

  const AssessmentHistoryItemModel({
    required this.assessmentId,
    required this.type,
    required this.category,
    required this.status,
    this.generatedBy,
    this.cycleNumber,
    this.scheduledAt,
    this.completedAt,
    this.createdAt,
    this.result,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isPending => status.toLowerCase() == 'pending';

  String get displayTitle {
    if (type.toLowerCase() == 'initial') {
      return 'Initial Assessment';
    }
    final catCapitalized = category.isNotEmpty
        ? '${category[0].toUpperCase()}${category.substring(1)}'
        : '';
    if (type.toLowerCase() == 'ai') {
      return catCapitalized.isNotEmpty
          ? '$catCapitalized Assessment'
          : 'AI Assessment';
    }
    return catCapitalized.isNotEmpty
        ? '$catCapitalized Assessment'
        : 'Assessment';
  }

  factory AssessmentHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return AssessmentHistoryItemModel(
      assessmentId: json['assessmentId']?.toString() ??
          json['_id']?.toString() ??
          '',
      type: json['type']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      generatedBy: json['generatedBy']?.toString(),
      cycleNumber: (json['cycleNumber'] as num?)?.toInt(),
      scheduledAt: json['scheduledAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      result: json['result'] is Map<String, dynamic>
          ? AssessmentResultModel.fromJson(
              json['result'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

