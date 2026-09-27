import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/app/cubit/app_cubit.dart';
import 'package:tommy/core/constant/app_color.dart';
import 'package:tommy/core/di/app_dependencies.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/route/app_route.dart';

class TommyApp extends StatelessWidget {
  const TommyApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiService>.value(value: dependencies.apiService),
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
