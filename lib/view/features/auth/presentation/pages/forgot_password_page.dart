import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/core/utils/validator.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController(
    text: kDebugMode ? "topupremium3317@gmail.com" : "",
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final validationError = Validator.emailValidator(email);
    if (validationError != null) {
      showAppSnackBar(context, message: validationError, isSuccess: false);
      return;
    }
    context.read<AuthBloc>().add(ForgotPasswordSubmitted(email: email));
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
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),
                SizedBox(height: 40.h),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
                      );
                      Navigator.pushNamed(
                        context,
                        AppRoute.verificationCode,
                        arguments: _emailController.text.trim(),
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
                      onTap: _submit,
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
