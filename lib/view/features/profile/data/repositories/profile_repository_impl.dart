import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<EmployeeProfile>> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
  }) async {
    try {
      final profile = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        designation: designation,
        age: age,
        location: location,
        imagePath: imagePath,
      );

      // Cache updated values in PrefsHelper
      if (profile.fullName.isNotEmpty) {
        await PrefsHelper.setString('name', profile.fullName);
      }
      if (profile.designation.isNotEmpty) {
        await PrefsHelper.setString('role', profile.designation);
      }
      if (profile.profilePhoto.isNotEmpty) {
        await PrefsHelper.setString('profileImage', profile.profilePhoto);
      }
      await PrefsHelper.setProfileCompleted(true);

      return ResultSuccess(profile);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}

