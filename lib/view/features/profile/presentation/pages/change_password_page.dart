import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter your current password',
        isSuccess: false,
      );
      return;
    }

    if (newPassword.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter your new password',
        isSuccess: false,
      );
      return;
    }

    if (newPassword.length < 6) {
      showAppSnackBar(
        context,
        message: 'New password must be at least 6 characters',
        isSuccess: false,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please confirm your new password',
        isSuccess: false,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      showAppSnackBar(
        context,
        message: 'New password and confirm password do not match',
        isSuccess: false,
      );
      return;
    }

    if (oldPassword == newPassword) {
      showAppSnackBar(
        context,
        message: 'New password cannot be the same as your current password',
        isSuccess: false,
      );
      return;
    }

    context.read<AuthBloc>().add(
          ChangePasswordSubmitted(
            currentPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38),
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.chevron_left, color: Colors.white),
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

                // Old Password
                const CommonText(
                  text: 'Old Password',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _oldPasswordController,
                  hintText: '••••••••',
                  isPassword: _obscureOldPassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white38,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureOldPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureOldPassword = !_obscureOldPassword;
                      });
                    },
                  ),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                ),
                SizedBox(height: 20.h),

                // New Password
                const CommonText(
                  text: 'New Password',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _newPasswordController,
                  hintText: '••••••••',
                  isPassword: _obscureNewPassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white38,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                ),
                SizedBox(height: 20.h),

                // Confirm Password
                const CommonText(
                  text: 'Confirm Password',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: '••••••••',
                  isPassword: _obscureConfirmPassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white38,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  fieldBorderColor: Colors.white12,
                  fieldBorderRadius: 14,
                  textStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white38),
                  cursorColor: Colors.white,
                ),
                SizedBox(height: 16.h),

                // Forgot Password link
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

                // Submit Button
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is ChangePasswordSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
                      );
                      Navigator.pop(context);
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
                      onTap: _submit,
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
