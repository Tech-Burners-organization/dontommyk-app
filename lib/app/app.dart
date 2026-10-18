import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/app/cubit/app_cubit.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/core/di/app_dependencies.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/route/app_route.dart';

import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';

import 'package:tommy/view/features/home/domain/repositories/home_repository.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';

import 'package:tommy/view/features/progress/domain/repositories/progress_repository.dart';

class TommyApp extends StatelessWidget {
  const TommyApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiService>.value(value: dependencies.apiService),
        RepositoryProvider<AuthRepository>.value(
          value: dependencies.authRepository,
        ),
        RepositoryProvider<AssessmentRepository>.value(
          value: dependencies.assessmentRepository,
        ),
        RepositoryProvider<ProfileRepository>.value(
          value: dependencies.profileRepository,
        ),
        RepositoryProvider<HomeRepository>.value(
          value: dependencies.homeRepository,
        ),
        RepositoryProvider<ProgressRepository>.value(
          value: dependencies.progressRepository,
        ),
        RepositoryProvider<AiCoachRepository>.value(
          value: dependencies.aiCoachRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AppCubit(),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return MaterialApp(
                  navigatorKey: AppRoute.navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Tommy',
                  themeMode: state.themeMode,
                  theme: _theme(Brightness.light),
                  darkTheme: _theme(Brightness.dark),
                  initialRoute: AppRoute.splash,
                  onGenerateRoute: AppRoute.onGenerateRoute,
                );
              },
            );
          },
        ),
      ),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? AppColor.screenBg
          : colorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
