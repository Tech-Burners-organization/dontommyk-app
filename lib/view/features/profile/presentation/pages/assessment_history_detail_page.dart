import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';

class AssessmentHistoryDetailPage extends StatelessWidget {
  const AssessmentHistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  SizedBox(width: 16.w),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        text: 'Assessment History ',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(text: '(1 of 10)', style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF261911),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const CommonText(
                  text: 'When you make a mistake at work, your first response is:',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 24.h),
              _buildOption(false, 'Take responsibility for actions'),
              SizedBox(height: 12.h),
              _buildOption(true, 'Blame external factors'), // Selected answer
              SizedBox(height: 12.h),
              _buildOption(false, 'Take responsibility for actions'),
              SizedBox(height: 12.h),
              _buildOption(false, 'Take responsibility for actions'),
              const Spacer(),
              CommonButton(
                titleText: 'Next Question',
                titleColor: Colors.black,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                trailingIcon: const Icon(Icons.chevron_right, color: Colors.black),
                onTap: () {},
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(bool isSelected, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
        border: Border.all(
          color: isSelected ? const Color(0xFFD48B3B) : Colors.white12,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFFD48B3B) : Colors.white38,
                width: isSelected ? 6 : 1,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CommonText(
            text: text,
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
