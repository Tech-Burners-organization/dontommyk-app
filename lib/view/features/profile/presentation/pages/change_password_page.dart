import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Row(
                children: [
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
                  Expanded(
                    child: Center(
                      child: CommonText(
                        text: 'Change Password',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 40.h),
              const CommonText(
                text: 'Old Password',
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
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'New Password',
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
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Confirm Password',
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
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoute.forgotPassword),
                child: const CommonText(
                  text: 'Forgot Password?',
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
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
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
