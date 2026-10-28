import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';

enum VerificationPurpose { passwordReset, signUp }

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({
    this.purpose = VerificationPurpose.passwordReset,
    this.email,
    super.key,
  });

  final VerificationPurpose purpose;
  final String? email;

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;
  int _secondsRemaining = 59;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    final defaultDigits = ['', '', '', ''];
    _controllers = List.generate(
      4,
      (index) => TextEditingController(text: defaultDigits[index]),
    );
    _focusNodes = List.generate(4, (_) => FocusNode());
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 59;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _secondsRemaining = 0;
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOtp() => _controllers.map((c) => c.text.trim()).join();

  void _resendCode(String email) {
    if (!_canResend) return;
    context.read<AuthBloc>().add(ResendOtpSubmitted(email: email));
    _startCountdown();
  }

  void _submit(String email) {
    if (email.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: 'Email address is missing.',
        isSuccess: false,
      );
      return;
    }
    final otp = _getOtp();
    if (otp.length < 4) {
      showAppSnackBar(
        context,
        message: 'Please enter the complete 4-digit code',
        isSuccess: false,
      );
      return;
    }

    context.read<AuthBloc>().add(
      VerifyEmailSubmitted(email: email.trim(), otp: otp),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArg = ModalRoute.of(context)?.settings.arguments as String?;
    final effectiveEmail = (widget.email != null && widget.email!.isNotEmpty)
        ? widget.email!
        : (routeArg ?? '');

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/image/logo.png', width: 200.w),
                SizedBox(height: 40.h),
                const CommonText(
                  text: 'Verification Code',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 8.h),
                CommonText(
                  text: effectiveEmail.isNotEmpty
                      ? 'Enter the verification code sent to\n$effectiveEmail'
                      : 'Enter the verification code that we have sent to\nyour email.',
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CustomTextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          textInputAction: index == 3
                              ? TextInputAction.done
                              : TextInputAction.next,
                          fillColor: Colors.transparent,
                          fieldBorderColor: Colors.white38,
                          fieldBorderRadius: 30,
                          textStyle: const TextStyle(
                            color: Color(0xFFD48B3B),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          cursorColor: const Color(0xFFD48B3B),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            if (_getOtp().length == 4) {
                              _submit(effectiveEmail);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CommonText(
                      text: 'Didn\'t receive the code? ',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    GestureDetector(
                      onTap: _canResend ? () => _resendCode(effectiveEmail) : null,
                      child: CommonText(
                        text: 'Resend code',
                        color: _canResend ? Colors.redAccent : Colors.white38,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                CommonText(
                  text: _canResend
                      ? 'You can now resend the code'
                      : 'Resend code at 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                  color: Colors.white54,
                  fontSize: 14,
                ),
                SizedBox(height: 40.h),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is VerifyEmailSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
                      );
                      final tokenToPass = state.token.isNotEmpty
                          ? state.token
                          : (PrefsHelper.resetToken.isNotEmpty
                              ? PrefsHelper.resetToken
                              : PrefsHelper.token);
                      debugPrint('[VerificationCodePage] Navigating with token: ${tokenToPass.isNotEmpty ? (tokenToPass.length > 25 ? "${tokenToPass.substring(0, 25)}..." : tokenToPass) : "EMPTY"}');
                      switch (widget.purpose) {
                        case VerificationPurpose.passwordReset:
                          Navigator.pushNamed(
                            context,
                            AppRoute.createNewPassword,
                            arguments: tokenToPass,
                          );
                          break;
                        case VerificationPurpose.signUp:
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoute.profileSetup,
                            arguments: tokenToPass,
                          );
                          break;
                      }
                    } else if (state is ResendOtpSuccess) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        isSuccess: true,
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
                      onTap: () => _submit(effectiveEmail),
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
