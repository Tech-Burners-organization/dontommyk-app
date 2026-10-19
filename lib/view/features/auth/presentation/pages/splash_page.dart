import 'package:flutter/material.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (PrefsHelper.token.isNotEmpty) {
          final nextRoute = AppRoute.getOnboardingNextRoute(
            isProfileCompleted: PrefsHelper.isProfileCompleted,
            isInitialAssessmentCompleted:
                PrefsHelper.isInitialAssessmentCompleted,
          );
          Navigator.pushReplacementNamed(
            context,
            nextRoute,
            arguments: PrefsHelper.token,
          );
        } else {
          Navigator.pushReplacementNamed(context, AppRoute.welcome);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset('assets/image/logo.png', width: 250)),
              const CommonText(
                text:
                    'AI-Powered Workforce Alignment & Professional\nEffectiveness',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                maxLines: 2,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
