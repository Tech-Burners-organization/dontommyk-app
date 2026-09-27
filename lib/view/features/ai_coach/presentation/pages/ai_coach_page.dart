import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';

class AiCoachPage extends StatelessWidget {
  const AiCoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildAiBubble('Hi! I\'m your AlignIQ AI Coach. I\'ve analyzed your assessmen results and I\'m here to would you like to work on today?'),
                  SizedBox(height: 24.h),
                  const CommonText(
                    text: 'Hi! I\'m your AlignIQ AI Coach. I\'ve analyzed your assessmen results and I\'m here to give you personalized guidance. What would you like to work on today?',
                    color: Colors.white,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                    maxLines: 4,
                  ),
                  SizedBox(height: 24.h),
                  const CommonText(
                    text: 'Hi! I\'m your AlignIQ AI Coach. I\'ve analyzed your assessmen results and I\'m here to give you personalized guidance. What would you like to work on today?',
                    color: Colors.white,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                    maxLines: 4,
                  ),
                  SizedBox(height: 24.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildUserBubble('I feel stressed'),
                  ),
                  SizedBox(height: 24.h),
                  const CommonText(
                    text: 'Hi! I\'m your AlignIQ AI Coach. I\'ve analyzed your assessmen results and I\'m here to give you personalized guidance. What would you like to work on today?',
                    color: Colors.white,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            
            // Bottom Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChip('I feel stressed'),
                        SizedBox(width: 8.w),
                        _buildChip('Conflict prep'),
                        SizedBox(width: 8.w),
                        _buildChip('Score meaning'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    hintText: 'Type your question',
                    fillColor: Colors.black.withOpacity(0.5),
                    fieldBorderColor: Colors.white38,
                    fieldBorderRadius: 24,
                    prefixIcon: const Icon(Icons.add, color: Colors.white),
                    suffixIcon: const Icon(Icons.send_outlined, color: Colors.white),
                    textStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(color: Colors.white70),
                    cursorColor: Colors.white,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBubble(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF261911),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: CommonText(
        text: text,
        color: Colors.white,
        fontSize: 14,
        textAlign: TextAlign.left,
        maxLines: 4,
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161111),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: CommonText(
        text: text,
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38),
      ),
      child: CommonText(
        text: text,
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }
}
