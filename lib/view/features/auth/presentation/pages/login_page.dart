import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

import 'package:tommy/view/component/custom_snacbar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(
    text: kDebugMode ? "topupremium3317@gmail.com" : "",
  );
  final _passwordController = TextEditingController(
    text: kDebugMode ? "Topu123@" : "",
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Center(child: Image.asset('assets/image/logo.png', width: 200.w)),
              SizedBox(height: 40.h),
              const Center(
                child: CommonText(
                  text: 'Welcome to EXCELLENT\nSTRATEGIES',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 8.h),
              const Center(
                child: CommonText(
                  text: 'Align Awareness. Optimize Performance.',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 40.h),
              const CommonText(
                text: 'Email',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _emailController,
                hintText: 'Enter Your Email',
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  color: Colors.white38,
                ),
                fillColor: Colors.white.withValues(alpha: 0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                hintStyle: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white38,
                ),
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Password',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: _passwordController,
                hintText: '••••••••',
                isPassword: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.white38,
                ),
                fillColor: Colors.white.withValues(alpha: 0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                hintStyle: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white38,
                ),
                cursorColor: Colors.white,
                suffixIconColor: Colors.white38,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                autofillHints: const [AutofillHints.password],
                autocorrect: false,
                enableSuggestions: false,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: true,
                          onChanged: (val) {},
                          activeColor: const Color(0xFFD48B3B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const CommonText(
                        text: 'Remember Me',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoute.forgotPassword),
                    child: const CommonText(
                      text: 'Forgot Password',
                      color: Color(0xFFD48B3B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    showAppSnackBar(
                      context,
                      message: 'User logged in successfully.',
                      isSuccess: true,
                    );

                    final onboarding = state.loginData.onboarding;
                    final nextRoute = AppRoute.getOnboardingNextRoute(
                      isProfileCompleted: onboarding.isProfileCompleted,
                      isInitialAssessmentCompleted:
                          onboarding.isInitialAssessmentCompleted,
                    );
                    debugPrint('[Login] Success! AccessToken length: ${state.loginData.accessToken.length}, NextRoute: $nextRoute');
                    Navigator.pushReplacementNamed(
                      context,
                      nextRoute,
                      arguments: state.loginData.accessToken,
                    );
                  } else if (state is AuthNeedsVerification) {
                    showAppSnackBar(
                      context,
                      message: state.message,
                      isSuccess: false,
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoute.signUpVerification,
                      arguments: state.email,
                    );
                  } else if (state is AuthFailure) {
                    showAppSnackBar(
                      context,
                      message: state.message,
                      isSuccess: false,
                    );
                  }
                },
                builder: (context, state) {
                  return CommonButton(
                    isLoading: state is AuthLoading,
                    titleText: 'Continue',
                    titleColor: Colors.black,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    onTap: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;
                      if (email.isEmpty) {
                        showAppSnackBar(
                          context,
                          message: 'Please enter your email',
                          isSuccess: false,
                        );
                        return;
                      }
                      if (password.isEmpty) {
                        showAppSnackBar(
                          context,
                          message: 'Please enter your password',
                          isSuccess: false,
                        );
                        return;
                      }
                      context.read<AuthBloc>().add(
                        LoginSubmitted(email: email, password: password),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
