import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/view/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nameController = TextEditingController(
    text: kDebugMode ? 'Jordan Mitchell' : '',
  );
  final _roleController = TextEditingController(
    text: kDebugMode ? 'Senior Product Manager' : '',
  );
  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImagePath = picked.path;
      });
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    final role = _roleController.text.trim();

    if (name.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter your name',
        isSuccess: false,
      );
      return;
    }

    if (role.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter your role',
        isSuccess: false,
      );
      return;
    }

    final parts = name.split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    context.read<ProfileBloc>().add(
      UpdateProfileSubmitted(
        firstName: firstName,
        lastName: lastName,
        designation: role,
        imagePath: _selectedImagePath,
      ),
    );
  }

  void _skip() {
    final nextRoute = AppRoute.getOnboardingNextRoute(
      isProfileCompleted: PrefsHelper.isProfileCompleted,
      isInitialAssessmentCompleted: PrefsHelper.isInitialAssessmentCompleted,
    );
    Navigator.pushReplacementNamed(context, nextRoute);
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
                SizedBox(height: 16.h),
                Center(child: Image.asset('assets/image/logo.png', width: 180.w)),
                SizedBox(height: 24.h),
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
                SizedBox(height: 28.h),

                // Avatar / Image Picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 96.w,
                          height: 96.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD48B3B),
                              width: 2,
                            ),
                            color: Colors.white.withValues(alpha: 0.08),
                            image: _selectedImagePath != null
                                ? DecorationImage(
                                    image: FileImage(File(_selectedImagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _selectedImagePath == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white54,
                                  size: 48,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD48B3B),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                const CommonText(
                  text: 'Name',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter Your Name',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.white38,
                  ),
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
                  prefixIcon: const Icon(
                    Icons.work_outline,
                    color: Colors.white38,
                  ),
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
                  onFieldSubmitted: (_) => _submit(),
                ),
                SizedBox(height: 36.h),

                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
                      );
                      final nextRoute = AppRoute.getOnboardingNextRoute(
                        isProfileCompleted: true,
                        isInitialAssessmentCompleted:
                            PrefsHelper.isInitialAssessmentCompleted,
                      );
                      Navigator.pushReplacementNamed(context, nextRoute);
                    } else if (state is ProfileFailure) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CommonButton(
                      isLoading: state is ProfileLoading,
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
                      onTap: _submit,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Center(
                  child: TextButton(
                    onPressed: _skip,
                    child: const CommonText(
                      text: 'Skip',
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
