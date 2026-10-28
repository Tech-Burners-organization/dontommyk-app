import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';

import 'package:tommy/view/features/profile/data/models/legal_content_model.dart';

abstract class ProfileRemoteDataSource {
  Future<EmployeeProfile> getProfile();

  Future<EmployeeProfile> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
    String? token,
  });

  Future<LegalContentModel> getLegalContent(String slug);

  Future<String> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<EmployeeProfile> getProfile() async {
    final response = await apiService.getData<EmployeeProfile>(
      '/employees/profile',
      decoder: (json) => EmployeeProfile.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  @override
  Future<LegalContentModel> getLegalContent(String slug) async {
    final cleanSlug = slug.startsWith('/') ? slug.substring(1) : slug;
    final primaryPath = cleanSlug.startsWith('app-contents/')
        ? '/$cleanSlug'
        : '/app-contents/$cleanSlug';

    final fallbackPath = cleanSlug.startsWith('legal-contents/')
        ? '/$cleanSlug'
        : '/legal-contents/$cleanSlug';

    try {
      debugPrint('[GetLegalContent] Requesting primary: GET $primaryPath');
      final response = await apiService.getData<LegalContentModel>(
        primaryPath,
        decoder: (json) => LegalContentModel.fromJson(json as Map<String, dynamic>),
      );
      return response.data;
    } catch (e) {
      debugPrint('[GetLegalContent] $primaryPath failed: $e. Trying fallback: GET $fallbackPath');
      final response = await apiService.getData<LegalContentModel>(
        fallbackPath,
        decoder: (json) => LegalContentModel.fromJson(json as Map<String, dynamic>),
      );
      return response.data;
    }
  }

  @override
  Future<EmployeeProfile> updateProfile({
    required String firstName,
    required String lastName,
    required String designation,
    int? age,
    String? location,
    String? imagePath,
    String? token,
  }) async {
    final profileData = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'designation': designation,
      'age': ?age,
      if (location != null && location.isNotEmpty) 'location': location,
    };

    var tokenToUse = (token != null && token.isNotEmpty)
        ? token.trim()
        : PrefsHelper.token.trim();
    if (tokenToUse.isEmpty) {
      tokenToUse = (await PrefsHelper.getString('token')).trim();
    }

    final cleanToken = tokenToUse
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
        .trim();

    final headers = <String, dynamic>{
      'Content-Type': 'multipart/form-data',
      if (cleanToken.isNotEmpty) 'Authorization': 'Bearer $cleanToken',
    };

    debugPrint('====================================');
    debugPrint('[UpdateProfile] Sending Multipart Request: PATCH /employees/profile');
    debugPrint('[UpdateProfile] Token: ${cleanToken.isNotEmpty ? (cleanToken.length > 25 ? "${cleanToken.substring(0, 25)}..." : cleanToken) : "EMPTY!"}');
    debugPrint('[UpdateProfile] Headers: $headers');
    debugPrint('[UpdateProfile] ProfileData: $profileData');
    debugPrint('====================================');

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
      headers: headers,
      decoder: (json) => EmployeeProfile.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  @override
  Future<String> deleteAccount() async {
    final response = await apiService.deleteData<dynamic>(
      '/employees/profile',
      decoder: (json) => json,
    );
    return response.message ?? 'Account deleted successfully.';
  }
}

