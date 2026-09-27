import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
                        text: 'Edit Profile Details',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 30.h),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD48B3B),
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://i.pravatar.cc/150?img=11',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
              SizedBox(height: 40.h),
              const CommonText(
                text: 'Full Name',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter your full name',
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Email',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter your email',
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Your Role',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter your role',
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Your Age',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter your age',
                fillColor: Colors.white.withOpacity(0.05),
                fieldBorderColor: Colors.white12,
                fieldBorderRadius: 14,
                textStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white38),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Location',
                color: Colors.white,
                fontSize: 14,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter your location',
                suffixIcon: const Icon(
                  Icons.location_on_outlined,
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
                titleText: 'Save & Changes',
                titleColor: Colors.black,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
