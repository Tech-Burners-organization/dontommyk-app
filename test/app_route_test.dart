import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/features/ai_coach/presentation/pages/ai_coach_page.dart';
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

void main() {
  testWidgets('every app route resolves to its expected page', (tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final expectedPages = <String, Type>{
      AppRoute.splash: SplashPage,
      AppRoute.welcome: WelcomePage,
      AppRoute.login: LoginPage,
      AppRoute.signUpVerification: VerificationCodePage,
      AppRoute.profileSetup: ProfileSetupPage,
      AppRoute.forgotPassword: ForgotPasswordPage,
      AppRoute.verificationCode: VerificationCodePage,
      AppRoute.createNewPassword: CreateNewPasswordPage,
      AppRoute.assessment: AssessmentPage,
      AppRoute.home: DashboardPage,
      AppRoute.dashboard: DashboardPage,
      AppRoute.homePage: HomePage,
      AppRoute.aiCoach: AiCoachPage,
      AppRoute.progress: ProgressPage,
      AppRoute.profile: ProfilePage,
      AppRoute.editProfile: EditProfilePage,
      AppRoute.changePassword: ChangePasswordPage,
      AppRoute.assessmentHistory: AssessmentHistoryPage,
      AppRoute.assessmentHistoryDetail: AssessmentHistoryDetailPage,
      AppRoute.privacyPolicy: StaticContentPage,
      AppRoute.termsAndConditions: StaticContentPage,
      AppRoute.aboutUs: StaticContentPage,
    };

    for (final entry in expectedPages.entries) {
      final route = AppRoute.onGenerateRoute(RouteSettings(name: entry.key));
      expect(route, isA<MaterialPageRoute<void>>(), reason: entry.key);

      final page = (route as MaterialPageRoute<void>).builder(context);
      expect(page.runtimeType, entry.value, reason: entry.key);
    }
  });

  testWidgets('OTP routes use explicit typed verification purposes', (
    tester,
  ) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    VerificationCodePage pageFor(String routeName) {
      final route = AppRoute.onGenerateRoute(RouteSettings(name: routeName));
      return (route as MaterialPageRoute<void>).builder(context)
          as VerificationCodePage;
    }

    expect(
      pageFor(AppRoute.verificationCode).purpose,
      VerificationPurpose.passwordReset,
    );
    expect(
      pageFor(AppRoute.signUpVerification).purpose,
      VerificationPurpose.signUp,
    );
  });
}
