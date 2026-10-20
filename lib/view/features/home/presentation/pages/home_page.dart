import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/features/home/data/models/home_data_model.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_bloc.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_event.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD48B3B),
                  ),
                );
              }

              if (state is HomeError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 60,
                        ),
                        SizedBox(height: 16.h),
                        CommonText(
                          text: state.message,
                          color: Colors.white,
                          fontSize: 16,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        CommonButton(
                          titleText: 'Retry',
                          titleColor: Colors.black,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          onTap: () {
                            context.read<HomeBloc>().add(
                              const FetchHomeDataEvent(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is HomeLoaded) {
                final data = state.homeData;
                return RefreshIndicator(
                  color: const Color(0xFFD48B3B),
                  backgroundColor: const Color(0xFF140D0B),
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const FetchHomeDataEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        _buildHeader(data.profile),
                        SizedBox(height: 24.h),
                        _buildScoreCard(data),
                        SizedBox(height: 20.h),
                        _buildCategoryScores(data.scores),
                        SizedBox(height: 28.h),
                        _buildTodayPlan(context, data),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(HomeProfileModel profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/image/logo.png', width: 140.w),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white24,
          backgroundImage: profile.profilePhoto.isNotEmpty
              ? NetworkImage(profile.profilePhoto)
              : null,
          onBackgroundImageError: profile.profilePhoto.isNotEmpty
              ? (_, __) {}
              : null,
          child: profile.profilePhoto.isEmpty
              ? const Icon(Icons.person, color: Colors.white70)
              : null,
        ),
      ],
    );
  }

  Widget _buildScoreCard(HomeDataModel data) {
    final profile = data.profile;
    final scores = data.scores;
    final cycle = data.cycle;
    final overallRatio = (scores.overall / 100.0).clamp(0.0, 1.0);
    final dayRatio = (cycle.dayProgressPercent / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF4D4D4D)),
          borderRadius: BorderRadius.circular(16),
        ),
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
                          value: overallRatio,
                          strokeWidth: 8,
                          backgroundColor: Colors.white10,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD48B3B),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText(
                                text: '${scores.overall}',
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                lineHeight: 1,
                              ),
                              const CommonText(
                                text: '/100',
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  const CommonText(
                    text: 'Overall Score',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ],
              ),
              SizedBox(width: 24.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: profile.fullName.isNotEmpty
                          ? profile.fullName
                          : 'Jordan Mitchell',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 4.h),
                    CommonText(
                      text: profile.designation.isNotEmpty
                          ? profile.designation
                          : 'Employee',
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF382312),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Color(0xFFD48B3B),
                            size: 12,
                          ),
                          SizedBox(width: 4.w),
                          CommonText(
                            text: 'Day ${cycle.day} of ${cycle.totalDays}',
                            color: const Color(0xFFD48B3B),
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: dayRatio,
                            backgroundColor: Colors.white10,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFD48B3B),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CommonText(
                          text: '${cycle.dayProgressPercent.toInt()}%',
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (data.aiRecommendation.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'AI Recommendation:',
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                  SizedBox(height: 8.h),
                  CommonText(
                    text: data.aiRecommendation,
                    color: Colors.white,
                    fontSize: 13,
                    maxLines: 4,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryScores(HomeScoresModel scores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildScoreBox(
          '${scores.behavioral}%',
          'Behavioral',
          const Color(0xFFD48B3B),
        ),
        _buildScoreBox(
          '${scores.emotional}%',
          'Emotional',
          const Color(0xFFA55EFC),
        ),
        _buildScoreBox(
          '${scores.leadership}%',
          'Leadership',
          const Color(0xFF32C68A),
        ),
        _buildScoreBox(
          '${scores.communication}%',
          'Communication',
          const Color(0xFFFBE1A6),
        ),
      ],
    );
  }

  Widget _buildTodayPlan(BuildContext context, HomeDataModel data) {
    final todayPlan = data.todayPlan;
    final completedCount = todayPlan.calculatedCompletedCount;
    final totalCount = todayPlan.calculatedTotalCount;
    final progress = totalCount > 0
        ? (completedCount / totalCount).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonText(
              text: "Today's Plan",
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            RichText(
              text: TextSpan(
                text: '$completedCount/$totalCount ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                children: const [
                  TextSpan(
                    text: 'done',
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white10,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(0xFFD48B3B),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        SizedBox(height: 20.h),
        if (todayPlan.tasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF161111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: const CommonText(
              text: 'No tasks scheduled for today.',
              color: Colors.white54,
              fontSize: 14,
            ),
          )
        else
          ...todayPlan.tasks.map(
            (task) => _buildTaskTile(
              context: context,
              task: task,
              data: data,
            ),
          ),
      ],
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
          CommonText(
            text: score,
            color: scoreColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 4.h),
          CommonText(text: label, color: Colors.white54, fontSize: 9),
        ],
      ),
    );
  }

  Widget _buildTaskTile({
    required BuildContext context,
    required HomeTaskModel task,
    required HomeDataModel data,
  }) {
    final isDone = task.completed;
    final categoryColor = _getCategoryColor(task.category);
    final category = _formatCategory(task.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF0C1914) : const Color(0xFF161111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone
              ? const Color(0xFF32C68A).withOpacity(0.3)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          isDone
              ? const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF32C68A),
                  size: 24,
                )
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
                CommonText(
                  text: task.title,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                CommonText(text: category, color: categoryColor, fontSize: 10),
              ],
            ),
          ),
          if (!isDone)
            GestureDetector(
              onTap: () async {
                final targetId = task.id.isNotEmpty
                    ? task.id
                    : ((task.assessmentId != null &&
                            task.assessmentId!.isNotEmpty)
                        ? task.assessmentId!
                        : (data.nextAssessment?.assessmentId ?? ''));

                if (targetId.trim().isEmpty) {
                  showAppSnackBar(
                    context,
                    message: 'Task / Assessment ID not found.',
                    isSuccess: false,
                  );
                  return;
                }

                final result = await Navigator.pushNamed(
                  context,
                  AppRoute.aiAssessment,
                  arguments: targetId,
                );

                if (result == true && context.mounted) {
                  context.read<HomeBloc>().add(const FetchHomeDataEvent());
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF382312),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CommonText(
                      text: 'Start',
                      color: Color(0xFFD48B3B),
                      fontSize: 12,
                    ),
                    SizedBox(width: 4.w),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFD48B3B),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'behavioral':
        return const Color(0xFFD48B3B);
      case 'emotional':
        return const Color(0xFFA55EFC);
      case 'leadership':
        return const Color(0xFF32C68A);
      case 'communication':
        return const Color(0xFFFBE1A6);
      default:
        return const Color(0xFFD48B3B);
    }
  }

  String _formatCategory(String category) {
    if (category.isEmpty) return '';
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }
}
