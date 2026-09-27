import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/image/logo.png', width: 140.w),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder for user avatar
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              
              // Score Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1512),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circular Score
                        Column(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: 0.77,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.white10,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD48B3B)),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const CommonText(text: '77', color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, lineHeight: 1),
                                        const CommonText(text: '/100', color: Colors.white54, fontSize: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            const CommonText(text: 'Overall Score', color: Colors.white, fontSize: 12),
                          ],
                        ),
                        SizedBox(width: 24.w),
                        
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CommonText(text: 'Jordan Mitchell', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                              SizedBox(height: 4.h),
                              const CommonText(text: 'Senior Product Manager', color: Colors.white54, fontSize: 12),
                              SizedBox(height: 12.h),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF382312),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.local_fire_department, color: Color(0xFFD48B3B), size: 12),
                                    SizedBox(width: 4.w),
                                    const CommonText(text: 'A recurring 7-day cycle', color: Color(0xFFD48B3B), fontSize: 10),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: 0.15,
                                      backgroundColor: Colors.white10,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD48B3B)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  const CommonText(text: '15%', color: Colors.white54, fontSize: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // AI Recommendation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF262626),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText(text: 'AI Recommendation:', color: Colors.white54, fontSize: 12),
                          SizedBox(height: 8.h),
                          const CommonText(
                            text: 'Practice controlled breathing for 3 minutes today when you feel stressed or emotionally triggered.',
                            color: Colors.white,
                            fontSize: 13,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // 4 Category Scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreBox('78%', 'Behavioral', const Color(0xFFD48B3B)),
                  _buildScoreBox('78%', 'Emotional', const Color(0xFFA55EFC)),
                  _buildScoreBox('78%', 'Leadership', const Color(0xFF32C68A)),
                  _buildScoreBox('78%', 'Communication', const Color(0xFFFBE1A6)),
                ],
              ),
              
              SizedBox(height: 30.h),
              
              // Today's Plan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CommonText(text: 'Today\'s Plan', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  RichText(
                    text: const TextSpan(
                      text: '1/4 ',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(text: 'done', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              LinearProgressIndicator(
                value: 0.25,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD48B3B)),
                borderRadius: BorderRadius.circular(4),
              ),
              SizedBox(height: 20.h),
              
              // Tasks
              _buildTaskTile('Trigger awareness journal', 'Emotional', const Color(0xFFA55EFC), isDone: true),
              _buildTaskTile('Active Listening Challenge', 'Communication', const Color(0xFFFBE1A6)),
              _buildTaskTile('Accountability self-evaluation', 'Leadership', const Color(0xFF32C68A)),
              _buildTaskTile('Daily reflection', 'Behavioral', const Color(0xFFD48B3B)),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBox(String score, String label, Color scoreColor) {
    return Container(
      width: 75.w,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          CommonText(text: score, color: scoreColor, fontSize: 18, fontWeight: FontWeight.w700),
          SizedBox(height: 4.h),
          CommonText(text: label, color: Colors.white54, fontSize: 9),
        ],
      ),
    );
  }

  Widget _buildTaskTile(String title, String category, Color categoryColor, {bool isDone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF0C1914) : const Color(0xFF161111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDone ? const Color(0xFF32C68A).withOpacity(0.3) : Colors.white12),
      ),
      child: Row(
        children: [
          isDone
              ? const Icon(Icons.check_circle_outline, color: Color(0xFF32C68A), size: 24)
              : Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38),
                  ),
                ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(text: title, color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                SizedBox(height: 4.h),
                CommonText(text: category, color: categoryColor, fontSize: 10),
              ],
            ),
          ),
          if (!isDone)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF382312),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CommonText(text: 'Start', color: Color(0xFFD48B3B), fontSize: 12),
                  SizedBox(width: 4.w),
                  const Icon(Icons.chevron_right, color: Color(0xFFD48B3B), size: 14),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
