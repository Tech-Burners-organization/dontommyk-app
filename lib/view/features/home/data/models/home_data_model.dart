import 'package:tommy/view/features/auth/data/models/login_response.dart';

class HomeProfileModel {
  final String id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String designation;
  final String profilePhoto;

  const HomeProfileModel({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.profilePhoto,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory HomeProfileModel.fromJson(Map<String, dynamic> json) {
    return HomeProfileModel(
      id: json['_id']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      profilePhoto: json['profilePhoto']?.toString() ?? '',
    );
  }
}

class HomeScoresModel {
  final int overall;
  final int leadership;
  final int communication;
  final int behavioral;
  final int emotional;

  const HomeScoresModel({
    required this.overall,
    required this.leadership,
    required this.communication,
    required this.behavioral,
    required this.emotional,
  });

  factory HomeScoresModel.fromJson(Map<String, dynamic> json) {
    return HomeScoresModel(
      overall: (json['overall'] as num?)?.toInt() ?? 0,
      leadership: (json['leadership'] as num?)?.toInt() ?? 0,
      communication: (json['communication'] as num?)?.toInt() ?? 0,
      behavioral: (json['behavioral'] as num?)?.toInt() ?? 0,
      emotional: (json['emotional'] as num?)?.toInt() ?? 0,
    );
  }
}

class HomeCycleModel {
  final int day;
  final int totalDays;
  final double dayProgressPercent;
  final int completedTasks;
  final int totalTasks;
  final double taskProgressPercent;
  final String startedAt;
  final String nextAssessmentDate;

  const HomeCycleModel({
    required this.day,
    required this.totalDays,
    required this.dayProgressPercent,
    required this.completedTasks,
    required this.totalTasks,
    required this.taskProgressPercent,
    required this.startedAt,
    required this.nextAssessmentDate,
  });

  factory HomeCycleModel.fromJson(Map<String, dynamic> json) {
    return HomeCycleModel(
      day: (json['day'] as num?)?.toInt() ?? 1,
      totalDays: (json['totalDays'] as num?)?.toInt() ?? 7,
      dayProgressPercent:
          (json['dayProgressPercent'] as num?)?.toDouble() ?? 0.0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 7,
      taskProgressPercent:
          (json['taskProgressPercent'] as num?)?.toDouble() ?? 0.0,
      startedAt: json['startedAt']?.toString() ?? '',
      nextAssessmentDate: json['nextAssessmentDate']?.toString() ?? '',
    );
  }
}

class HomeTaskModel {
  final String id;
  final String? assessmentId;
  final int day;
  final String category;
  final String title;
  final String description;
  final bool completed;
  final String? completedAt;
  final int? score;
  final int questionCount;

  const HomeTaskModel({
    required this.id,
    this.assessmentId,
    required this.day,
    required this.category,
    required this.title,
    required this.description,
    required this.completed,
    this.completedAt,
    this.score,
    this.questionCount = 0,
  });

  factory HomeTaskModel.fromJson(Map<String, dynamic> json) {
    return HomeTaskModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      assessmentId: json['assessmentId']?.toString() ??
          json['assessment_id']?.toString() ??
          (json['assessment'] is Map
              ? json['assessment']['_id']?.toString()
              : (json['assessment'] is String ? json['assessment'].toString() : null)),
      day: (json['day'] as num?)?.toInt() ?? 1,
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt']?.toString(),
      score: (json['score'] as num?)?.toInt(),
      questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class HomeTodayPlanModel {
  final int day;
  final List<HomeTaskModel> tasks;
  final int completedCount;
  final int totalCount;

  const HomeTodayPlanModel({
    required this.day,
    required this.tasks,
    required this.completedCount,
    required this.totalCount,
  });

  int get calculatedCompletedCount =>
      tasks.isNotEmpty ? tasks.where((t) => t.completed).length : completedCount;

  int get calculatedTotalCount =>
      tasks.isNotEmpty ? tasks.length : totalCount;

  factory HomeTodayPlanModel.fromJson(Map<String, dynamic> json) {
    final rawTasks = json['tasks'] as List<dynamic>? ?? [];
    final tasksList = rawTasks
        .map((e) => HomeTaskModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final actualCompleted = tasksList.where((t) => t.completed).length;
    final actualTotal = tasksList.length;

    return HomeTodayPlanModel(
      day: (json['day'] as num?)?.toInt() ?? 1,
      tasks: tasksList,
      completedCount: actualTotal > 0
          ? actualCompleted
          : ((json['completedCount'] as num?)?.toInt() ?? 0),
      totalCount: actualTotal > 0
          ? actualTotal
          : ((json['totalCount'] as num?)?.toInt() ?? 0),
    );
  }
}

class HomeNextAssessmentModel {
  final String assessmentId;
  final String type;
  final String category;
  final int cycleNumber;
  final String scheduledAt;
  final bool isDue;

  const HomeNextAssessmentModel({
    required this.assessmentId,
    required this.type,
    required this.category,
    required this.cycleNumber,
    required this.scheduledAt,
    required this.isDue,
  });

  factory HomeNextAssessmentModel.fromJson(Map<String, dynamic> json) {
    return HomeNextAssessmentModel(
      assessmentId: json['assessmentId']?.toString() ??
          json['_id']?.toString() ??
          json['id']?.toString() ??
          json['assessment_id']?.toString() ??
          '',
      type: json['type']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      cycleNumber: (json['cycleNumber'] as num?)?.toInt() ?? 1,
      scheduledAt: json['scheduledAt']?.toString() ??
          json['scheduled_at']?.toString() ??
          '',
      isDue: json['isDue'] as bool? ?? json['is_due'] as bool? ?? false,
    );
  }
}

class HomeDataModel {
  final HomeProfileModel profile;
  final HomeScoresModel scores;
  final String aiRecommendation;
  final HomeCycleModel cycle;
  final HomeTodayPlanModel todayPlan;
  final List<HomeTaskModel> practicePlan;
  final HomeNextAssessmentModel? nextAssessment;
  final bool aiProcessing;
  final OnboardingInfo? onboarding;

  const HomeDataModel({
    required this.profile,
    required this.scores,
    required this.aiRecommendation,
    required this.cycle,
    required this.todayPlan,
    required this.practicePlan,
    this.nextAssessment,
    required this.aiProcessing,
    this.onboarding,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawPracticePlan = data['practicePlan'] as List<dynamic>? ?? [];
    return HomeDataModel(
      profile: HomeProfileModel.fromJson(
        data['profile'] as Map<String, dynamic>? ?? {},
      ),
      scores: HomeScoresModel.fromJson(
        data['scores'] as Map<String, dynamic>? ?? {},
      ),
      aiRecommendation: data['aiRecommendation']?.toString() ?? '',
      cycle: HomeCycleModel.fromJson(
        data['cycle'] as Map<String, dynamic>? ?? {},
      ),
      todayPlan: HomeTodayPlanModel.fromJson(
        data['todayPlan'] as Map<String, dynamic>? ?? {},
      ),
      practicePlan: rawPracticePlan
          .map((e) => HomeTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextAssessment: data['nextAssessment'] != null
          ? HomeNextAssessmentModel.fromJson(
              data['nextAssessment'] as Map<String, dynamic>,
            )
          : null,
      aiProcessing: data['aiProcessing'] as bool? ?? false,
      onboarding: data['onboarding'] != null
          ? OnboardingInfo.fromJson(
              data['onboarding'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

