import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/route/app_route.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              const CommonText(
                text: 'Profile & Settings',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 30.h),

              // User Card
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.editProfile);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161111),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD48B3B),
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/150?img=11',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(
                              text: 'Jordan Mitchell',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 4.h),
                            const CommonText(
                              text: 'Senior Product Manager',
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              _buildMenuTile(
                context,
                Icons.lock_outline,
                'Change Password',
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.changePassword);
                },
              ),
              _buildMenuTile(
                context,
                Icons.history,
                'Assessment History',
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.assessmentHistory);
                },
              ),
              _buildMenuTile(
                context,
                Icons.shield_outlined,
                'Privacy policy',
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.privacyPolicy);
                },
              ),
              _buildMenuTile(
                context,
                Icons.description_outlined,
                'Terms & Conditions',
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.termsAndConditions);
                },
              ),
              _buildMenuTile(
                context,
                Icons.info_outline,
                'About Us',
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.aboutUs);
                },
              ),
              _buildMenuTile(
                context,
                Icons.delete_outline,
                'Delete account',
                isDestructive: true,
                onTap: () {
                  _showDeleteDialog(context);
                },
              ),

              SizedBox(height: 40.h),

              CommonButton(
                titleText: 'Logout',
                titleColor: Colors.redAccent,
                buttonColor: const Color(0xFF161111),
                borderColor: Colors.redAccent.withOpacity(0.5),
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.login,
                  (route) => false,
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF161111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.redAccent : Colors.white70,
              size: 20,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CommonText(
                text: title,
                color: isDestructive ? Colors.redAccent : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CommonText(
                  text:
                      'Are you sure you want to delete your account? This action is permanent and will remove your assessments, progress history, reflections, and development records. This action cannot be undone.',
                  color: Colors.white,
                  fontSize: 14,
                  textAlign: TextAlign.left,
                  lineHeight: 1.5,
                  maxLines: 6,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const CommonText(
                            text: 'Cancel',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const CommonText(
                            text: 'Delete Account',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
