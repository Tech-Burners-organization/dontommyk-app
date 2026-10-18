import 'dart:convert';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<EmployeeProfile> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<EmployeeProfile> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
  }) async {
    final profileData = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'designation': designation,
      if (age != null) 'age': age,
      if (location != null && location.isNotEmpty) 'location': location,
    };

    final fields = <String, dynamic>{
      'data': jsonEncode(profileData),
      ...profileData.map((k, v) => MapEntry(k, v.toString())),
    };

    final multipartList = <MultipartBody>[];
    if (imagePath != null && imagePath.isNotEmpty) {
      multipartList.add(MultipartBody('image', imagePath));
    }

    final response = await apiService.postMultipartData<EmployeeProfile>(
      '/employees/profile',
      fields,
      multipartBody: multipartList,
      method: 'PATCH',
      decoder: (json) => EmployeeProfile.fromJson(json as Map<String, dynamic>),
    );

    return response.data;
  }
}

