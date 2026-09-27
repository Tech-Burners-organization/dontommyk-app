import 'package:flutter/material.dart';
import 'package:tommy/view/features/ai_coach/presentation/pages/ai_coach_page.dart';
import 'package:tommy/view/features/assessment/presentation/pages/assessment_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/create_new_password_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/login_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:tommy/view/features/auth/presentation/pages/sign_up_page.dart';
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
        builder: (_) => const LoginPage(),
      ),
      signUp => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SignUpPage(),
      ),
      signUpVerification => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) =>
            const VerificationCodePage(purpose: VerificationPurpose.signUp),
      ),
      profileSetup => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const ProfileSetupPage(),
      ),
      forgotPassword => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const ForgotPasswordPage(),
      ),
      verificationCode => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const VerificationCodePage(
          purpose: VerificationPurpose.passwordReset,
        ),
      ),
      createNewPassword => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const CreateNewPasswordPage(),
      ),
      assessment => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const AssessmentPage(),
      ),
      home || dashboard => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const DashboardPage(),
      ),
      homePage => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const HomePage(),
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
        builder: (_) => const EditProfilePage(),
      ),
      changePassword => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const ChangePasswordPage(),
      ),
      assessmentHistory => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const AssessmentHistoryPage(),
      ),
      assessmentHistoryDetail => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const AssessmentHistoryDetailPage(),
      ),
      privacyPolicy => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const StaticContentPage(title: 'Privacy policy'),
      ),
      termsAndConditions => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const StaticContentPage(title: 'Terms & Conditions'),
      ),
      aboutUs => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const StaticContentPage(title: 'About Us'),
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
