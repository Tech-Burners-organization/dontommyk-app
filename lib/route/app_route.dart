import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/auth/domain/repositories/auth_repository.dart';
import 'package:tommy/view/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/login_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tommy/view/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_ai_assessment_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_assessment_detail_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_assessment_history_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_initial_assessment_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/submit_ai_assessment_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/submit_initial_assessment_usecase.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/ai_assessment_cubit.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/assessment_bloc.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/assessment_detail_cubit.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/assessment_history_cubit.dart';
import 'package:tommy/view/features/home/domain/repositories/home_repository.dart';
import 'package:tommy/view/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_bloc.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_event.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';
import 'package:tommy/view/features/profile/domain/usecases/get_legal_content_usecase.dart';
import 'package:tommy/view/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:tommy/view/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:tommy/view/features/profile/presentation/bloc/legal_content_cubit.dart';
import 'package:tommy/view/features/profile/presentation/bloc/profile_bloc.dart';

import 'package:tommy/view/features/ai_coach/presentation/pages/ai_coach_page.dart';
import 'package:tommy/view/features/assessment/presentation/pages/ai_assessment_page.dart';
import 'package:tommy/view/features/assessment/presentation/pages/assessment_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/create_new_password_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/login_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/splash_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/verification_code_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/welcome_page.dart';
import 'package:tommy/view/features/home/presentation/pages/dashboard_page.dart';
import 'package:tommy/view/features/home/presentation/pages/home_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/assessment_history_detail_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/assessment_history_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/change_password_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/profile_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/static_content_page.dart';
import 'package:tommy/view/features/progress/presentation/pages/progress_page.dart';

abstract final class AppRoute {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/home';
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String signUpVerification = '/sign-up/verification';
  static const String profileSetup = '/profile-setup';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String assessment = '/assessment';
  static const String aiAssessment = '/assessment/ai';
  static const String dashboard = '/dashboard';
  static const String homePage = '/home/overview';
  static const String aiCoach = '/home/ai-coach';
  static const String progress = '/home/progress';
  static const String profile = '/home/profile';
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String assessmentHistory = '/profile/assessment-history';
  static const String assessmentHistoryDetail =
      '/profile/assessment-history/detail';
  static const String privacyPolicy = '/profile/privacy-policy';
  static const String termsAndConditions = '/profile/terms-and-conditions';
  static const String aboutUs = '/profile/about-us';

  /// Determines the next route based on onboarding flags:
  /// - Both true -> [home]
  /// - Profile incomplete -> [profileSetup]
  /// - Assessment incomplete -> [assessment]
  static String getOnboardingNextRoute({
    required bool isProfileCompleted,
    required bool isInitialAssessmentCompleted,
  }) {
    if (isProfileCompleted && isInitialAssessmentCompleted) {
      return home;
    } else if (!isProfileCompleted) {
      return profileSetup;
    } else {
      return assessment;
    }
  }

  static AuthBloc _buildAuthBloc(BuildContext context) {
    final repo = context.read<AuthRepository>();
    return AuthBloc(
      loginUseCase: LoginUseCase(repo),
      forgotPasswordUseCase: ForgotPasswordUseCase(repo),
      verifyEmailUseCase: VerifyEmailUseCase(repo),
      resendOtpUseCase: ResendOtpUseCase(repo),
      resetPasswordUseCase: ResetPasswordUseCase(repo),
      changePasswordUseCase: ChangePasswordUseCase(repo),
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      splash => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SplashPage(),
      ),
      welcome => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const WelcomePage(),
      ),
      login => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => BlocProvider(
          create: (_) => _buildAuthBloc(context),
          child: const LoginPage(),
        ),
      ),
      signUpVerification => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final email = settings.arguments as String? ?? '';
          return BlocProvider(
            create: (_) => _buildAuthBloc(context),
            child: VerificationCodePage(
              purpose: VerificationPurpose.signUp,
              email: email,
            ),
          );
        },
      ),
      profileSetup => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final token = (settings.arguments as String?) ?? PrefsHelper.token;
          final repo = context.read<ProfileRepository>();
          return BlocProvider(
            create: (_) => ProfileBloc(
              updateProfileUseCase: UpdateProfileUseCase(repo),
            ),
            child: ProfileSetupPage(token: token),
          );
        },
      ),
      forgotPassword => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => BlocProvider(
          create: (_) => _buildAuthBloc(context),
          child: const ForgotPasswordPage(),
        ),
      ),
      verificationCode => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final email = settings.arguments as String? ?? '';
          return BlocProvider(
            create: (_) => _buildAuthBloc(context),
            child: VerificationCodePage(
              purpose: VerificationPurpose.passwordReset,
              email: email,
            ),
          );
        },
      ),
      createNewPassword => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final argToken = settings.arguments as String?;
          final token = (argToken != null && argToken.isNotEmpty)
              ? argToken
              : (PrefsHelper.resetToken.isNotEmpty
                  ? PrefsHelper.resetToken
                  : PrefsHelper.token);
          return BlocProvider(
            create: (_) => _buildAuthBloc(context),
            child: CreateNewPasswordPage(token: token),
          );
        },
      ),
      assessment => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<AssessmentRepository>();
          return BlocProvider(
            create: (_) => AssessmentBloc(
              getInitialAssessmentUseCase: GetInitialAssessmentUseCase(repo),
              submitInitialAssessmentUseCase:
                  SubmitInitialAssessmentUseCase(repo),
            )..add(const FetchAssessmentEvent()),
            child: const AssessmentPage(),
          );
        },
      ),
      aiAssessment => MaterialPageRoute<bool>(
        settings: settings,
        builder: (context) {
          final assessmentId = settings.arguments as String? ?? '';
          final repo = context.read<AssessmentRepository>();
          return BlocProvider(
            create: (_) => AiAssessmentCubit(
              getAiAssessmentUseCase: GetAiAssessmentUseCase(repo),
              submitAiAssessmentUseCase: SubmitAiAssessmentUseCase(repo),
            )..loadAiAssessment(assessmentId),
            child: AiAssessmentPage(assessmentId: assessmentId),
          );
        },
      ),
      home || dashboard => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<HomeRepository>();
          return BlocProvider(
            create: (_) => HomeBloc(
              getHomeDataUseCase: GetHomeDataUseCase(repo),
            )..add(const FetchHomeDataEvent()),
            child: const DashboardPage(),
          );
        },
      ),
      homePage => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<HomeRepository>();
          return BlocProvider(
            create: (_) => HomeBloc(
              getHomeDataUseCase: GetHomeDataUseCase(repo),
            )..add(const FetchHomeDataEvent()),
            child: const HomePage(),
          );
        },
      ),
      aiCoach => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const AiCoachPage(),
      ),
      progress => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const ProgressPage(),
      ),
      profile => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const ProfilePage(),
      ),
      editProfile => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final employee = settings.arguments as EmployeeProfile?;
          final repo = context.read<ProfileRepository>();
          return BlocProvider(
            create: (_) => ProfileBloc(
              updateProfileUseCase: UpdateProfileUseCase(repo),
              getProfileUseCase: GetProfileUseCase(repo),
            ),
            child: EditProfilePage(profile: employee),
          );
        },
      ),
      changePassword => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => BlocProvider(
          create: (_) => _buildAuthBloc(context),
          child: const ChangePasswordPage(),
        ),
      ),
      assessmentHistory => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<AssessmentRepository>();
          return BlocProvider(
            create: (_) => AssessmentHistoryCubit(
              getAssessmentHistoryUseCase: GetAssessmentHistoryUseCase(repo),
            )..fetchHistory(),
            child: const AssessmentHistoryPage(),
          );
        },
      ),
      assessmentHistoryDetail => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final args = settings.arguments;
          final assessmentId = switch (args) {
            AssessmentHistoryItemModel(:final assessmentId) => assessmentId,
            String id => id,
            _ => '',
          };
          final repo = context.read<AssessmentRepository>();
          return BlocProvider(
            create: (_) => AssessmentDetailCubit(
              getAssessmentDetailUseCase: GetAssessmentDetailUseCase(repo),
            )..fetchDetail(assessmentId),
            child: AssessmentHistoryDetailPage(assessmentId: assessmentId),
          );
        },
      ),
      privacyPolicy => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<ProfileRepository>();
          return BlocProvider(
            create: (_) => LegalContentCubit(
              getLegalContentUseCase: GetLegalContentUseCase(repo),
            )..fetchContent('privacy-policy'),
            child: const StaticContentPage(
              title: 'Privacy Policy',
              slug: 'privacy-policy',
            ),
          );
        },
      ),
      termsAndConditions => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<ProfileRepository>();
          return BlocProvider(
            create: (_) => LegalContentCubit(
              getLegalContentUseCase: GetLegalContentUseCase(repo),
            )..fetchContent('terms-and-conditions'),
            child: const StaticContentPage(
              title: 'Terms & Conditions',
              slug: 'terms-and-conditions',
            ),
          );
        },
      ),
      aboutUs => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) {
          final repo = context.read<ProfileRepository>();
          return BlocProvider(
            create: (_) => LegalContentCubit(
              getLegalContentUseCase: GetLegalContentUseCase(repo),
            )..fetchContent('about-us'),
            child: const StaticContentPage(
              title: 'About Us',
              slug: 'about-us',
            ),
          );
        },
      ),
      _ => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const _UnknownRoutePage(),
      ),
    };
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoute.dashboard, (route) => false),
          child: const Text('Go home'),
        ),
      ),
    );
  }
}
