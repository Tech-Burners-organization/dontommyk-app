import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/core/utils/validator.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const _goldGradient = LinearGradient(
    colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, AppRoute.signUpVerification);
    }
  }

  void _returnToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoute.login,
      (route) => false,
    );
  }

  TextStyle _fieldStyle(Color color) {
    return GoogleFonts.figtree(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white38),
                        ),
                        child: IconButton(
                          tooltip: 'Back to login',
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          onPressed: _returnToLogin,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Image.asset('assets/image/logo.png', width: 200.w),
                    ),
                    SizedBox(height: 28.h),
                    const Center(
                      child: CommonText(
                        text: 'Create Account',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Center(
                      child: CommonText(
                        text: 'Sign up to begin your alignment journey.',
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    const CommonText(
                      text: 'Email',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Enter Your Email',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: Validator.emailValidator,
                    ),
                    SizedBox(height: 20.h),
                    const CommonText(
                      text: 'Password',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: Validator.passwordValidator,
                      isPassword: true,
                    ),
                    SizedBox(height: 20.h),
                    const CommonText(
                      text: 'Confirm Password',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: _confirmPasswordValidator,
                      isPassword: true,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: 32.h),
                    CommonButton(
                      titleText: 'Create Account',
                      titleColor: Colors.black,
                      gradient: _goldGradient,
                      trailingIcon: const Icon(
                        Icons.keyboard_double_arrow_right,
                        color: Colors.black,
                      ),
                      onTap: _submit,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CommonText(
                            text: 'Already have an account? ',
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          TextButton(
                            onPressed: _returnToLogin,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              minimumSize: const Size(44, 44),
                              tapTargetSize: MaterialTapTargetSize.padded,
                            ),
                            child: const CommonText(
                              text: 'Login',
                              color: Color(0xFFD48B3B),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required Iterable<String> autofillHints,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.white38),
      isPassword: isPassword,
      fillColor: Colors.white.withValues(alpha: 0.05),
      fieldBorderColor: Colors.white12,
      fieldBorderRadius: 14,
      textStyle: _fieldStyle(Colors.white),
      hintStyle: _fieldStyle(Colors.white38),
      cursorColor: Colors.white,
      suffixIconColor: Colors.white38,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.none,
      autofillHints: autofillHints,
      autocorrect: false,
      enableSuggestions: false,
      validator: validator,
      errorMaxLines: 5,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
