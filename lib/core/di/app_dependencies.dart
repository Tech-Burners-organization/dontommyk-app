import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/config/app_config.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/core/network/auth_interceptor.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/assessment/data/datasources/assessment_remote_data_source.dart';
import 'package:tommy/view/features/assessment/data/repositories/assessment_repository_impl.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:tommy/view/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tommy/view/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';
import 'package:tommy/view/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tommy/view/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tommy/view/features/ai_coach/data/datasources/ai_coach_remote_data_source.dart';
import 'package:tommy/view/features/ai_coach/data/repositories/ai_coach_repository_impl.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:tommy/view/features/home/data/datasources/home_remote_data_source.dart';
import 'package:tommy/view/features/home/data/repositories/home_repository_impl.dart';
import 'package:tommy/view/features/home/domain/repositories/home_repository.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';
import 'package:tommy/view/features/progress/data/datasources/progress_remote_data_source.dart';
import 'package:tommy/view/features/progress/data/repositories/progress_repository_impl.dart';
import 'package:tommy/view/features/progress/domain/repositories/progress_repository.dart';

class AppDependencies {
  AppDependencies._({
    required this.apiService,
    required this.authRepository,
    required this.assessmentRepository,
    required this.profileRepository,
    required this.homeRepository,
    required this.progressRepository,
    required this.aiCoachRepository,
  });

  final ApiService apiService;
  final AuthRepository authRepository;
  final AssessmentRepository assessmentRepository;
  final ProfileRepository profileRepository;
  final HomeRepository homeRepository;
  final ProgressRepository progressRepository;
  final AiCoachRepository aiCoachRepository;

  factory AppDependencies.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: const {
          Headers.acceptHeader: Headers.jsonContentType,
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(tokenProvider: () async {
        if (PrefsHelper.token.isNotEmpty) return PrefsHelper.token;
        if (PrefsHelper.resetToken.isNotEmpty) return PrefsHelper.resetToken;
        final saved = await PrefsHelper.getString('token');
        if (saved.isNotEmpty) return saved;
        return await PrefsHelper.getString('resetToken');
      }),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
          logPrint: _debugLog,
        ),
      );
    }

    final apiService = ApiService(dio);
    final authRemoteDataSource = AuthRemoteDataSourceImpl(apiService);
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);

    final assessmentRemoteDataSource =
        AssessmentRemoteDataSourceImpl(apiService);
    final assessmentRepository =
        AssessmentRepositoryImpl(assessmentRemoteDataSource);

    final profileRemoteDataSource = ProfileRemoteDataSourceImpl(apiService);
    final profileRepository = ProfileRepositoryImpl(profileRemoteDataSource);

    final homeRemoteDataSource = HomeRemoteDataSourceImpl(apiService);
    final homeRepository = HomeRepositoryImpl(homeRemoteDataSource);

    final progressRemoteDataSource = ProgressRemoteDataSourceImpl(apiService);
    final progressRepository =
        ProgressRepositoryImpl(progressRemoteDataSource);

    final aiCoachRemoteDataSource = AiCoachRemoteDataSourceImpl(apiService);
    final aiCoachRepository = AiCoachRepositoryImpl(aiCoachRemoteDataSource);

    return AppDependencies._(
      apiService: apiService,
      authRepository: authRepository,
      assessmentRepository: assessmentRepository,
      profileRepository: profileRepository,
      homeRepository: homeRepository,
      progressRepository: progressRepository,
      aiCoachRepository: aiCoachRepository,
    );
  }
}

void _debugLog(Object message) {
  if (kDebugMode) debugPrint(message.toString());
}
