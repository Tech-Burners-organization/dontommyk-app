import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_assessment_history_usecase.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/assessment_history_cubit.dart';

class AssessmentHistoryPage extends StatelessWidget {
  const AssessmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<AssessmentHistoryCubit>();
      return const _AssessmentHistoryView();
    } catch (_) {
      final repo = context.read<AssessmentRepository>();
      return BlocProvider(
        create: (_) => AssessmentHistoryCubit(
          getAssessmentHistoryUseCase: GetAssessmentHistoryUseCase(repo),
        )..fetchHistory(),
        child: const _AssessmentHistoryView(),
      );
    }
  }
}

class _AssessmentHistoryView extends StatelessWidget {
  const _AssessmentHistoryView();

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('MMMM d, yyyy').format(dt);
    } catch (_) {
      return isoString;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF32C68A); // Green
    if (score >= 65) return const Color(0xFFD48B3B); // Amber / Gold
    return const Color(0xFFA55EFC); // Purple
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            SizedBox(height: 16.h),
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
              child: BlocBuilder<AssessmentHistoryCubit, AssessmentHistoryState>(
                builder: (context, state) {
                  return switch (state) {
                    AssessmentHistoryLoading() ||
                    AssessmentHistoryInitial() =>
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD48B3B),
                        ),
                      ),
                    AssessmentHistoryError(:final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                message.isNotEmpty
                                    ? message
                                    : 'Failed to load assessment history',
                                style: GoogleFonts.figtree(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white54),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Try Again'),
                                onPressed: () {
                                  context
                                      .read<AssessmentHistoryCubit>()
                                      .fetchHistory();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    AssessmentHistoryLoaded(:final history) =>
                      _buildHistoryList(context, history),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<AssessmentHistoryItemModel> items,
  ) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF2C1E11),
      onRefresh: () => context.read<AssessmentHistoryCubit>().fetchHistory(),
      child: items.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: const Icon(
                              Icons.history,
                              color: Colors.white38,
                              size: 44,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No Assessment History',
                            style: GoogleFonts.figtree(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'You have not completed any assessments yet.',
                            style: GoogleFonts.figtree(
                              color: Colors.white54,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildHistoryCard(context, index + 1, item);
              },
            ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    int index,
    AssessmentHistoryItemModel item,
  ) {
    final bool isCompleted = item.isCompleted;
    final int overallScore = item.result?.overallScore ?? 0;
    final Color scoreColor =
        isCompleted ? _getScoreColor(overallScore) : const Color(0xFFD48B3B);

    final String dateText = isCompleted
        ? _formatDate(item.completedAt ?? item.createdAt)
        : (item.scheduledAt != null && item.scheduledAt!.isNotEmpty)
            ? 'Scheduled: ${_formatDate(item.scheduledAt)}'
            : 'Pending';

    final String scoreText = isCompleted ? '$overallScore/100' : 'Pending';

    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          Navigator.pushNamed(
            context,
            AppRoute.assessmentHistoryDetail,
            arguments: item,
          );
        } else {
          showAppSnackBar(
            context,
            message: item.scheduledAt != null
                ? 'This assessment is scheduled for ${_formatDate(item.scheduledAt)}.'
                : 'This assessment is pending.',
            isSuccess: false,
          );
        }
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
            Container(
              width: 32.w,
              alignment: Alignment.center,
              child: CommonText(
                text: index.toString(),
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: item.displayTitle,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    dateText,
                    style: GoogleFonts.figtree(
                      color: isCompleted ? scoreColor : Colors.white54,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scoreColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                scoreText,
                style: GoogleFonts.figtree(
                  color: scoreColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isCompleted) ...[
              SizedBox(width: 8.w),
              const Icon(
                Icons.chevron_right,
                color: Colors.white38,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
