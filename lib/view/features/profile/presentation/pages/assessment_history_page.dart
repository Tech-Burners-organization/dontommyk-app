import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';

class AssessmentHistoryPage extends StatelessWidget {
  const AssessmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
                        text: 'Assessment History',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildHistoryItem(
                    context,
                    1,
                    'Emotional Intelligence Survey',
                    'June 15, 2026',
                    '68/100',
                    const Color(0xFFA55EFC),
                  ),
                  _buildHistoryItem(
                    context,
                    2,
                    'Communication Skills Test',
                    'August 22, 2026',
                    '82/100',
                    const Color(0xFFD48B3B),
                  ),
                  _buildHistoryItem(
                    context,
                    3,
                    'Leadership Style Evaluation',
                    'July 10, 2026',
                    '75/100',
                    const Color(0xFF32C68A),
                  ),
                  _buildHistoryItem(
                    context,
                    4,
                    'Daily reflection',
                    'September 5, 2026',
                    '60/100',
                    const Color(0xFFD48B3B),
                  ),
                  _buildHistoryItem(
                    context,
                    5,
                    'Team Collaboration Assessment',
                    'August 15, 2026',
                    '85/100',
                    const Color(0xFF32C68A),
                  ),
                  _buildHistoryItem(
                    context,
                    6,
                    'Team Collaboration Exercise',
                    'November 5, 2026',
                    '88/100',
                    const Color(0xFFD48B3B),
                  ),
                  _buildHistoryItem(
                    context,
                    7,
                    'Emotional Intelligence Survey',
                    'June 15, 2026',
                    '68/100',
                    const Color(0xFFA55EFC),
                  ),
                  _buildHistoryItem(
                    context,
                    8,
                    'Weekly review',
                    'September 12, 2026',
                    '70/100',
                    const Color(0xFFD48B3B),
                  ),
                  _buildHistoryItem(
                    context,
                    9,
                    'Team Collaboration Assessment',
                    'August 15, 2026',
                    '85/100',
                    const Color(0xFF32C68A),
                  ),
                  _buildHistoryItem(
                    context,
                    10,
                    'Team Collaboration Assessment',
                    'August 15, 2026',
                    '85/100',
                    const Color(0xFF32C68A),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    int index,
    String title,
    String date,
    String score,
    Color scoreColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.assessmentHistoryDetail);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF161111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            CommonText(
              text: index.toString(),
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 4.h),
                  CommonText(text: date, color: scoreColor, fontSize: 10),
                ],
              ),
            ),
            CommonText(
              text: score,
              color: scoreColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
