import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/data/models/legal_content_model.dart';

abstract class ProfileRepository {
  Future<Result<EmployeeProfile>> getProfile();

  Future<Result<EmployeeProfile>> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
    String? token,
  });

  Future<Result<LegalContentModel>> getLegalContent(String slug);

  Future<Result<String>> deleteAccount();
}

