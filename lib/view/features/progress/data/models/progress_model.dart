class ProgressCurrentScoreModel {
  final int overall;
  final int leadership;
  final int communication;
  final int behavioral;
  final int emotional;

  const ProgressCurrentScoreModel({
    required this.overall,
    required this.leadership,
    required this.communication,
    required this.behavioral,
    required this.emotional,
  });

  factory ProgressCurrentScoreModel.fromJson(Map<String, dynamic> json) {
    return ProgressCurrentScoreModel(
      overall: (json['overall'] as num?)?.toInt() ?? 0,
      leadership: (json['leadership'] as num?)?.toInt() ?? 0,
      communication: (json['communication'] as num?)?.toInt() ?? 0,
      behavioral: (json['behavioral'] as num?)?.toInt() ?? 0,
      emotional: (json['emotional'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProgressTrendPointModel {
  final String label;
  final String startDate;
  final int? overallScore;
  final int assessmentCount;

  const ProgressTrendPointModel({
    required this.label,
    required this.startDate,
    this.overallScore,
    required this.assessmentCount,
  });

  factory ProgressTrendPointModel.fromJson(Map<String, dynamic> json) {
    return ProgressTrendPointModel(
      label: json['label']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      overallScore: (json['overallScore'] as num?)?.toInt(),
      assessmentCount: (json['assessmentCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProgressOverallTrendModel {
  final String period;
  final num changePercent;
  final List<ProgressTrendPointModel> points;

  const ProgressOverallTrendModel({
    required this.period,
    required this.changePercent,
    required this.points,
  });

  factory ProgressOverallTrendModel.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? [];
    return ProgressOverallTrendModel(
      period: json['period']?.toString() ?? 'weekly',
      changePercent: (json['changePercent'] as num?) ?? 0,
      points: rawPoints
          .map((p) => ProgressTrendPointModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProgressDimensionComparisonModel {
  final String category;
  final int? pre;
  final int? post;

  const ProgressDimensionComparisonModel({
    required this.category,
    this.pre,
    this.post,
  });

  factory ProgressDimensionComparisonModel.fromJson(Map<String, dynamic> json) {
    return ProgressDimensionComparisonModel(
      category: json['category']?.toString() ?? '',
      pre: (json['pre'] as num?)?.toInt(),
      post: (json['post'] as num?)?.toInt(),
    );
  }
}

class ProgressDataModel {
  final ProgressCurrentScoreModel currentScore;
  final int totalAssessmentsCompleted;
  final ProgressOverallTrendModel overallTrend;
  final List<ProgressDimensionComparisonModel> dimensionComparison;
  final String aiCompetencyAnalysis;

  const ProgressDataModel({
    required this.currentScore,
    required this.totalAssessmentsCompleted,
    required this.overallTrend,
    required this.dimensionComparison,
    required this.aiCompetencyAnalysis,
  });

  factory ProgressDataModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawDimensions = data['dimensionComparison'] as List<dynamic>? ?? [];

    return ProgressDataModel(
      currentScore: ProgressCurrentScoreModel.fromJson(
        data['currentScore'] as Map<String, dynamic>? ?? {},
      ),
      totalAssessmentsCompleted:
          (data['totalAssessmentsCompleted'] as num?)?.toInt() ?? 0,
      overallTrend: ProgressOverallTrendModel.fromJson(
        data['overallTrend'] as Map<String, dynamic>? ?? {},
      ),
      dimensionComparison: rawDimensions
          .map((d) => ProgressDimensionComparisonModel.fromJson(
              d as Map<String, dynamic>))
          .toList(),
      aiCompetencyAnalysis: data['aiCompetencyAnalysis']?.toString() ?? '',
    );
  }
}

