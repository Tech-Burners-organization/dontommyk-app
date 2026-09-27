import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white38),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 20.h),
              Center(child: Image.asset('assets/image/logo.png', width: 200.w)),
              SizedBox(height: 40.h),
              const Center(
                child: CommonText(
                  text: 'Reset Password',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              const Center(
                child: CommonText(
                  text:
                      'Enter your email, we will send a verification\ncode to your email.',
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
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
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
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
                onTap: () =>
                    Navigator.pushNamed(context, AppRoute.verificationCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
