import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              CommonButton(
                titleText: 'Continue',
                titleColor: Colors.black,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoute.dashboard);
                },
              ),
              SizedBox(height: 20.h),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CommonText(
                      text: 'Don\'t have an account? ',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoute.signUp),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: const Size(44, 44),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      child: const CommonText(
                        text: 'Create',
                        color: Color(0xFFD48B3B),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
