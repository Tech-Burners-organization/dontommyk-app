import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/core/utils/prefs_helper.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/features/profile/data/models/employee_profile_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';
import 'package:tommy/view/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:tommy/view/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:tommy/view/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:tommy/view/features/profile/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        updateProfileUseCase: UpdateProfileUseCase(
          context.read<ProfileRepository>(),
        ),
        getProfileUseCase: GetProfileUseCase(
          context.read<ProfileRepository>(),
        ),
        deleteAccountUseCase: DeleteAccountUseCase(
          context.read<ProfileRepository>(),
        ),
      )..add(const FetchProfile()),
      child: const _ProfilePageView(),
    );
  }
}

class _ProfilePageView extends StatelessWidget {
  const _ProfilePageView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileDeleteSuccess) {
          showAppSnackBar(
            context,
            message: state.message.isNotEmpty
                ? state.message
                : 'Account deleted successfully.',
            isSuccess: true,
          );
          await PrefsHelper.clearAllData();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoute.login,
              (route) => false,
            );
          }
        } else if (state is ProfileDeleteFailure) {
          showAppSnackBar(
            context,
            message: state.message,
            isSuccess: false,
          );
        }
      },
      builder: (context, state) {
        final isDeleting = state is ProfileDeleting;

        return Stack(
          children: [
            Scaffold(
              body: AppBackground(
                child: SafeArea(
                  child: RefreshIndicator(
                    color: const Color(0xFFD48B3B),
                    backgroundColor: const Color(0xFF140D0B),
                    onRefresh: () async {
                      context.read<ProfileBloc>().add(const FetchProfile());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          const CommonText(
                            text: 'Profile & Settings',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 24.h),

                          // Dynamic User Profile Card
                          _buildUserCard(context),

                          SizedBox(height: 24.h),

                          _buildMenuTile(
                            context,
                            Icons.lock_outline,
                            'Change Password',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.changePassword,
                              );
                            },
                          ),
                          _buildMenuTile(
                            context,
                            Icons.history,
                            'Assessment History',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.assessmentHistory,
                              );
                            },
                          ),
                          _buildMenuTile(
                            context,
                            Icons.shield_outlined,
                            'Privacy policy',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.privacyPolicy,
                              );
                            },
                          ),
                          _buildMenuTile(
                            context,
                            Icons.description_outlined,
                            'Terms & Conditions',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.termsAndConditions,
                              );
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
                            borderColor:
                                Colors.redAccent.withValues(alpha: 0.5),
                            icon: const Icon(Icons.logout,
                                color: Colors.redAccent),
                            onTap: () async {
                              await PrefsHelper.clearAllData();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoute.login,
                                  (route) => false,
                                );
                              }
                            },
                          ),

                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isDeleting)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Deleting account...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final EmployeeProfile? employee = switch (state) {
          ProfileLoaded(:final employee) => employee,
          ProfileSuccess(:final employee) => employee,
          _ => null,
        };

        final name = (employee?.fullName.isNotEmpty == true)
            ? employee!.fullName
            : (PrefsHelper.name.isNotEmpty ? PrefsHelper.name : 'User');

        final role = (employee?.designation.isNotEmpty == true)
            ? employee!.designation
            : (PrefsHelper.role.isNotEmpty
                ? PrefsHelper.role
                : 'Senior Product Manager');

        final photo = (employee?.profilePhoto.isNotEmpty == true)
            ? employee!.profilePhoto
            : PrefsHelper.profileImage;

        return GestureDetector(
          onTap: () async {
            final updated = await Navigator.pushNamed(
              context,
              AppRoute.editProfile,
              arguments: employee,
            );
            if (updated == true && context.mounted) {
              context.read<ProfileBloc>().add(const FetchProfile());
            }
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
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD48B3B),
                      width: 2,
                    ),
                    color: Colors.white.withValues(alpha: 0.08),
                    image: photo.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(photo),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photo.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 28,
                        )
                      : null,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: name,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 4.h),
                      CommonText(
                        text: role,
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
        );
      },
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
                textAlign: TextAlign.start,
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
    final profileBloc = context.read<ProfileBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) {
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
                          onPressed: () => Navigator.pop(dialogContext),
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
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            profileBloc.add(const DeleteAccountSubmitted());
                          },
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
