import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';

abstract class ProfileRepository {
  Future<Result<EmployeeProfile>> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
  });
}

