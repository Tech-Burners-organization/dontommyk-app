import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

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
                  text: 'Complete your profile',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              const Center(
                child: CommonText(
                  text: 'Help us personalize your experience',
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40.h),
              const CommonText(text: 'Name', color: Colors.white, fontSize: 14),
              SizedBox(height: 8.h),
              _buildTextField('Enter Your Name'),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Your Role',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              _buildTextField('Enter Your Role'),
              SizedBox(height: 40.h),
              CommonButton(
                titleText: 'Set Up Profile',
                titleColor: Colors.black,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_double_arrow_right,
                  color: Colors.black,
                ),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.login,
                  (route) => false,
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoute.login,
                    (route) => false,
                  ),
                  child: const CommonText(
                    text: 'Skip',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return CustomTextField(
      hintText: hint,
      fillColor: Colors.white.withValues(alpha: 0.05),
      fieldBorderColor: Colors.white12,
      fieldBorderRadius: 14,
      textStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white38),
      cursorColor: Colors.white,
    );
  }
}
