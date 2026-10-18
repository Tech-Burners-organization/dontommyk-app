class EmployeeScore {
  final int overall;
  final int leadership;
  final int communication;
  final int behavioral;
  final int emotional;

  const EmployeeScore({
    this.overall = 0,
    this.leadership = 0,
    this.communication = 0,
    this.behavioral = 0,
    this.emotional = 0,
  });

  factory EmployeeScore.fromJson(Map<String, dynamic> json) {
    return EmployeeScore(
      overall: (json['overall'] as num?)?.toInt() ?? 0,
      leadership: (json['leadership'] as num?)?.toInt() ?? 0,
      communication: (json['communication'] as num?)?.toInt() ?? 0,
      behavioral: (json['behavioral'] as num?)?.toInt() ?? 0,
      emotional: (json['emotional'] as num?)?.toInt() ?? 0,
    );
  }
}

class EmployeeProfile {
  final String id;
  final String userId;
  final String organizationId;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String designation;
  final int? age;
  final String? location;
  final String profilePhoto;
  final EmployeeScore? currentScore;

  const EmployeeProfile({
    required this.id,
    required this.userId,
    required this.organizationId,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.designation,
    this.age,
    this.location,
    required this.profilePhoto,
    this.currentScore,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : firstName;
  }

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return EmployeeProfile(
      id: data['_id']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      organizationId: data['organizationId']?.toString() ?? '',
      employeeCode: data['employeeCode']?.toString() ?? '',
      firstName: data['firstName']?.toString() ?? '',
      lastName: data['lastName']?.toString() ?? '',
      designation: data['designation']?.toString() ?? '',
      age: (data['age'] as num?)?.toInt(),
      location: data['location']?.toString(),
      profilePhoto: data['profilePhoto']?.toString() ?? '',
      currentScore: data['currentScore'] is Map<String, dynamic>
          ? EmployeeScore.fromJson(data['currentScore'] as Map<String, dynamic>)
          : null,
    );
  }
}

