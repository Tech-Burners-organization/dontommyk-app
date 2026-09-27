import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

enum VerificationPurpose { passwordReset, signUp }

class VerificationCodePage extends StatelessWidget {
  const VerificationCodePage({
    this.purpose = VerificationPurpose.passwordReset,
    super.key,
  });

  final VerificationPurpose purpose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
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
              const CommonText(
                text:
                    'Enter the verification code that we have sent to\nyour email.',
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                maxLines: 2,
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
                        ),
                        cursorColor: const Color(0xFFD48B3B),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
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
                    onTap: () {},
                    child: const CommonText(
                      text: 'Resend code',
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              const CommonText(
                text: 'Resend code at 00:59',
                color: Colors.white54,
                fontSize: 14,
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
                onTap: () => Navigator.pushNamed(context, switch (purpose) {
                  VerificationPurpose.passwordReset =>
                    AppRoute.createNewPassword,
                  VerificationPurpose.signUp => AppRoute.profileSetup,
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
