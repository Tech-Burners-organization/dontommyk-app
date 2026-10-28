import 'package:tommy/core/errors/failure_mapper.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/data/models/legal_content_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<EmployeeProfile>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();

      if (profile.fullName.isNotEmpty) {
        await PrefsHelper.setString('name', profile.fullName);
      }
      if (profile.designation.isNotEmpty) {
        await PrefsHelper.setString('role', profile.designation);
      }
      if (profile.profilePhoto.isNotEmpty) {
        await PrefsHelper.setString('profileImage', profile.profilePhoto);
      }
      if (profile.location != null && profile.location!.isNotEmpty) {
        await PrefsHelper.setString('location', profile.location);
      }
      if (profile.age != null) {
        await PrefsHelper.setInt('age', profile.age!);
      }

      return ResultSuccess(profile);
    } catch (e) {
      // Fallback: If remote call fails, construct profile from cached PrefsHelper
      final name = PrefsHelper.name;
      final role = PrefsHelper.role;
      final image = PrefsHelper.profileImage;
      if (name.isNotEmpty || role.isNotEmpty) {
        final parts = name.split(' ');
        final firstName = parts.isNotEmpty ? parts.first : '';
        final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        final age = await PrefsHelper.getInt('age');
        final location = await PrefsHelper.getString('location');

        return ResultSuccess(
          EmployeeProfile(
            id: '',
            userId: '',
            organizationId: '',
            employeeCode: '',
            firstName: firstName,
            lastName: lastName,
            designation: role,
            profilePhoto: image,
            age: age > 0 ? age : null,
            location: location.isNotEmpty ? location : null,
          ),
        );
      }
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<EmployeeProfile>> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
    String? token,
  }) async {
    try {
      if (token != null && token.isNotEmpty) {
        await PrefsHelper.setString('token', token);
      }
      final profile = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        designation: designation,
        age: age,
        location: location,
        imagePath: imagePath,
        token: token,
      );

      // Cache updated values in PrefsHelper
      if (profile.fullName.isNotEmpty) {
        await PrefsHelper.setString('name', profile.fullName);
      }
      if (profile.firstName.isNotEmpty) {
        await PrefsHelper.setString('firstName', profile.firstName);
      }
      if (profile.lastName.isNotEmpty) {
        await PrefsHelper.setString('lastName', profile.lastName);
      }
      if (profile.designation.isNotEmpty) {
        await PrefsHelper.setString('role', profile.designation);
      }
      if (profile.profilePhoto.isNotEmpty) {
        await PrefsHelper.setString('profileImage', profile.profilePhoto);
      }
      if (location != null && location.isNotEmpty) {
        await PrefsHelper.setString('location', location);
      }
      if (age != null) {
        await PrefsHelper.setInt('age', age);
      }
      await PrefsHelper.setProfileCompleted(true);

      return ResultSuccess(profile);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<LegalContentModel>> getLegalContent(String slug) async {
    try {
      final legalContent = await remoteDataSource.getLegalContent(slug);
      return ResultSuccess(legalContent);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }

  @override
  Future<Result<String>> deleteAccount() async {
    try {
      final message = await remoteDataSource.deleteAccount();
      await PrefsHelper.clearAllData();
      return ResultSuccess(message);
    } catch (e) {
      return ResultFailure(FailureMapper.from(e));
    }
  }
}

