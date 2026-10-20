import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/view/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({this.token, super.key});

  final String? token;

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _newPasswordController = TextEditingController(
    text: kDebugMode ? "Mirza123@" : "",
  );
  final _confirmPasswordController = TextEditingController(
    text: kDebugMode ? "Mirza123@" : "",
  );

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(String? effectiveToken) async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Please enter a new password',
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
        message: 'Passwords do not match',
        isSuccess: false,
      );
      return;
    }

    var tokenToUse = (effectiveToken != null && effectiveToken.isNotEmpty)
        ? effectiveToken
        : PrefsHelper.resetToken;

    if (tokenToUse.isEmpty) {
      tokenToUse = PrefsHelper.token;
    }
    if (tokenToUse.isEmpty) {
      tokenToUse = AuthRemoteDataSourceImpl.resetPasswordToken;
    }
    if (tokenToUse.isEmpty) {
      tokenToUse = await PrefsHelper.getString('resetToken');
    }
    if (tokenToUse.isEmpty) {
      tokenToUse = await PrefsHelper.getString('token');
    }

    debugPrint('[CreateNewPasswordPage] Submitting ResetPassword with token length: ${tokenToUse.length}');

    if (tokenToUse.isEmpty) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        message: 'Verification token is missing or expired. Please verify your email again.',
        isSuccess: false,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoute.forgotPassword,
        (route) => false,
      );
      return;
    }

    if (!mounted) return;
    context.read<AuthBloc>().add(
      ResetPasswordSubmitted(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        token: tokenToUse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArg = ModalRoute.of(context)?.settings.arguments;
    final tokenFromArg = routeArg is String ? routeArg : null;
    final effectiveToken = (widget.token != null && widget.token!.isNotEmpty)
        ? widget.token!
        : ((tokenFromArg != null && tokenFromArg.isNotEmpty)
            ? tokenFromArg
            : (PrefsHelper.resetToken.isNotEmpty
                ? PrefsHelper.resetToken
                : (PrefsHelper.token.isNotEmpty
                    ? PrefsHelper.token
                    : AuthRemoteDataSourceImpl.resetPasswordToken)));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
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
                    text: 'Create New Password',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                const Center(
                  child: CommonText(
                    text:
                        'Your password must be different from previous\nused password.',
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 40.h),
                const CommonText(
                  text: 'New Password',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _newPasswordController,
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
                  suffixIconColor: Colors.white38,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                const CommonText(
                  text: 'Confirm Password',
                  color: Colors.white,
                  fontSize: 14,
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _confirmPasswordController,
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
                  suffixIconColor: Colors.white38,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(effectiveToken),
                ),
                SizedBox(height: 40.h),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoute.login,
                        (route) => false,
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
                      onTap: () => _submit(effectiveToken),
                    );
                  },
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
