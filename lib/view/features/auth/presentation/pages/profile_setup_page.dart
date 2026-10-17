import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _proceedToAssessment() {
    final name = _nameController.text.trim();
    final role = _roleController.text.trim();

    if (name.isNotEmpty) {
      PrefsHelper.setString('name', name);
    }
    if (role.isNotEmpty) {
      PrefsHelper.setString('role', role);
    }

    Navigator.pushReplacementNamed(context, AppRoute.assessment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(child: Image.asset('assets/image/logo.png', width: 200.w)),
                SizedBox(height: 32.h),
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
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter Your Name',
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: GoogleFonts.figtree(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: GoogleFonts.figtree(
                    color: Colors.white38,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                const CommonText(
                  text: 'Your Role',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _roleController,
                  hintText: 'Enter Your Role',
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: GoogleFonts.figtree(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: GoogleFonts.figtree(
                    color: Colors.white38,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _proceedToAssessment(),
                ),
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
                  onTap: _proceedToAssessment,
                ),
                SizedBox(height: 24.h),
                Center(
                  child: TextButton(
                    onPressed: _proceedToAssessment,
                    child: const CommonText(
                      text: 'Skip',
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
