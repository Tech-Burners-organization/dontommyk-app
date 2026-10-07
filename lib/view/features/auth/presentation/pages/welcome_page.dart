import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/image/logo.png', width: 200.w),
                      SizedBox(height: 20.h),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icon/tik.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: CommonText(
                                text:
                                    'Training course completed — welcome aboard',
                                color: const Color(0x80FFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      const CommonText(
                        text: 'Your alignment journey\nstarts here',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        maxLines: 2,
                      ),
                      SizedBox(height: 10.h),
                      const CommonText(
                        text:
                            'AlignIQ measures how well your personal values, habits, and communication style align with your organization\'s goals — and gives you a personalized roadmap to grow.',
                        color: Color(0x80FFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        maxLines: 5,
                      ),
                      SizedBox(height: 32.h),
                      _buildFeatureTile(
                        'assets/icon/alignment.svg',
                        'Alignment Score',
                        'Know exactly where you stand',
                      ),
                      SizedBox(height: 12.h),
                      _buildFeatureTile(
                        'assets/icon/aiCoatch.svg',
                        'AI Coach',
                        'Personalized 24/7 guidance',
                      ),
                      SizedBox(height: 12.h),
                      _buildFeatureTile(
                        'assets/icon/track.svg',
                        'Track Growth',
                        'See your progress over time',
                      ),
                    ],
                  ),
                ),
              ),
              CommonButton(
                titleText: 'Get Started',
                titleColor: Colors
                    .black, // Changed to black for better contrast on gradient
                trailingIcon: const Icon(
                  Icons.keyboard_double_arrow_right,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoute.login);
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(String iconPath, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [const Color(0x6667696D), const Color(0x661A1F2A)],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0x7F364153)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 40,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: title,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              CommonText(
                text: subtitle,
                color: Color(0x80FFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
